with tb_freq_valor as (

SELECT
    idCliente,
    count(DISTINCT substr(DtCriacao, 0, 11)) as qtdeFrequencia,
    sum(case when QtdePontos > 0 then QtdePontos else 0 end) as qtdePontosPos
FROM 
    transacoes
WHERE DtCriacao < '2025-09-01'
AND DtCriacao >= date('2025-09-01', '-28 day')
GROUP BY idCliente
ORDER BY qtdeFrequencia DESC
 ),

 tb_cluster as (
 SELECT
    *,
    CASE
        WHEN qtdeFrequencia <= 10 AND qtdePontosPos > 1500 THEN 'Hypers'
        WHEN qtdeFrequencia > 10 AND qtdePontosPos >= 1500 THEN 'Eficientes'
        WHEN qtdeFrequencia <= 10 AND qtdePontosPos >= 750 THEN 'Indeciso'
        WHEN qtdeFrequencia > 10 AND qtdePontosPos >= 750 THEN 'Esforçado'
        WHEN qtdeFrequencia < 5  THEN 'Lurker'
        WHEN qtdeFrequencia <= 10   THEN 'Preguiçoso'
        WHEN qtdeFrequencia > 10   THEN 'Potencial'
    END AS cluster

FROM
    tb_freq_valor
)

SELECT 
    *
FROM tb_cluster
