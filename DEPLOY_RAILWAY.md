# Guia Completo: Deploy no Railway com PostgreSQL

## Passo 1: Criar Conta no Railway

1. Acesse [railway.app](https://railway.app)
2. Clique em **"Login"** ou **"Start a New Project"**
3. Faça login com sua conta do **GitHub** (recomendado) ou email
4. Verifique seu email se necessário

---

## Passo 2: Conectar Repositório GitHub

### 2.1 Subir código para o GitHub (se ainda não fez)

```bash
# No terminal do seu projeto
git init
git add .
git commit -m "Initial commit - Media Scope"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/media-scope.git
git push -u origin main
```

### 2.2 No Railway

1. Clique em **"New Project"**
2. Selecione **"Deploy from GitHub repo"**
3. Autorize o Railway a acessar seus repositórios
4. Selecione o repositório do **Media Scope**

---

## Passo 3: Adicionar Banco de Dados PostgreSQL

### 3.1 Criar o banco

1. No painel do seu projeto Railway, clique em **"+ New"**
2. Selecione **"Database"**
3. Escolha **"Add PostgreSQL"**
4. Aguarde a criação (alguns segundos)

### 3.2 Conectar ao seu app

1. Clique no serviço PostgreSQL criado
2. Vá na aba **"Variables"**
3. Copie a variável `DATABASE_URL`
4. Volte ao seu serviço principal (o app Django)
5. Clique na aba **"Variables"**
6. O Railway já deve ter conectado automaticamente!

> **Nota:** Se não conectou automaticamente, adicione manualmente:
> - Clique em **"+ New Variable"**
> - Nome: `DATABASE_URL`
> - Valor: Cole a URL do PostgreSQL

---

## Passo 4: Configurar Variáveis de Ambiente

No painel do seu app Django no Railway, vá em **"Variables"** e adicione:

### 4.1 Variáveis Obrigatórias

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `SECRET_KEY` | `gere-uma-chave-segura-aqui-com-50-caracteres-minimo` | Chave secreta do Django |
| `DEBUG` | `False` | Desativar modo debug |
| `ALLOWED_HOSTS` | `seu-app.up.railway.app` | Domínio do Railway |
| `CSRF_TRUSTED_ORIGINS` | `https://seu-app.up.railway.app` | Origens CSRF confiáveis |

### 4.2 Como gerar uma SECRET_KEY segura

Execute no terminal Python:
```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

Ou use um gerador online: [djecrety.ir](https://djecrety.ir/)

### 4.3 Variáveis do Google OAuth2 (Login com Google)

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `GOOGLE_OAUTH2_KEY` | `seu-client-id.apps.googleusercontent.com` | ID do cliente Google |
| `GOOGLE_OAUTH2_SECRET` | `seu-client-secret` | Segredo do cliente |

**Para obter as credenciais Google:**
1. Acesse [console.cloud.google.com](https://console.cloud.google.com)
2. Crie um projeto ou selecione existente
3. Vá em **"APIs & Services"** > **"Credentials"**
4. Clique em **"Create Credentials"** > **"OAuth client ID"**
5. Tipo: **"Web application"**
6. Adicione em **"Authorized redirect URIs"**:
   - `https://seu-app.up.railway.app/complete/google-oauth2/`
7. Copie o **Client ID** e **Client Secret**

### 4.4 Variáveis de Email (Opcional)

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `EMAIL_HOST_USER` | `seu-email@gmail.com` | Email para envio |
| `EMAIL_HOST_PASSWORD` | `sua-senha-de-app` | Senha de app do Gmail |

**Para criar senha de app do Gmail:**
1. Acesse [myaccount.google.com/security](https://myaccount.google.com/security)
2. Ative **"Verificação em duas etapas"**
3. Vá em **"Senhas de app"**
4. Crie uma nova senha para "Mail" em "Outro dispositivo"

---

## Passo 5: Configurar o Deploy

### 5.1 Verificar configurações de build

O Railway detectará automaticamente que é um projeto Python/Django. Verifique:

1. Clique no seu serviço
2. Vá em **"Settings"**
3. Em **"Build"**, deve mostrar **"Nixpacks"**
4. Em **"Start Command"**, pode deixar automático ou definir:

```
python manage.py migrate --noinput && python manage.py collectstatic --noinput && gunicorn config.wsgi --bind 0.0.0.0:$PORT
```

### 5.2 Variável PORT

O Railway define automaticamente a variável `PORT`. Não precisa configurar.

---

## Passo 6: Fazer o Deploy

### 6.1 Deploy automático

Se você conectou via GitHub, o Railway fará deploy automaticamente quando:
- Você fizer push no branch `main`
- Salvar variáveis de ambiente

### 6.2 Deploy manual

1. Vá no seu serviço
2. Clique em **"Deploy"** > **"Trigger Deploy"**

### 6.3 Acompanhar o deploy

1. Clique em **"Deployments"**
2. Clique no deploy mais recente
3. Veja os logs em tempo real

---

## Passo 7: Verificar o Banco de Dados

### 7.1 Ver se as migrações rodaram

Nos logs do deploy, você deve ver:
```
Running migrations...
Applying accounts.0001_initial... OK
Applying analytics.0001_initial... OK
...
```

### 7.2 Acessar o banco de dados diretamente

1. Clique no serviço PostgreSQL
2. Vá em **"Data"**
3. Você pode ver e editar as tabelas

### 7.3 Conectar via terminal (opcional)

1. Clique no PostgreSQL
2. Vá em **"Connect"**
3. Copie o comando `psql` ou use a connection string

---

## Passo 8: Configurar Domínio Personalizado (Opcional)

### 8.1 Usar domínio do Railway

1. Vá em **"Settings"** do seu serviço
2. Em **"Domains"**, clique em **"Generate Domain"**
3. Você terá um domínio como `seu-app.up.railway.app`

### 8.2 Usar domínio próprio

1. Em **"Domains"**, clique em **"+ Custom Domain"**
2. Digite seu domínio (ex: `mediascope.com.br`)
3. Configure os DNS do seu domínio:
   - Tipo: `CNAME`
   - Nome: `@` ou `www`
   - Valor: O valor que o Railway mostrar

4. Atualize a variável `ALLOWED_HOSTS`:
```
seu-app.up.railway.app,mediascope.com.br,www.mediascope.com.br
```

5. Atualize `CSRF_TRUSTED_ORIGINS`:
```
https://seu-app.up.railway.app,https://mediascope.com.br,https://www.mediascope.com.br
```

---

## Passo 9: Criar Superusuário Admin

### 9.1 Via Railway Shell

1. No seu serviço, vá em **"Settings"**
2. Role até **"Service"** > **"Railway Shell"**
3. Ou clique em **"..."** > **"Attach Shell"**
4. Execute:

```bash
python manage.py createsuperuser
```

5. Siga as instruções (email, senha)

### 9.2 Acessar o admin

Acesse: `https://seu-app.up.railway.app/admin/`

---

## Passo 10: Monitoramento e Logs

### 10.1 Ver logs em tempo real

1. Clique no seu serviço
2. Vá em **"Deployments"**
3. Selecione o deploy ativo
4. Veja os logs

### 10.2 Métricas

1. Vá em **"Metrics"**
2. Veja uso de CPU, memória, rede

### 10.3 Alertas

1. Vá em **"Settings"** > **"Observability"**
2. Configure alertas de erro

---

## Resumo das Variáveis de Ambiente

```env
# Obrigatórias
SECRET_KEY=sua-chave-secreta-muito-longa-e-aleatoria
DEBUG=False
ALLOWED_HOSTS=seu-app.up.railway.app
CSRF_TRUSTED_ORIGINS=https://seu-app.up.railway.app

# Google OAuth2
GOOGLE_OAUTH2_KEY=123456789-abc.apps.googleusercontent.com
GOOGLE_OAUTH2_SECRET=GOCSPX-xxxxxxxxxxxxxxxx

# Email (opcional)
EMAIL_HOST_USER=seu-email@gmail.com
EMAIL_HOST_PASSWORD=xxxx-xxxx-xxxx-xxxx
```

---

## Solução de Problemas Comuns

### Erro: "Application failed to respond"
- Verifique se `ALLOWED_HOSTS` está correto
- Verifique os logs de deploy

### Erro: "CSRF verification failed"
- Verifique se `CSRF_TRUSTED_ORIGINS` inclui o domínio com `https://`

### Erro: "No module named..."
- Verifique se o `requirements.txt` está atualizado
- Force um novo deploy

### Banco não conecta
- Verifique se `DATABASE_URL` está definido
- Verifique se o PostgreSQL está rodando

### Static files não carregam
- Verifique se `collectstatic` rodou no deploy
- Verifique se `whitenoise` está no middleware

---

## Custos do Railway

- **Hobby Plan**: $5/mês (inclui $5 de créditos)
- **PostgreSQL**: ~$5-10/mês dependendo do uso
- **Starter Plan** (gratuito): 500 horas/mês com limitações

---

## Checklist Final

- [ ] Código no GitHub
- [ ] Projeto criado no Railway
- [ ] PostgreSQL adicionado e conectado
- [ ] Variáveis de ambiente configuradas
- [ ] Deploy realizado com sucesso
- [ ] Migrações aplicadas
- [ ] Superusuário criado
- [ ] Site acessível via domínio Railway
- [ ] Google OAuth2 funcionando (se configurado)
- [ ] Email funcionando (se configurado)

---

Pronto! Seu Media Scope está no ar! 🎉
