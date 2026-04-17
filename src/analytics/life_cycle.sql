-- curioso -> idade < 7
-- fiel -> recência < 7 e recência anterior < 15
-- turista -> 7 <= recência <= 14
-- desencantado -> 14 < recência <= 28
-- zumbi -> recência > 28
-- reconquistado -> recência < 7 e 14 <= recencia anterior <= 28
-- reborn -> recência < 7 e recencia anterior > 28

WITH tb_daily AS (
SELECT
    DISTINCT
    idCliente, 
    substr(DtCriacao, 0, 11) AS dtDia
FROM    
    transacoes
),

tb_idade as (
SELECT
    idCliente,
   -- min(dtDia) AS dtPrimTransacao,
    CAST(max(julianday('now') - julianday(dtDia)) AS int) AS QtdDiasPrimTransacao,
   -- max(dtDia) as dtUltTransacao,
    CAST(min(julianday('now') - julianday(dtDia)) as int) as QtdDiasLastTransacao
FROM    
    tb_daily 
GROUP BY idCliente
),

tb_rn AS (

SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY IdCliente ORDER BY dtDia DESC) as RnDia
FROM
    tb_daily
),


tb_penultima_ativacao AS ( 
SELECT
    *,
    CAST(julianday('now') - julianday(dtDia) AS int) as qtdDiasPenultimaTransacao
FROM
    tb_rn
WHERE rnDia = 2
)


SELECT 
    t1.*,
    t2.qtdDiasPenultimaTransacao,
    CASE 
        WHEN t1.QtdDiasPrimTransacao <= 7 THEN 'curioso'
        WHEN t1.QtdDiasLastTransacao <= 7 AND t2.qtdDiasPenultimaTransacao - t1.QtdDiasLastTransacao <= 14 THEN 'fiel'
        WHEN t1.QtdDiasLastTransacao BETWEEN 8 AND 14 THEN 'turista'
        WHEN t1.QtdDiasLastTransacao BETWEEN 15 AND 28 THEN 'desencantado'
        WHEN t1.QtdDiasLastTransacao > 28 THEN 'zumbi'
        
    END AS ciclo_vida
FROM    
    tb_idade AS t1 
LEFT JOIN tb_penultima_ativacao AS t2 ON t1.idCliente = t2.idCliente

