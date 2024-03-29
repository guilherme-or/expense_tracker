create table categorias (
  id bigint generated always as identity primary key,
  descricao text not null,
  tipo_transacao integer not null,
  icone bigint not null,
  cor bigint not null,
  ativo boolean default true
);

create table contas (
  id bigint generated always as identity primary key,
  descricao text not null,
  tipo_conta integer not null,
  banco text,
  ativo boolean default true
);

create table
  transacoes (
    id bigint generated always as identity primary key,
    user_id text not null, 
    categoria_id bigint references categorias (id),
    conta_id bigint references contas (id),
    descricao text not null,
    tipo_transacao integer not null,
    valor numeric not null,
    data_transacao date not null,
    detalhes text,
    ativo boolean default true
  );

insert into contas 
    (descricao, tipo_conta, banco)
values 
  (
    'Conta Corrente', 0, 'bb'
  ),
  (
    'Conta Investimento', 2, 'itau'
  );

  INSERT INTO categorias
    (descricao, tipo_transacao, icone, cor)
VALUES
    ('Casa', 1, 60541, 4284955319),
    ('Alimentação', 1, 60394, 4294198070),
    ('Lazer', 1, 60463, 4294940672),
    ('Educação', 1, 60070, 4282339765),
    ('Animais de estimação', 1, 60820, 4286141768),
    ('Transporte', 1, 60100, 4280391411),
    ('Salário', 0, 60166, 4283215696),
    ('Empréstimo', 0, 60136, 4278238420),
    ('Vendas', 0, 61216, 4283215696);


create table orcamentos(
  id bigint generated always as identity primary key,
  user_id text not null, 
  categoria_id bigint references categorias (id),
  descricao text not null,
  valor_limite numeric not null,
  data_criado date not null default now(),
  ativo boolean default true
);
