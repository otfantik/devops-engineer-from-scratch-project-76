# Деплой Docker-образов с помощью Ansible

[![hexlet-check](https://github.com/otfantik/devops-engineer-from-scratch-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/otfantik/devops-engineer-from-scratch-project-76/actions)

Автоматизация раскатывания контейнеризированного приложения на кластер машин в облаке.

**Учебный проект Хекслета:** [DevOps-инженер с нуля](https://ru.hexlet.io/programs/devops-engineer-from-scratch)  
**Как это должно работать:** [Asciinema](https://asciinema.org/a/v4evn7XjCdou7Yh71IG0ljb0W)

## Ссылка на приложение
**[https://scratch78.ddns.net](https://scratch78.ddns.net)** (Redmine)

## Стек технологий
- **Ansible** — управление конфигурацией и деплой
- **Docker** — контейнеризация приложения
- **Yandex Cloud (VPC, Compute, ALB, Managed PostgreSQL)** — облачная инфраструктура
- **Let's Encrypt** — SSL-сертификат для HTTPS
- **DataDog** — мониторинг и логирование

## Архитектура
- 2 виртуальные машины (Ubuntu 22.04) с приложением Redmine (Docker).
- Application Load Balancer (Yandex Cloud) для балансировки трафика и терминирования TLS.
- Managed PostgreSQL (Yandex Cloud) для хранения данных.
- Группы безопасности (Security Groups) для изоляции трафика между ALB, ВМ и БД.
- Мониторинг состояния (HTTP Check) через DataDog.

## Установка и деплой

### Предварительные требования
- Установленный Ansible на локальной машине.
- Установленный Python 3 и `pip`.
- Настроенный SSH-доступ к серверам (ключ в `~/.ssh/id_ed25519`).
- Настроенный Yandex Cloud CLI (опционально).
- Созданный кластер Managed PostgreSQL и ВМ в Yandex Cloud.

### Клонирование репозитория
```
git clone https://github.com/otfantik/devops-engineer-from-scratch-project-76.git
cd devops-engineer-from-scratch-project-76
```
### Установка зависимостей

Все необходимые роли и коллекции Ansible описаны в requirements.yml. Установка выполняется автоматически в Makefile, но можно установить их вручную:

```
ansible-galaxy install -r requirements.yml
ansible-galaxy collection install community.docker
```
### Настройка инвентаря и переменных

Отредактируйте inventory.ini, указав публичные IP-адреса ваших ВМ и имя пользователя для SSH.
Переменные вынесены в group_vars:

```group_vars/all/vars.yml``` — общие несекретные переменные (порт, образ, пакеты).
```group_vars/webservers/vars.yml``` — переменные, специфичные для веб-серверов.
Секреты хранятся в ```group_vars/webservers/vault.yml``` и зашифрованы с помощью Ansible Vault.
### Работа с секретами (Ansible Vault)

Для просмотра или редактирования секретов используйте команды:

```
make view-secrets
make edit-secrets
```
Для запуска плейбуков, требующих расшифровки Vault, используется флаг --ask-vault-pass, который уже включен в Makefile.

### Подготовка серверов

Устанавливает Docker и необходимые зависимости на обе ВМ:

```
make prepare
```
### Деплой приложения

Запускает контейнер Redmine с подключением к базе данных:

```
make deploy
```

### Мониторинг

Устанавливает и настраивает агент DataDog на веб-серверах, а также HTTP-чек для проверки доступности приложения:

```
make monitoring
```

### Получение SSL-сертификата

Процесс автоматизирован через роль redmine (тег tls-challenge). Токены передаются через переменные окружения ACME_CHALLENGE_TOKEN и ACME_CHALLENGE_CONTENT.

```
export ACME_CHALLENGE_TOKEN="ваш_токен"
export ACME_CHALLENGE_CONTENT="ваше_содержимое"
make tls-challenge
```
---

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>

## О Хекслете

[Хекслет](https://ru.hexlet.io/) — школа программирования: авторские программы обучения с практикой, поддержкой наставников и реальными проектами, которые остаются в резюме. Этот репозиторий — один из таких проектов.