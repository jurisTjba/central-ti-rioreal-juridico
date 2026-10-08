# Central de Sistemas — Comarca de Rio Real

Site estático (GitHub Pages) com o catálogo de sistemas da comarca e o registro público de **Atividades de TI**.

- `index.html` — todo o site. O catálogo de sistemas é o array `PROJETOS` no início do script.
- `config.js` — URL e chave pública do projeto Supabase (atividades).
- `supabase/schema.sql` — tabela e políticas de segurança das atividades, para instalação do zero.
- `supabase/migracoes/` — alterações incrementais para projetos já criados.
- `img/`, `downloads/` — imagens dos guias e arquivos para download.

## Atividades de TI

Rotas:

| Rota | Quem vê | O que faz |
|---|---|---|
| `#/atividades` | todos | Lista as atividades concluídas por mês, com o tempo trabalhado em cada uma e o total. |
| `#/admin` | responsável de TI (login) | Abas Pendentes e Registradas; criar, editar, concluir e excluir atividades. |
| `#/foco` e `#/foco/<id>` | responsável de TI (login) | Modo foco: cronômetro em tela limpa, livre ou vinculado a uma atividade. |

Cada atividade tem **nome**, **data**, **descrição**, **sistema relacionado** (opcional: um item do catálogo ou "Geral"), **tempo trabalhado** e **situação** (concluída ou pendente).

### Painel de administração

Duas abas:

- **Pendentes**: o que falta fazer. "Nova pendência" abre um formulário rápido, só com nome, sistema e descrição. Cada cartão tem o botão de destaque **Concluir**, que move a atividade para as registradas com a data de hoje e para o cronômetro dela, se estiver rodando.
- **Registradas**: atividades concluídas, agrupadas por mês, com destaque para o tempo gasto e badge do sistema. "Lançar atividade manual" abre o formulário completo, com data e tempo.

Todos os formulários abrem em modal. Excluir pede confirmação. "Focar" em qualquer cartão abre o modo foco já vinculado àquela atividade.

### Atividades pendentes

Pendentes aparecem só no painel do administrador. A página pública nunca as mostra: o próprio banco bloqueia a leitura para quem não está logado (a política RLS `leitura publica` filtra `status = 'concluida'`), e a página também filtra no cliente para o caso de o administrador abri-la logado.

### Tempo trabalhado

O tempo pode ser informado de três formas:

- **Digitado** em horas e minutos ao lançar ou editar uma atividade.
- **Modo foco livre** (`#/foco`): cronômetro grande em tela limpa, com Iniciar, Pausar, Retomar e Finalizar. Ao finalizar, "Registrar atividade" abre o formulário já com o tempo medido. "Descartar" só funciona segurando o botão por 2 segundos (ou confirmando uma caixa, pelo teclado), para não perder tempo por clique acidental. A tecla Espaço inicia e pausa. Esse cronômetro fica guardado no navegador, então sobrevive a recarregar a página, mas não aparece em outro computador.
- **Modo foco vinculado** (`#/foco/<id>`, botão "Focar" nos cartões): o tempo é gravado direto na atividade, no banco, e continua contando em qualquer computador. A página pública mostra a atividade como "em andamento". Só uma atividade conta por vez; iniciar outra pausa a anterior. "Finalizar" pausa e, se for uma pendência, pergunta se ela foi concluída.

### Configuração inicial (uma vez)

1. Crie um projeto em [supabase.com](https://supabase.com) (plano gratuito basta).
2. No painel do projeto, abra **SQL Editor**, cole o conteúdo de `supabase/schema.sql` e execute.
3. Em **Authentication → Sign In / Providers**, desligue **Allow new users to sign up**. Isso impede que estranhos criem conta e escrevam no banco.
4. Em **Authentication → Users → Add user**, crie o seu usuário com e-mail e senha (marque *Auto Confirm User*).
5. Em **Project Settings → API Keys**, copie a **Project URL** e a chave **publishable** (`sb_publishable_…`) para `config.js`:

   ```js
   window.SUPABASE = {
     url: 'https://xxxxxxxxxxxx.supabase.co',
     anonKey: 'sb_publishable_...',
   };
   ```

6. Faça commit e push. Abra o site em `#/admin` e entre com o usuário criado.

A chave *publishable* é pública por desenho: ela só permite o que as políticas RLS do banco autorizam (leitura para todos, escrita só para usuário autenticado). As chaves **secret** nunca devem ir para o repositório.

Projetos criados antes das atividades pendentes precisam rodar `supabase/migracoes/2026-10-08-atividades-pendentes.sql` no SQL Editor.

### Testar localmente

Abra o repositório com um servidor estático qualquer, por exemplo:

```bash
python -m http.server 8000
```

e acesse `http://localhost:8000/#/atividades`. Sem `config.js` preenchido, as telas de atividades mostram um aviso de configuração pendente.
