# Сертификационное задание по курсу "DevOps Инженер"
Написать Jenkins pipeline, который разворачивает инстансы в любом Cloud-провайдере, производит на них сборку Java приложения и деплоит приложение на стэйдж. Необходимо использовать код Terraform и Ansible. Приложение должно быть развернуто в контейнере.

[DevOps School](https://devops-school.ru/devops_engineer.html)

# Файлы
1. Jenkinsfile - основной pipeline-файл для Jenkins
2. *.tf - файлы Terraform описывающие создаваемую инфраструктуру и настройки Yandex-провайдера
3. meta.yml - YAML-файл с метаданными и настройками создаваемого в инфраструктуре пользователя
4. key.json - авторизованный ключ сервисного провайдера (см. п 7. Инструкции по настройке и сборке)
5. playbook.yml - playbook для Ansible, подготавливающий ВМ внутри облака к сборке и запуску контейнеров
6. hosts.inv - файл с ip-адресами созданных в облаке ВМ для работы Ansible
7. Dockerfile - сборочный файл докер-контейнера приложения

# Инструкция по настройке и сборке:

0. Создать аккаунт в Yandex Cloud :) 
1. Далее на ПК/ВМ с которого будут производится все действия:
```bash 
   curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
2. Получить токен по ссылке - https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb
3. Выполните команду для настройки вашего профиля CLI.

```bash
yc init 
```
4. Скачать дистрибутив Terraform для вашей платформы из зеркала - https://hashicorp-releases.yandexcloud.net/terraform/
5. (если положить в /usr/bin то не надо) 
```bash 
export PATH=$PATH:/path/to/terraform
```
6. Добавить зеркало terraform yandex: 
```bash
nano .terraformrc
```
```bash
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

7.  Создать авторизованный ключ сервисного провайдера (сам сервисный аккаунт должен быть создан в веб-интерфейсе заранее): 
```bash
yc iam key create --service-account-name <имя_сервисного_аккаунта> --output key.json
```
8.  Установить Jenkins на управляющий host
9.  Сгенерировать пару ключей ssh для пользователя jenkins 
```bash 
   su jenkins 
   ssh-keygen
```
10. Внести открытую часть ключа в meta.yml
11. В файле provider.tf добавить данные об облаке - cloud_id, folder_id, zone (все берется из WEB-интерфейса yandex cloud) 
12. Добавить terraform plugin to Jenkins, настроить его в «Конфигурации глобальных инструментов» и изменить соответствующее имя в модуле tools файла Jenkins 
13. Настроить credentials для доступа к dockerhub, поменять в Jenkins-файл в переменную DOCKERHUB_CREDENTIALS (а также сменить «proninmo» на репозиторий  hub.docker.com куда есть доступ на запись с правами выше)
14. Для удобства запуска из веб-интерфейса Jenkinks основного pipeline проще клонировать данный репозиторий в свой аккаунт на GitHub, настроить описанные здесь конфигурационные файлы в соответсвии со своими данными для доступа к облачному провайдеру и создать Item pipeline в Jenkins со ссылкой на клонированный Git. 
