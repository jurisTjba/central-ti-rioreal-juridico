# Central de Sistemas — Comarca de Rio Real

Site estático (GitHub Pages) com o catálogo de sistemas da comarca e o registro público de **Atividades de TI**.

- `index.html` — todo o site. O catálogo de sistemas é o array `PROJETOS` no início do script.
- `config.js` — URL e chave pública do projeto Supabase (atividades).
- `supabase/schema.sql` — tabela e políticas de segurança das atividades.
- `img/`, `downloads/` — imagens dos guias e arquivos para download.

## Atividades de TI

Rotas:

| Rota | Quem vê | O que faz |
|---|---|---|
| `#/atividades` | todos | Lista as atividades por mês, com o tempo trabalhado em cada uma e o total. |
| `#/admin` | responsável de TI (login) | Adiciona, edita e exclui atividades; cronômetro por atividade. |

Cada atividade tem **nome**, **data**, **descrição**, **sistema relacionado** (opcional: um item do catálogo ou "Geral") e **tempo trabalhado**.

O tempo pode ser informado de três formas:

- **Digitado** em horas e minutos no formulário.
- **Cronômetro do painel** (Iniciar / Pausar / Retomar / Parar). Ao parar, o botão "Registrar atividade com Xh Ymin" leva o tempo para o formulário; basta preencher o nome e salvar. Esse cronômetro fica guardado no navegador, então sobrevive a recarregar a página, mas não aparece em outro computador.
- **Cronômetro de cada atividade** (Iniciar / Pausar na lista), para continuar contando em algo já registrado. Só um roda por vez e ele fica no banco, então continua contando em qualquer computador e aparece na página pública como "em andamento".

### Configuração inicial (uma vez)

1. Crie um projeto em [supabase.com](https://supabase.com) (plano gratuito basta).
2. No painel do projeto, abra **SQL Editor**, cole o conteúdo de `supabase/schema.sql` e execute.
3. Em **Authentication → Providers → Email**, desligue **Allow new users to sign up**. Isso impede que estranhos criem conta e escrevam no banco.
4. Em **Authentication → Users → Add user**, crie o seu usuário com e-mail e senha (marque *Auto confirm user*).
5. Em **Project Settings → API Keys**, copie a **Project URL** e a chave **publishable** (`sb_publishable_…`) para `config.js`:

   ```js
   window.SUPABASE = {
     url: 'https://xxxxxxxxxxxx.supabase.co',
     anonKey: 'sb_publishable_...',
   };
   ```

6. Faça commit e push. Abra o site em `#/admin` e entre com o usuário criado.

A chave *publishable* é pública por desenho: ela só permite o que as políticas RLS do banco autorizam (leitura para todos, escrita só para usuário autenticado). As chaves **secret** nunca devem ir para o repositório.

### Testar localmente

Abra o repositório com um servidor estático qualquer, por exemplo:

```bash
python -m http.server 8000
```

e acesse `http://localhost:8000/#/atividades`. Sem `config.js` preenchido, as telas de atividades mostram um aviso de configuração pendente.
