# Deploy Sinatra app

## Создание инстантса GCP, настройка окружения и деплой приложения Ruby Sinatra

**Для создания инстанса и деплоя приложения выполнять команду**

```bash
gcloud compute instances create \
  --boot-disk-size=10GB \
  --image=ubuntu-1604-xenial-v20190605 \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script='sudo -u appuser \
        bash -c "wget -O - https://raw.githubusercontent.com/alexwirehead/infra/master/install_ruby.sh | bash && \
                 wget -O - https://raw.githubusercontent.com/alexwirehead/infra/master/install_mongodb.sh | bash && \
                 wget -O - https://raw.githubusercontent.com/alexwirehead/infra/master/deploy.sh | bash"' \
  --zone=europe-west1-b reddit-app
```

**Открываем порт приложения в firewall**

```bash
gcloud compute firewall-rules create puma-server \
  --allow tcp:8080 \
  --target-tags=puma-server \
  --source-ranges=0.0.0.0/0 \
  --description="allow tcp for app"
```

## Выполненые задания по Packer HashiCorp


### В папке packer шаблоны для создания образов в GCP

* immutable.json — bake шаблон с кодом
* ubuntu16.json — шаблон с настроенным окружением, необходим деплой кода
* variables.json — переменные
* scripts — скрипты для настройки и деплоя образов

** Для билда base os image в директории packer выполнить команду:

```bash
 packer build --var-file=variables.json ubuntu16.json
```
** Для создания инстанса из base os image выполнить

```bash
gcloud compute instances create \
  --boot-disk-size=10GB \
  --image=--image=reddit-base-<epoch_creation_time> \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script='sudo -u appuser \
        bash -c "wget -O - https://raw.githubusercontent.com/alexwirehead/infra/master/deploy.sh | bash"' \
  --zone=europe-west1-b reddit-app
```

** Для билда baked os image в директории packer выполнить команду:

```bash
 packer build --var-file=variables.json ubuntu16.json
```

** Для создания инстанса из baked os image выполнить

```bash
gcloud compute instances create \
  --boot-disk-size=10GB \
  --image=--image=reddit-immutable-<epoch_creation_time> \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-b reddit-app
```