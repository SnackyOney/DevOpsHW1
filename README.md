# DevOps HW1

## Требования

- Terraform ≥ 1.5
- Ansible ≥ 2.10
- Docker + Docker Compose (локально)
- SSH-доступ к VM (Ubuntu 22.04/24.04)
- Свободные порты: локально — `8000`, на VM — `8090`

## Пункт 1. Git

```bash
git clone <repo-url>
cd DevOpsHW1
git checkout -b feature/infra-setup
```

## Пункт 2. Terraform

Перед запуском указать в `terraform/variables.tf`:
- `vm_ip` — IP VM
- `nginx_port` — свободный порт на VM (по умолчанию `8090`)

В `~/.ssh/config` добавить:

```
Host <VM_IP>
  User student
  IdentityFile ~/.ssh/<your_key>
  StrictHostKeyChecking accept-new
```

Запуск:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Проверка:

```bash
curl -i http://<VM_IP>:8090/
```

Удаление:

```bash
terraform destroy
```

## Пункт 3. Ansible

Перед запуском указать в `ansible/inventory.ini`:
- `ansible_host` — IP VM
- `ansible_user` — пользователь
- `ansible_ssh_private_key_file` — путь к ключу

Запуск:

```bash
cd ansible
ansible-playbook setup_host.yml
```

Проверка идемпотентности:

```bash
ansible-playbook setup_host.yml
```

Проверка на VM:

```bash
ssh student@<VM_IP> "id deployer; systemctl is-enabled docker"
```

## Пункт 4. Docker Compose (локально)

```bash
cd scripts/docker_compose
docker compose up -d
```

Проверка:

```bash
curl -i http://localhost:8000/
curl -s http://localhost:8000/ | grep -i "hello world"
docker compose exec nginx getent hosts app
```

Остановка:

```bash
docker compose down
```

## Пункт 5. monitor.sh

```bash
chmod +x scripts/monitor.sh
./monitor.sh <service-name>
```

Пример:

```bash
./monitor.sh docker
```

На VM:

```bash
ssh student@<VM_IP> "~/DevOpsHW1/scripts/monitor.sh docker"
```
