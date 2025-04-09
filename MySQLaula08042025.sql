-- Cria o banco de dados
CREATE DATABASE IF NOT EXISTS livraria;
USE livraria;

-- Cria tabela de Autores
CREATE TABLE autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50)
);

-- Cria tabela de Editoras
CREATE TABLE editoras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(50)
);

-- Cria tabela de Livros
CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor_id INT,
    editora_id INT,
    ano_publicacao INT,
    preco DECIMAL(10,2),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    FOREIGN KEY (editora_id) REFERENCES editoras(id)
);

-- Cria tabela de Vendas
CREATE TABLE vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    livro_id INT,
    data_venda DATE,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (livro_id) REFERENCES livros(id)
);

-- Insere Autores
INSERT INTO autores (nome, nacionalidade) VALUES
('Machado de Assis', 'Brasileira'),
('Clarice Lispector', 'Brasileira'),
('J.K. Rowling', 'Britânica'),
('George Orwell', 'Britânica'),
('Agatha Christie', 'Britânica'),
('Gabriel García Márquez', 'Colombiana'),
('Haruki Murakami', 'Japonesa'),
('Stephen King', 'Americana'),
('J.R.R. Tolkien', 'Britânica'),
('Toni Morrison', 'Americana');

-- Insere Editoras
INSERT INTO editoras (nome, pais) VALUES
('Companhia das Letras', 'Brasil'),
('Editora Rocco', 'Brasil'),
('Penguin Random House', 'EUA'),
('HarperCollins', 'Reino Unido'),
('Editora 34', 'Brasil');

-- Insere Livros (20 livros)
INSERT INTO livros (titulo, autor_id, editora_id, ano_publicacao, preco) VALUES
('Dom Casmurro', 1, 1, 1899, 45.90),
('A Hora da Estrela', 2, 1, 1977, 39.90),
('Harry Potter e a Pedra Filosofal', 3, 2, 1997, 69.90),
('1984', 4, 3, 1949, 55.00),
('Assassinato no Expresso do Oriente', 5, 4, 1934, 60.00),
('Cem Anos de Solidão', 6, 3, 1967, 65.50),
('Norwegian Wood', 7, 2, 1987, 75.00),
('O Iluminado', 8, 3, 1977, 70.00),
('O Senhor dos Anéis', 9, 4, 1954, 89.90),
('Amada', 10, 3, 1987, 58.00),
('Memórias Póstumas de Brás Cubas', 1, 1, 1881, 42.50),
('A Metamorfose', 4, 3, 1915, 35.00),
('Crime e Castigo', 4, 4, 1866, 49.90),
('1Q84', 7, 2, 2009, 85.00),
('It: A Coisa', 8, 2, 1986, 79.90),
('O Hobbit', 9, 4, 1937, 67.50),
('Sobrevivendo no Inferno', 1, 5, 1997, 30.00),
('O Conto da Aia', 10, 3, 1985, 62.00),
('O Estrangeiro', 6, 1, 1942, 40.00),
('Orgulho e Preconceito', 5, 4, 1813, 37.90);

-- Insere Vendas (20 vendas)
INSERT INTO vendas (livro_id, data_venda, quantidade, preco_unitario) VALUES
(1, '2023-01-15', 2, 45.90),
(3, '2023-02-20', 1, 69.90),
(5, '2023-03-10', 3, 60.00),
(7, '2023-04-05', 1, 75.00),
(2, '2023-05-12', 2, 39.90),
(4, '2023-06-18', 1, 55.00),
(6, '2023-07-22', 4, 65.50),
(8, '2023-08-30', 1, 70.00),
(10, '2023-09-05', 2, 58.00),
(9, '2023-10-10', 1, 89.90),
(12, '2023-11-11', 3, 35.00),
(15, '2023-12-25', 2, 79.90),
(17, '2024-01-05', 5, 30.00),
(19, '2024-02-14', 1, 40.00),
(11, '2024-03-08', 2, 42.50),
(13, '2024-04-01', 1, 49.90),
(16, '2024-05-05', 3, 67.50),
(18, '2024-06-10', 2, 62.00),
(14, '2024-07-15', 1, 85.00),
(20, '2024-08-20', 4, 37.90);

-- Cria índices para melhorar performance
CREATE INDEX idx_autor ON livros(autor_id);
CREATE INDEX idx_editora ON livros(editora_id);
CREATE INDEX idx_data_venda ON vendas(data_venda);
----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT l.titulo, a.nome AS autor, e.nome AS editora -- l.titulo: referencia o titulo(coluna) da tabela livros, assim como para a.nome e e.nome;
-- AS autor e AS editora: modifica o nome que apareceria no "titulo" da coluna, para não aparecer como "a.nome" e "e.nome";
FROM livros l -- "DE livros" tabela que pegaremos as infos;
JOIN autores a ON l.autor_id = a.id -- JUNTAR autores ONDE o id de autores(chave estrangeira) da tabela livros é igual a id da tabela autores(chave primaria);
JOIN editoras e ON l.editora_id = e.id; -- JUNTAR editoras ONDE o id de editoras(chave estrangeira) da tabela livros é igual a id da tabela editoras(chave primaria);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT l.titulo, SUM(v.quantidade * v.preco_unitario) AS total_vendas -- SUM: Calcula alguma expressão;
FROM vendas v -- "DE VENDAS" sempre será a tabela principal;
JOIN livros l ON v.livro_id = l.id -- JUNTAR livros ONDE o id de VENDAS da tabela livros é igual a id da tabela LIVROS
GROUP BY l.titulo -- group by "zipa" para que caso possua mais livros iguais não apareça varios, somente uma vez o nome e o total referente a quantidade 
ORDER BY total_vendas DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT a.nome, COUNT(l.id) AS total_livros -- COUNT: contador; 
FROM autores a
JOIN livros l ON a.id = l.autor_id
GROUP BY a.nome
HAVING total_livros > 1;
-- SELECIONE nome da tabela autores, conte os IDs da tabela livros e digite o titulo da coluna como total_livros tudo isso tendo 
-- a tabela autores referencia a como tabela mais forte/principal. JUNTE livros referencia l ONDE o id de autores é igual ao idAutor 
-- da tabela livros. agrupando pelo nome do autor, tendo um total de livros maior que 1;