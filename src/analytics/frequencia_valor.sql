SELECT
    idCliente,
    count(DISTINCT substr(DtCriacao, 0, 11)) as qtdeFrequencia,
    sum(case when QtdePontos > 0 then QtdePontos else 0 end) as qtdePontosPos
FROM 
    transacoes
WHERE DtCriacao < '2025-09-01'
AND DtCriacao >= date('2025-09-01', '-28 day')
GROUP BY idCliente
ORDER BY qtdeFrequencia DESC;
 