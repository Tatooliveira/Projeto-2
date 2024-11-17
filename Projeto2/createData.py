from faker import Faker
import mysql.connector
import random

# Configurar o Faker
fake = Faker('pt_BR')

# Conexão com o banco de dados MySQL
def conectar_banco():
    return mysql.connector.connect(
        host="localhost",        # Substitua pelo seu host
        user="root",             # Substitua pelo seu usuário
        password="-------",    # Substitua pela sua senha
        database="projeto2"
    )

# Função para popular a tabela Usuario
def seed_usuarios(cursor, quantidade=10):
    for _ in range(quantidade):
        nome = fake.name()
        email = fake.email()
        data_cadastro = fake.date_this_year()
        cursor.execute("INSERT INTO Usuario (Nome, Email, Data_Cadastro) VALUES (%s, %s, %s)", 
                       (nome, email, data_cadastro))
    print(f"{quantidade} usuários inseridos.")

# Função para popular a tabela Editora
def seed_editoras(cursor, quantidade=5):
    for _ in range(quantidade):
        nome = fake.company()
        localizacao = fake.city()
        cursor.execute("INSERT INTO Editora (Nome, Localizacao) VALUES (%s, %s)", 
                       (nome, localizacao))
    print(f"{quantidade} editoras inseridas.")

# Função para popular a tabela Livro
def seed_livros(cursor, quantidade=20):
    # Lista de títulos de livros em português
    titulos = [
        "O Mistério da Casa Verde",
        "A Jornada Inesperada",
        "O Último Guardião",
        "Segredos do Passado",
        "A Revolução dos Sonhos",
        "O Caminho para Casa",
        "Entre Dois Mundos",
        "O Código do Destino",
        "A Princesa Perdida",
        "O Guerreiro das Sombras",
        "As Crônicas do Tempo",
        "O Fim da Eternidade",
        "A Luz na Escuridão",
        "O Herdeiro do Trono",
        "Memórias de Um Viajante",
        "O Guardião do Segredo",
        "A Sociedade dos Poetas",
        "Vidas Cruzadas",
        "O Labirinto de Cristal",
        "Sombras da Meia-Noite"
    ]

    # Obter IDs das editoras
    cursor.execute("SELECT ID_Editora FROM Editora")
    editoras = [row[0] for row in cursor.fetchall()]

    # Inserir livros com títulos em português
    for _ in range(quantidade):
        titulo = fake.random_element(titulos)  # Seleciona um título aleatório da lista
        autor = fake.name()
        ano_publicacao = random.randint(1900, 2023)
        id_editora = random.choice(editoras) if editoras else None
        cursor.execute(
            "INSERT INTO Livro (Titulo, Autor, Ano_Publicacao, ID_Editora) VALUES (%s, %s, %s, %s)", 
            (titulo, autor, ano_publicacao, id_editora)
        )
    print(f"{quantidade} livros inseridos.")

# Função para popular a tabela Categoria
def seed_categorias(cursor):
    categorias = ["Ficção", "Não-ficção", "História", "Ciência", "Romance"]
    for categoria in categorias:
        cursor.execute("INSERT INTO Categoria (Nome) VALUES (%s)", (categoria,))
    print(f"{len(categorias)} categorias inseridas.")

# Função para popular a tabela Livro_Categoria
def seed_livro_categoria(cursor, quantidade=30):
    cursor.execute("SELECT ID_Livro FROM Livro")
    livros = [row[0] for row in cursor.fetchall()]
    cursor.execute("SELECT ID_Categoria FROM Categoria")
    categorias = [row[0] for row in cursor.fetchall()]
    
    # Mantém um conjunto para evitar duplicações
    combinacoes_inseridas = set()

    for _ in range(quantidade):
        while True:
            id_livro = random.choice(livros)
            id_categoria = random.choice(categorias)
            combinacao = (id_livro, id_categoria)

            # Verifica se a combinação já foi inserida
            if combinacao not in combinacoes_inseridas:
                combinacoes_inseridas.add(combinacao)
                cursor.execute("INSERT INTO Livro_Categoria (ID_Livro, ID_Categoria) VALUES (%s, %s)", 
                               combinacao)
                break

    print(f"{len(combinacoes_inseridas)} associações Livro-Categoria inseridas.")

# Função para popular a tabela Emprestimo
def seed_emprestimos(cursor, quantidade=15):
    cursor.execute("SELECT ID_Usuario FROM Usuario")
    usuarios = [row[0] for row in cursor.fetchall()]
    cursor.execute("SELECT ID_Livro FROM Livro")
    livros = [row[0] for row in cursor.fetchall()]

    for _ in range(quantidade):
        id_usuario = random.choice(usuarios)
        id_livro = random.choice(livros)
        data_emprestimo = fake.date_this_month()

        # 30% de chance de a data de devolução ser NULL, para testarmos o sistema "pendente" das Queries
        if random.random() < 0.3:
            data_devolucao = None
        else:
            data_devolucao = fake.date_between(start_date=data_emprestimo, end_date="+30d")

        cursor.execute(
            "INSERT INTO Emprestimo (ID_Usuario, ID_Livro, Data_Emprestimo, Data_Devolucao) VALUES (%s, %s, %s, %s)",
            (id_usuario, id_livro, data_emprestimo, data_devolucao)
        )

    print(f"{quantidade} empréstimos inseridos.")

# Função principal para rodar todos os seeders
def run_seeders():
    connection = conectar_banco()
    cursor = connection.cursor()
    try:
        # Rodar cada seeder
        seed_usuarios(cursor)
        seed_editoras(cursor)
        seed_categorias(cursor)
        seed_livros(cursor)
        seed_livro_categoria(cursor)
        seed_emprestimos(cursor)

        # Confirmar alterações no banco
        connection.commit()
        print("Seeders executados com sucesso!")
    except Exception as e:
        print(f"Erro ao executar os seeders: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

# Executar o seeder
if __name__ == "__main__":
    run_seeders()