pipeline {
    agent any
    
    environment {
        BUILD = ''
        PROD = ''
        DOCKERHUB_CREDENTIALS=credentials('вставить соответсвующий цифровой credential из Jenkins')
    }

    tools {
        terraform 'tf-tool'
    }

    stages {
        stage("Terraform Initialization") {
            steps {
                sh 'terraform init'
            }
        }
        stage("Terraform plan") {
            steps {
                sh 'terraform plan'
            }
        }
        stage("Terraform apply") {
            steps {
                sh 'terraform apply  --auto-approve'
            }
        }
        stage("Waiting for VMs boot"){
            steps {
                echo "Waiting for VMs boot..."
                sh 'sleep 30'
            }
        }
        stage("Get PROD and BUILD IPs") {
            steps {
                script {
                    BUILD = sh( script: 'terraform output --raw BUILD_IP',
                                    returnStdout: true).trim()
                    echo "BUILD: ${BUILD}"
                    PROD = sh( script: 'terraform output --raw PROD_IP',
                                    returnStdout: true).trim()
                    echo "PROD: ${PROD}"
                }
            }
        }
        stage("Add Hosts to inventory") {
            steps {
                script {
                   def data = "${BUILD} ansible_connection=ssh ansible_user=jenkins\n${PROD} ansible_connection=ssh ansible_user=jenkins\n"
                   writeFile(file: 'hosts.inv', text: data)
               }
            }
        }
        stage("Add ssh fingerprint to known_hosts") {
            steps {
                sh """ssh-keyscan ${BUILD} > ~/.ssh/known_hosts"""
                sh """ssh-keyscan ${PROD} >> ~/.ssh/known_hosts"""
            }
        }    
        stage('Prepare VMs to build & deploy') {
            steps {
                sh 'ansible-playbook playbook.yml -i hosts.inv'
            }
        }
        stage("Prepare build & app docker images and push them to registry") {
            steps {
                sh """scp Dockerfile ${BUILD}:/tmp"""              
                sh """ssh ${BUILD} << EOF
	            cd /tmp
                sudo docker build -t mywebapp .
                docker image tag mywebapp proninmo/mywebapp
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push proninmo/mywebapp
                docker logout
EOF""" 
            }
        }
        stage('Pull and run docker app on prod server') {
            steps {
                sh """ssh ${PROD} << EOF
                docker pull proninmo/mywebapp
                docker run -d -p 80:8080 proninmo/mywebapp
EOF"""
                sh """echo Result is here http://${PROD}/hello-1.0/"""
            }
        }
    }
}

