CREATE DATABASE IF NOT EXISTS projeto2;
USE projeto2;

-- Tabela Usuario
CREATE TABLE Usuario (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Data_Cadastro DATE NOT NULL
);

CREATE TABLE Categoria (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

-- Tabela Editora
CREATE TABLE Editora (
    ID_Editora INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Localizacao VARCHAR(100)
);

-- Tabela Livro
CREATE TABLE Livro (
    ID_Livro INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(200) NOT NULL,
    Autor VARCHAR(100) NOT NULL,
    Ano_Publicacao INT NOT NULL,
    ID_Editora INT,
    FOREIGN KEY (ID_Editora) REFERENCES Editora(ID_Editora)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Tabela associativa Livro_Categoria para relação N:M entre Livro e Categoria
CREATE TABLE Livro_Categoria (
    ID_Livro INT,
    ID_Categoria INT,
    PRIMARY KEY (ID_Livro, ID_Categoria),
    FOREIGN KEY (ID_Livro) REFERENCES Livro(ID_Livro)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabela Emprestimo
CREATE TABLE Emprestimo (
    ID_Emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    ID_Livro INT NOT NULL,
    Data_Emprestimo DATE NOT NULL,
    Data_Devolucao DATE,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ID_Livro) REFERENCES Livro(ID_Livro)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
