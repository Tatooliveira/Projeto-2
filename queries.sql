-- 1. Listar todos os livros de uma categoria específica
SELECT Livro.Titulo, Categoria.Nome AS Categoria
FROM Livro
JOIN Livro_Categoria ON Livro.ID_Livro = Livro_Categoria.ID_Livro
JOIN Categoria ON Categoria.ID_Categoria = Livro_Categoria.ID_Categoria
WHERE Categoria.Nome = 'Ficção';

-- 2. Contar quantos livros existem em cada categoria
SELECT Categoria.Nome AS Categoria, COUNT(Livro_Categoria.ID_Livro) AS Quantidade_Livros
FROM Categoria
LEFT JOIN Livro_Categoria ON Categoria.ID_Categoria = Livro_Categoria.ID_Categoria
GROUP BY Categoria.Nome
ORDER BY Quantidade_Livros DESC;

-- 3. Listar os 5 usuários que fizeram mais empréstimos
SELECT Usuario.Nome AS Usuario, COUNT(Emprestimo.ID_Emprestimo) AS Total_Emprestimos
FROM Usuario
JOIN Emprestimo ON Usuario.ID_Usuario = Emprestimo.ID_Usuario
GROUP BY Usuario.ID_Usuario
ORDER BY Total_Emprestimos DESC
LIMIT 5;

-- 4. Verificar os empréstimos pendentes (sem data de devolução)
SELECT Emprestimo.ID_Emprestimo, Usuario.Nome AS Usuario, Livro.Titulo AS Livro, Emprestimo.Data_Emprestimo
FROM Emprestimo
JOIN Usuario ON Emprestimo.ID_Usuario = Usuario.ID_Usuario
JOIN Livro ON Emprestimo.ID_Livro = Livro.ID_Livro
WHERE Emprestimo.Data_Devolucao IS NULL;

-- 5. Listar os livros mais emprestados
SELECT Livro.Titulo AS Livro, COUNT(Emprestimo.ID_Emprestimo) AS Total_Emprestimos
FROM Livro
JOIN Emprestimo ON Livro.ID_Livro = Emprestimo.ID_Livro
GROUP BY Livro.ID_Livro
ORDER BY Total_Emprestimos DESC;

-- 6. Listar todas as editoras e quantos livros elas publicaram
SELECT Editora.Nome AS Editora, COUNT(Livro.ID_Livro) AS Total_Livros
FROM Editora
LEFT JOIN Livro ON Editora.ID_Editora = Livro.ID_Editora
GROUP BY Editora.ID_Editora
ORDER BY Total_Livros DESC;

-- 7. Encontrar livros publicados entre dois anos específicos
SELECT Titulo, Autor, Ano_Publicacao
FROM Livro
WHERE Ano_Publicacao BETWEEN 2000 AND 2010;

-- 8. Verificar quais livros estão em mais de uma categoria
SELECT Livro.Titulo, COUNT(Livro_Categoria.ID_Categoria) AS Total_Categorias
FROM Livro
JOIN Livro_Categoria ON Livro.ID_Livro = Livro_Categoria.ID_Livro
GROUP BY Livro.ID_Livro
HAVING Total_Categorias > 1
ORDER BY Total_Categorias DESC;

-- 9. Listar todos os usuários que pegaram livros de uma categoria específica
SELECT DISTINCT Usuario.Nome AS Usuario
FROM Usuario
JOIN Emprestimo ON Usuario.ID_Usuario = Emprestimo.ID_Usuario
JOIN Livro_Categoria ON Emprestimo.ID_Livro = Livro_Categoria.ID_Livro
JOIN Categoria ON Livro_Categoria.ID_Categoria = Categoria.ID_Categoria
WHERE Categoria.Nome = 'Romance';

-- 10. Obter um relatório detalhado de todos os empréstimos
SELECT 
    Emprestimo.ID_Emprestimo,
    Usuario.Nome AS Usuario,
    Livro.Titulo AS Livro,
    Emprestimo.Data_Emprestimo,
    Emprestimo.Data_Devolucao,
    CASE 
        WHEN Emprestimo.Data_Devolucao IS NULL THEN 'Pendente'
        ELSE 'Devolvido'
    END AS Status
FROM Emprestimo
JOIN Usuario ON Emprestimo.ID_Usuario = Usuario.ID_Usuario
JOIN Livro ON Emprestimo.ID_Livro = Livro.ID_Livro
ORDER BY Emprestimo.Data_Emprestimo DESC;

-- 11. Listar todas as categorias e suas descrições
SELECT Nome, Descricao
FROM Categoria;
