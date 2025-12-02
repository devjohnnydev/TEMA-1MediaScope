# Variáveis de Ambiente para Railway

## Sobre o Erro de SSL (ERR_CERT_AUTHORITY_INVALID)

Este erro geralmente acontece porque:
1. **O certificado SSL ainda está sendo gerado** - Aguarde 5-15 minutos
2. **Cache do navegador** - Limpe o cache ou use aba anônima
3. **Tente acessar novamente** - O Railway gera certificados automaticamente

**Para resolver:**
- Aguarde alguns minutos e atualize a página
- Teste em uma aba anônima (Ctrl+Shift+N)
- Verifique no Railway se o domínio mostra "SSL Active"

---

## Lista Completa de Variáveis

### OBRIGATÓRIAS (Configure no Railway)

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Conexão com PostgreSQL (usa referência automática) |
| `SECRET_KEY` | `sua-chave-secreta-muito-longa-com-50-caracteres-ou-mais` | Chave secreta do Django |
| `DEBUG` | `False` | Desativar modo debug em produção |
| `ALLOWED_HOSTS` | `web-production-a9fb1.up.railway.app` | Seu domínio Railway |
| `CSRF_TRUSTED_ORIGINS` | `https://web-production-a9fb1.up.railway.app` | Origens CSRF confiáveis |

### OPCIONAIS (Para funcionalidades extras)

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `GOOGLE_OAUTH2_KEY` | `123456-abc.apps.googleusercontent.com` | ID cliente Google OAuth |
| `GOOGLE_OAUTH2_SECRET` | `GOCSPX-xxxxxxxxxx` | Segredo Google OAuth |
| `EMAIL_HOST_USER` | `seu-email@gmail.com` | Email para envio SMTP |
| `EMAIL_HOST_PASSWORD` | `xxxx-xxxx-xxxx-xxxx` | Senha de app Gmail |

---

## Como Configurar no Railway

### Passo 1: Adicionar PostgreSQL
1. No seu projeto Railway, clique em **"+ New"**
2. Selecione **"Database"** > **"Add PostgreSQL"**
3. Aguarde a criação

### Passo 2: Configurar Variáveis
1. Clique no seu serviço Django
2. Vá na aba **"Variables"**
3. Clique em **"+ New Variable"** para cada uma:

```
DATABASE_URL = ${{Postgres.DATABASE_URL}}
SECRET_KEY = django-production-key-abc123xyz789-muito-longa-e-segura-aqui
DEBUG = False
ALLOWED_HOSTS = web-production-a9fb1.up.railway.app
CSRF_TRUSTED_ORIGINS = https://web-production-a9fb1.up.railway.app
```

### Passo 3: Gerar SECRET_KEY Segura

Use este comando Python:
```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

Ou acesse: https://djecrety.ir/

---

## Exemplo Visual de Configuração

No painel de Variables do Railway, deve ficar assim:

```
DATABASE_URL         ${{Postgres.DATABASE_URL}}
SECRET_KEY           k#$9xj2&!mq5@8vw3pzl...
DEBUG                False
ALLOWED_HOSTS        web-production-a9fb1.up.railway.app
CSRF_TRUSTED_ORIGINS https://web-production-a9fb1.up.railway.app
```

---

## Verificar se Funcionou

Após configurar e fazer deploy:

1. Vá em **"Deployments"** no Railway
2. Clique no deploy mais recente
3. Nos logs, deve aparecer:
   ```
   DATABASE_URL configured...
   Running migrations...
   Starting Gunicorn server...
   ```

4. Acesse seu site: `https://web-production-a9fb1.up.railway.app`

---

## Problemas Comuns

### Erro: "Application failed to respond"
- Verifique se DATABASE_URL está configurado
- Verifique os logs de deploy

### Erro: "CSRF verification failed"
- Adicione seu domínio em CSRF_TRUSTED_ORIGINS com `https://`

### Erro SSL/Certificado
- Aguarde 5-15 minutos
- Limpe cache do navegador
- Teste em aba anônima

### Erro: "could not translate host name"
- DATABASE_URL está incorreto
- Use `${{Postgres.DATABASE_URL}}` exatamente assim
