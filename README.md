# Deploy Sinatra app

## Создание инстантса GCP, настройка окружения и деплой приложения Ruby Sinatra

**Для создания инстанса и деплоя приложения выполнять команду**

'''bash
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
'''

**Открываем порт приложения в firewall**

'''bash
gcloud compute firewall-rules create simple-app \
  --allow tcp:8080 \
  --source-tags=reddit-app \
  --source-ranges=0.0.0.0/0 \
  --description="allow tcp for app"
'''