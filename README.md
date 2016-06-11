### Intro

Ứng dụng nhỏ bằng Ruby, sử dụng **Roda** (Routing tree web toolkit - dựa trên **CUBA** và inspired bởi **Sinatra**). UBrand Worklogs Assistant cung cấp các API để Dev Team của UBrand có thể logging công việc mình đang làm bất cứ lúc nào bằng cách sử dụng Slack Bot của UBrand.

### How to run this app

#### Production

Mặc định:

```
bundle exec rackup
```

Puma:

```
bundle exec puma -p 3000 -e production
```

#### Development

**rerun**

```
rerun -- rackup --port 3000 config.ru
```