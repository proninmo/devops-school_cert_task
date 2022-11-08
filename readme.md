# Инструкция по настройке и сборке:

0. Создать аккаунт в Yandex Cloud :) 
1. Далее на ПК/ВМ с которого будут производится все действия: 
   curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
2. Получить токен по ссылке - https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb
3. Выполните команду yc init для настройки вашего профиля CLI.
4. Скачать дистрибутив Terraform для вашей платформы из зеркала - https://hashicorp-releases.yandexcloud.net/terraform/
5. export PATH=$PATH:/path/to/terraform (если положить в /usr/bin то не надо)
6. Добавить зеркало terraform yandex: nano .terraformrc:

provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}

7.  Создать авторизованный ключ сервисного провайдера: yc iam key create --service-account-name <имя_сервисного_аккаунта> --output key.json (сам сервисный аккаунт должен быть создан в веб-интерфейсе заранее)
8.  Установить Jenkins на управляющий host
9.  Сгенерировать пару ключей ssh для пользователя jenkins (su jenkins - ssh-keygen и т.д.)
10. Внести открытую часть ключа в meta.yml
11. В файле provider.tf добавить данные об облаке - cloud_id, folder_id, zone (все берется из WEB-интерфейса yandex cloud) 
12. Добавить terraform plugin to Jenkins, настроить его в «Конфигурации глобальных инструментов» и изменить соответствующее имя в модуле tools файла Jenkins 
13. Настроить credentials для доступа к dockerhub, поменять в Jenkins-файл в переменную DOCKERHUB_CREDENTIALS (а также сменить «proninmo» на репозиторий  hub.docker.com куда есть доступ на запись с правами выше)
