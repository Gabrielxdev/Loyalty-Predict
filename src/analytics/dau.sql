SELECT
    substr(DtCriacao, 0, 11) as DtDia,
    count(DISTINCT IdCliente) as DAU
FROM    
    transacoes
GROUP BY 1
ORDER BY 1;