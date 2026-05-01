select 
    DtRef,
    ciclo_vida, 
    count(*) 
from
    life_cycle
where ciclo_vida <> 'zumbi
group by dtRef, ciclo_vida
order by dtRef, ciclo_vida;