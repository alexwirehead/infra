# Инфраструктурный репозиторий для познания инструментов: Ansible, Terraform, Packer, GCP

## Структура проекта

* ansible — Ansible роли для конфигурации инстанса app-сервера, mongodb-сервера, деплоя приложения Sinatra
* packer — конфигурация базовых Packer образов для развертывания инфраструктуры в GCP
* terraform — Terraform конфигурация инфраструктуры на основе ранее созданых Packer образов GCP

## Развертывание и конфигурация инфраструктуры в GCP

В проекте используется GCP Compute Engine. 
Перед началом работы на машину, с которой будем управлять инфраструктурой, необходимо установить и настроить следующие инструменты:
1. gcloud CLI. Подробнее в [документации](https://cloud.google.com/sdk/docs/how-to)
2. Ansible. Подробнее в [документации](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
3. Packer. Подробнее в [документации](https://www.packer.io/intro/getting-started/install.html)
4. Terraform. Подробнее в [документации](https://learn.hashicorp.com/terraform/getting-started/install.html)
5. Сгенерированный ssh-key добавленный в GCP 

После успешной установки и конфигурации необходимых инструментов можем приступить к развертыванию и конфигурации инфраструктуры.
1. клонируем репозиторий командой:

```bash
git clone https://github.com/alexwirehead/infra.git ~/git
```

2. Переходим в директорию packer и в variables.json для переменной "project_id" указать ID вашего проекта в GCP
```json
{
        "project_id": "<gpc-progect-id>",
        "source_image": "ubuntu-1604-xenial-v20190605"
}
```
3. Соберем базовые образы для app-сервера и mongodb-сервера

```bash
packer build --var-file=variables.json app.json && packer build --var-file=variables.json db.json
```

Успешный результат сборки образов будет — два образа в GCP: reddit-db-base, reddit-app-base
В качестве провиженеров packer используются Ansible playbooks `../ansible/packer_reddit_app.yml` и `../ansible/packer_reddit_db.yml`

4. Развернём инстансы stage используя Terraform, для этого перейдем в директорию `../terraform/stage`
   - В директории создать `terraform.tfvars`, указать ваши значения для переменных:
     ```json
     project = "gpc-progect-id"
     public_key_path = "~/.ssh/<key_file_name>.pub"
     private_key_path = "~/.ssh/<key_file_name>"
     ```
   - Terraform сконфигурирован для использования в качестве remote backend gcs, т.е предварительно необзодимо создать bucket и поменять настройки в `main.tf` в соответствии с созданым bucket, в секции:
     ```
     terraform {
       backend "gcs" {
       bucket  = "<bucket_name>"
       prefix  = "<bucket_prefix_name>"
       }
     }
     ```
   - выполним инициализацию
   ```bash
   terraform int
   ```
   - проверим нашу конфигурацию
   ```bash
   terraform plan
   ```
   - Если terraform plan прошёл успешно, то можем развернуть инстанмы командой
   ```bash
   terraform apply
   ```
   После успешного создание инстансов terrafom вернёть внещние и внутрении ip-ардеса инстансов, которые нам будут необходимы для дальнейшей конфигурации
   - Для удаления инстансов использовать команду
   ```bash
   terraform destroy
   ```

5. Сконфигурируем и задеплоим приложение используя Ansible
   - перейти в папку `../../ansible` в ansible.cfg прописываем следующие значения
   ```
   [defaults]
   inventory = ./environments/stage/hosts
   remote_user = <gpc_remote_user_name>
   private_key_file = <path_to_remote_user_private_key>
   host_key_checking = False
   ```  
   - `./environments/stage/hosts` прописать внешние IP инстансов
   - `./environments/stage/group_vars/app` для переменной **db_host** прописать внутрений IP db-сервера
   - проверим корректность выполнения конфигурации
   ```bash
   ansible-playbook site.yml --check
   ```
   - если все хорошо, то можем накатывать конфигурацию и деплоить риложения
   ```bash
   ansible-playbook site.yml
   ```