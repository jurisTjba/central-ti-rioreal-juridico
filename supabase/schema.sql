-- Central de Sistemas — Comarca de Rio Real
-- Tabela de atividades de TI. Execute uma vez no SQL Editor do Supabase.

create table if not exists public.atividades (
  id            uuid primary key default gen_random_uuid(),
  nome          text not null check (char_length(nome) between 1 and 120),
  data          date not null default current_date,
  descricao     text,
  sistema       text,                          -- slug do catálogo (opcional)
  segundos      integer not null default 0 check (segundos >= 0), -- tempo trabalhado acumulado
  status        text not null default 'concluida' check (status in ('pendente', 'concluida')), -- pendente = só o admin vê
  timer_inicio  timestamptz,                   -- preenchido enquanto o cronômetro está rodando
  criado_em     timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

create index if not exists atividades_data_idx on public.atividades (data desc, criado_em desc);

-- mantém atualizado_em em dia
create or replace function public.marcar_atualizado_em()
returns trigger language plpgsql as $$
begin
  new.atualizado_em := now();
  return new;
end $$;

drop trigger if exists atividades_atualizado_em on public.atividades;
create trigger atividades_atualizado_em
  before update on public.atividades
  for each row execute function public.marcar_atualizado_em();

-- Segurança: qualquer pessoa lê; só usuário autenticado escreve.
-- IMPORTANTE: desative o cadastro público em Authentication → Providers → Email
-- ("Allow new users to sign up"), senão qualquer um poderia criar conta e escrever.
alter table public.atividades enable row level security;

drop policy if exists "leitura publica"     on public.atividades;
drop policy if exists "leitura admin"       on public.atividades;
drop policy if exists "inserir autenticado" on public.atividades;
drop policy if exists "editar autenticado"  on public.atividades;
drop policy if exists "excluir autenticado" on public.atividades;

create policy "leitura publica"     on public.atividades for select using (status = 'concluida');
create policy "leitura admin"       on public.atividades for select to authenticated using (true);
create policy "inserir autenticado" on public.atividades for insert to authenticated with check (true);
create policy "editar autenticado"  on public.atividades for update to authenticated using (true) with check (true);
create policy "excluir autenticado" on public.atividades for delete to authenticated using (true);
