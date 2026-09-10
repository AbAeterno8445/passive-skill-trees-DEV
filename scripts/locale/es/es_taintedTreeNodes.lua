return {
    ---- TAINTED CHARACTER TREE NODE MODIFIERS ----
    ["node_coalescingsoul_name"] = "Alma En Coalescencia",
    ["node_coalescingsoul"] = {
        "Al entrar a un piso, 3% chance de crear una piedra de alma correspondiente a tu personaje.",
        "Este efecto solo puede activarse una vez por partida.",
        "No puede activarse en el primer piso."
    },
    ["node_warpedcoalescence_name"] = "Coalescencia Deformada",
    ["node_warpedcoalescence"] = {
        "Alma En Coalescencia ahora puede activarse hasta {{coalescingSoulProcs}} veces más por partida, y gana +{{coalescingSoulChance}}%",
        "chance base de activación.",
        "40% chance de que Alma En Coalescencia tire una piedra de alma perteneciente a un personaje aleatorio en vez del actual."
    },
    ["node_coalescingsoulchance_name"] = "Chance Para Alma En Coalescencia",
    ["node_coalescingsoulchance"] = {
        "+{{coalSoulRoomClearChance}}% chance de activación para Alma En Coalescencia al completar una habitación sin recibir daño.",
        "{{coalSoulHitChance}}% chance de activación para Alma En Coalescencia al recibir daño."
    },
    ["node_soulstoneallstat_name"] = "Estadísticas Por Piedras De Alma",
    ["node_soulstoneallstat"] = {
        "+{{soulStoneAllstats}}% a todas las estadísticas al usar una piedra de alma perteneciente al personaje actual,",
        "una vez por partida.",
        "{{soulStoneUnusedAllstats}}% a todas las estadísticas mientras no hayas usado una piedra de alma perteneciente al",
        "personaje actual."
    },

    -- T. ISAAC'S TREE --
    ["node_vacuophobia_name"] = "Vacuofobia",
    ["node_vacuophobia"] = {
        "Comienza con Primogenitura.",
        "-1% a todas las estadísticas por cada objeto faltante en tu inventario.",
        "-4% a todas las estadísticas mientras no tengas un trinket.",
        "-4% a todas las estadísticas mientras no tengas un objeto activo.",
        "-4% a todas las estadísticas mientras no tengas ningún objeto de bolsillo."
    },
    ["node_consumingvoid_name"] = "Vacío Consumidor",
    ["node_consumingvoid"] = {
        "Al entrar a un piso, si tu inventario está lleno, crea Vacío.",
        "Vacío ahora es consumido al usarse.",
        "+20% a todas las estadísticas al consumir un objeto con Vacío.",
        "Reduce este bonus por la mitad al completar una habitación."
    },
    ["node_fracturedremains_name"] = "Restos Fragmentados",
    ["node_fracturedremains"] = {
        "Comienza con un Fragmento de Dado.",
        "3% chance al completar una habitación regular sin recibir daño de crear un Fragmento de Dado.",
        "7% chance al completar una habitación regular sin recibir daño de crear un Fragmento de Runa.",
        "75% chance al completar una habitación del jefe sin recibir daño de crear un Fragmento de Dado.",
        "Completar una habitación del jefe sin recibir daño crea 2 Fragmentos de Runa."
    },
    ["node_sinistralrunemaster_name"] = "Maestro De Runas Siniestras",
    ["node_sinistralrunemaster"] = {
        "+{{blackRuneAbsorb}}% chance de absorber los efectos de objetos consumidos con Runas Negras permanentemente.",
        "Mejora los efectos de ciertas runas:",
        "- Hagalaz: adicionalmente activa el efecto de Llave de Papá.",
        "- Jera: los recolectables duplicados tienen un 8% chance de volverse una versión especial.",
        "- Ehwaz: +3% a todas las estadísticas para el siguiente piso si entras a una trampa de piso en la habitación actual.",
        "- Dagaz: +3% a todas las estadísticas para el piso actual por cada maldición removida.",
        "Estos efectos solo tienen un 75% chance de activarse si tienes Maestro De Runas Diestras asignado."
    },
    ["node_dextralrunemaster_name"] = "Maestro De Runas Diestras",
    ["node_dextralrunemaster"] = {
        "+{{blackRuneAbsorb}}% chance de absorber los efectos de objetos consumidos con Runas Negras permanentemente.",
        "Mejora los efectos de ciertas runas:",
        "- Ansuz: al usarse, +15% chance de revelar el mapa en el siguiente piso.",
        "- Perthro: un pedestal de objeto aleatorio recibe una elección de objeto adicional perteneciente a la habitación del tesoro.",
        "- Berkano: gana el efecto de Mente de Colmena por el piso actual. Si ya la tienes, crea el doble de moscas y arañas azules.",
        "- Algiz: +7% daño y lágrimas por 20 segundos.",
        "- Runa Limpia: adicionalmente activa el efecto de un Fragmento de Runa.",
        "Estos efectos solo tienen un 75% chance de activarse si tienes Maestro De Runas Siniestras asignado."
    },

    ["node_obtitem_dmg_name"] = "Daño Por Objetos Conseguidos",
    ["node_obtitem_dmg"] = "+{{obtainedItemDamage}}% daño por objeto conseguido.",
    ["node_obtitem_tears_name"] = "Lágrimas Por Objetos Conseguidos",
    ["node_obtitem_tears"] = "+{{obtainedItemTears}}% lágrimas por objeto conseguido.",
    ["node_obtitem_range_name"] = "Rango Por Objetos Conseguidos",
    ["node_obtitem_range"] = "+{{obtainedItemRange}}% rango por objeto conseguido.",
    ["node_flawlessbossluck_name"] = "Suerte Por Matanza Limpia De Jefe",
    ["node_flawlessbossluck"] = "+{{flawlessBossLuck}} suerte al completar una habitación del jefe sin recibir daño.",
    ["node_voidconsumeluck_name"] = "Suerte Por Consumo Del Vacío",
    ["node_voidconsumeluck"] = "+{{voidConsumeLuck}} suerte al consumir un objeto con Vacío.",
    ["node_runeshardspawn_name"] = "Creación De Fragmentos De Runas",
    ["node_runeshardspawn"] = "{{diceShardRuneShard}}% chance de crear un Fragmento de Runa al usar un Fragmento de Dado.",
    ["node_runicspeed_name"] = "Velocidad Rúnica",
    ["node_runicspeed"] = {
        "+{{runicSpeed}}% velocidad al usar una Runa o Fragmento de Runa, hasta 22%.",
        "Este efecto se reinicia en cada piso."
    },
    ["node_runeshardstacking_name"] = "Apilación De Fragmentos De Runas",
    ["node_runeshardstacking"] = {
        "Los Fragmentos de Runa ahora pueden apilarse. Si la pila llega a {{runeshardStacksReq}} fragmentos, estos se pierden y una Runa aleatoria es creada.",
        "Las pila puede acumular más fragmentos mientras tengas cualquier Runa o Fragmento de Runa."
    },
    ["node_runeshardassemblystacks_name"] = "Asemblaje De Runas",
    ["node_runeshardassemblystacks"] = "{{runeshardStacksReq}} fragmentos de runa necesarios en la pila para crear una Runa.",
    ["node_blackruneassembly_name"] = "Asemblaje De Runas Negras",
    ["node_blackruneassembly"] = "{{blackRuneAssembly}}% chance de que la Runa aleatoria creada por pilas de fragmentos sea una Runa Negra.",


    -- T. MAGDALENE'S TREE --
    ["node_taintedhealth_name"] = "Salud Corrupta",
    ["node_taintedhealth"] = {
        "+0.1 daño por cada 1/2 corazón rojo restante por encima de 2.",
        "+3% lágrimas por cada 1/2 corazón de alma restante.",
        "-15% velocidad mientras tengas 3 o menos corazones totales restantes."
    },
    ["node_testoftemperance_name"] = "Prueba de Templanza",
    ["node_testoftemperance"] = {
        "5% chance de crear 1/2 corazón rojo al golpear a un jefe, el cual desaparece luego de 2 segundos.",
        "Este efecto tiene un enfriamiento de 0.5 segundos una vez activado.",
        "Si tienes más de 2 corazones rojos restantes, recibes 1/2 corazón de daño adicional al recibir daño",
        "en habitaciones de jefe."
    },
    ["node_bloodful_name"] = "Virtud Sangrienta",
    ["node_bloodful"] = {
        "Comienza con Juramento de Sangre.",
        "+1% a todas las estadísticas por corazón rojo recolectado en la habitación actual, hasta +10%.",
        "-5% a todas las estadísticas mientras no hayas recolectado ningún corazón rojo en la habitación actual."
    },
    ["node_lingeringmalice_name"] = "Malicia Persistente",
    ["node_lingeringmalice"] = {
        "Comienza con Corcho Perdido absorbido.",
        "Los charcos creados por tu personaje ahora pueden dañar a enemigos voladores.",
        "+{{creepDamage}}% daño infligido por charcos."
    },

    ["node_remaininghpspeed_name"] = "Velocidad Por Corazones Restantes",
    ["node_remaininghpspeed"] = "+{{remainingHeartsSpeed}} velocidad por 1/2 corazón rojo restante por encima de 2.",
    ["node_remaininghpdmg_name"] = "Daño Por Corazones Restantes",
    ["node_remaininghpdmg"] = "+{{remainingHeartsDmg}} daño por 1/2 corazón rojo restante por encima de 2.",
    ["node_remaininghptears_name"] = "Lágrimas Por Corazones Restantes",
    ["node_remaininghptears"] = "+{{remainingHeartsTears}} lágrimas por 1/2 corazón rojo restante por encima de 2.",
    ["node_tempheart_time_name"] = "Duración De Corazones Temporales",
    ["node_tempheart_time"] = "+{{temporaryHeartTime}} segundos de duración a corazones rojos temporales.",
    ["node_tempheartdmg_name"] = "Daño Por Corazones Temporales",
    ["node_tempheartdmg"] = {
        "+{{temporaryHeartDmg}}% daño por 2 segundos luego de recolectar un corazón rojo temporal.",
        "Los modificadores que aumentan la duración de los corazones temporales también afectan la duración de este efecto."
    },
    ["node_tempheart_tears_name"] = "Lágrimas Por Corazones Temporales",
    ["node_tempheart_tears"] = {
        "+{{temporaryHeartTears}}% lágrimas por 2 segundos luego de recolectar un corazón rojo temporal.",
        "Los modificadores que aumentan la duración de los corazones temporales también afectan la duración de este efecto."
    },
    ["node_creepdmg_name"] = "Daño De Charcos",
    ["node_creepdmg"] = "+{{creepDamage}}% daño infligido por charcos.",
    ["node_halfheartconv_name"] = "Conversión De Corazones Recolectables",
    ["node_halfheartconv"] = "{{halfHeartPickupToFull}}% chance de convertir los 1/2 corazones rojos encontrados a corazones enteros.",
    ["node_tempheartluck_name"] = "Suerte Por Corazones Temporales",
    ["node_tempheartluck"] = {
        "{{temporaryHeartLuck}}% chance de ganar 0.01 suerte al recolectar un corazón rojo temporal mientras éste tenga",
        "1.8 segundos restantes o más.",
        "El bonus total de este efecto se reduce a la mitad al entrar a un nuevo piso."
    },
    ["node_blooddono_temphearts_name"] = "Corazones Temporales Por Donación De Sangre",
    ["node_blooddono_temphearts"] = {
        "{{bloodDonoTempHearts}}% chance de crear 1/2 corazón rojo al usar una Máquina de Donación de Sangre, el cual",
        "desaparece luego de 2 segundos."
    },
    ["node_heartdraincd_name"] = "Drenaje de Corazones",
    ["node_heartdraincd"] = {
        "+{{heartDrainCD}} segundos antes de que los corazones rojos excesivos sean drenados."
    },


    -- T. CAIN'S TREE --
    ["node_ransacking_name"] = "Saqueo",
    ["node_ransacking"] = {
        "El ataque melé de la Bolsa de Crafteo adicionalmente gana un {{craftBagMeleeDmgInherit}}% de tu daño.",
        "Matar a un enemigo con el ataque melé de la Bolsa de Crafteo tiene un 10% chance de crear una",
        "moneda/llave/bomba/medio corazón, hasta 5 veces por habitación.",
        "+0.02 suerte al matar a un enemigo con el ataque melé de la Bolsa de Crafteo."
    },
    ["node_magicbag_name"] = "Bolsa Mágica",
    ["node_magicbag"] = {
        "Al craftear un objeto, adicionalmente tira uno de los componentes usados para craftearlo.",
        "+0.5% a todas las estadísticas por cada recolectable actualmente en la Bolsa de Crafteo."
    },
    ["node_opportunist_name"] = "Oportunista",
    ["node_opportunist"] = {
        "Al conseguir un recolectable con la Bolsa de Crafteo, activa un efecto basado en su tipo:",
        "  - Corazones rojos: 30% chance de curar 1/2 corazón rojo.",
        "  - Corazones de alma/negros: 15% chance de ganar 1/2 del corazón agarrado.",
        "  - Monedas/llaves/bombas: 15% chance de otorgar el recolectable agarrado normalmente.",
        "  - Baterías: 15% chance de añadir 2 cargas a tus objetos activos.",
        "  - Runas: activa el efecto de Fragmento de Runa.",
        "  - Cartas: +0.5% suerte permanente."
    },
    ["node_grandingredient_coins_name"] = "Ingrediente Grandioso: Monedas",
    ["node_grandingredient_coins"] = {
        "Si el primer recolectable en la bolsa es una moneda, gana un efecto basado en su tipo:",
        "  - Centavo: +3% suerte y rango.",
        "  - Centavo de la suerte: +7% suerte.",
        "  - Níquel: gana 5 monedas al craftear un objeto.",
        "  - Dime: gana 10 monedas al craftear un objeto.",
        "  - Dorada: +7% a todas las estadísticas.",
        "Tener más de 2 nodos de Ingrediente Grandioso asignados nulifica estos efectos."
    },
    ["node_grandingredient_keys_name"] = "Ingrediente Grandioso: Llaves",
    ["node_grandingredient_keys"] = {
        "Si el primer recolectable en la bolsa es una llave, gana un efecto basado en su tipo:",
        "  - Normal: +3% lágrimas.",
        "  - Dorada: otorga 4 llaves y activa el efecto de Llave de Papá al craftear un objeto.",
        "  - Cargada: otorga una carga adicional a tus objetos activos al completar una habitación.",
        "Tener más de 2 nodos de Ingrediente Grandioso asignados nulifica estos efectos."
    },
    ["node_grandingredient_bombs_name"] = "Ingrediente Grandioso: Bombas",
    ["node_grandingredient_bombs"] = {
        "Si el primer recolectable en la bolsa es una bomba, gana un efecto basado en su tipo:",
        "  - Normal: +5% daño.",
        "  - Dorada: +10% daño permanente al craftear un objeto.",
        "  - Giga: +30% daño.",
        "Tener más de 2 nodos de Ingrediente Grandioso asignados nulifica estos efectos."
    },
    ["node_grandingredient_hearts_name"] = "Ingrediente Grandioso: Corazones",
    ["node_grandingredient_hearts"] = {
        "Si el primer recolectable en la bolsa es un corazón, gana un efecto basado en su tipo:",
        "  - Rojo: cura 1 corazón rojo al craftear un objeto.",
        "  - Alma: gana un corazón de alma al craftear un objeto.",
        "  - Negro: gana un corazón negro al craftear un objeto.",
        "  - Eterno: cura toda la vida al craftear un objeto.",
        "  - Dorado: gana 7 monedas al craftear un objeto.",
        "  - Hueso: gana un corazón de hueso vacío al craftear un objeto.",
        "  - Podrido: crea 2-4 arañas azules y 2-4 moscas azules al craftear un objeto.",
        "Tener más de 2 nodos de Ingrediente Grandioso asignados nulifica estos efectos."
    },

    ["node_craftbagmeleedmg_name"] = "Daño Melé Con Bolsa De Crafteo",
    ["node_craftbagmeleedmg"] = "El ataque melé de la Bolsa de Crafteo adicionalmente gana un {{craftBagMeleeDmgInherit}}% de tu daño.",
    ["node_craftpickuprecovery_name"] = "Recuperación De Recolectables De Crafteo",
    ["node_craftpickuprecovery"] = "{{craftPickupRecovery}}% chance de re-crear uno de los recolectables consumidos al craftear un objeto.",
    ["node_droppedspecialpickups_name"] = "Recolectables Especiales",
    ["node_droppedspecialpickups"] = {
        "{{droppedSpecialPickups}}% chance de que los recolectables encontrados sean una variante especial, como llaves de oro/cargadas,",
        "bombas de oro, etc."
    },
    ["node_itemcraftluck_name"] = "Suerte Por Crafteo",
    ["node_itemcraftluck"] = "+{{itemCraftingLuck}} suerte al craftear un objeto.",
    ["node_bagbombpickupbuff_name"] = "Bendición De Bombas En Bolsa",
    ["node_bagbombpickupbuff"] = "+{{bagBombDamage}}% daño por bomba presente en la bolsa de crafteo.",
    ["node_bagkeypickupbuff_name"] = "Bendición De Llaves En Bolsa",
    ["node_bagkeypickupbuff"] = "+{{bagKeyTears}}% lágrimas por llave presente en la bolsa de crafteo.",
    ["node_bagcoinpickupbuff_name"] = "Bendición De Monedas En Bolsa",
    ["node_bagcoinpickupbuff"] = "+{{bagCoinRangeLuck}}% rango y suerte por moneda presente en la bolsa de crafteo.",
    ["node_bagheartpickupbuff_name"] = "Bendición De Corazones En Bolsa",
    ["node_bagheartpickupbuff"] = "+{{bagHeartSpeed}}% velocidad por corazón presente en la bolsa de crafteo.",
    ["node_addpedestalpickup_name"] = "Recolectables De Pedestal Adicionales",
    ["node_addpedestalpickup"] = {
        "{{additionalPedestalPickup}}% chance de crear una moneda/llave/bomba/medio corazón adicional al agarrar un pedestal de obeto.",
        "Por encima de 100% chance, el efecto puede repetirse."
    },
    ["node_randclearpickup_name"] = "Recolectable Al Completar",
    ["node_randclearpickup"] = "{{randPickupOnClear}}% chance de crear una moneda/llave/bomba/medio corazón adicional al completar una habitación.",


    -- T. JUDAS' TREE --
    ["node_agile_expertise_name"] = "Habilidad Ágil",
    ["node_agile_expertise"] = {
        "Activa el efecto de Cómo Saltar al usar Artes Oscuras.",
        "-2 segundos al enfriamiento de Artes Oscuras.",
        "Reduce el enfriamiento de Artes Oscuras en 1 segundo al golpear a un jefe con este."
    },
    ["node_stealthtactics_name"] = "Tácticas Sigilosas",
    ["node_stealthtactics"] = {
        "Comienza con 9 Voltios.",
        "Tu velocidad no puede exceder 1.2 mientras Artes Oscuras esté activo.",
        "{{nonDarkArtsDmg}}% daño infligido por fuentes que no sean Artes Oscuras."
    },
    ["node_lightlessbounty_name"] = "Recompensa De Los Deslumbrados",
    ["node_lightlessbounty"] = {
        "Matar a un enemigo con Artes Oscuras tiene un 15% chance de otorgar 1/2 corazón negro si tienes menos de 4 corazones negros.",
        "Matar a un enemigo con Artes Oscuras otorga +0.03 suerte, hasta +1 por piso."
    },
    ["node_annihilation_name"] = "Aniquilación",
    ["node_annihilation"] = {
        "La primera vez que dañes a un jefe con Artes Oscuras, inflige 40 de daño o 10% de su vida en daño, cual sea mayor.",
        "Este efecto solo puede activarse dos veces por habitación si hay múltiples jefes presentes.",
        "25% chance de recibir 1/2 corazón de daño adicional proveniente de jefes si tienes 3 o más corazones negros."
    },
    ["node_anarchy_name"] = "Anarquía",
    ["node_anarchy"] = {
        "Los enemigos dañados por Artes Oscuras tienen un 25% chance de crear una bomba trol, hasta 3 veces por habitación.",
        "Las bombas trol infligen 75% menos daño a los enemigos.",
        "Los enemigs matados por bombas reducen el enfriamiento de Artes Oscuras en 0.5 segundos."
    },
    ["node_darkexpertise_name"] = "Habilidad Oscura",
    ["node_darkexpertise"] = {
        "Reduce el enfriamiento de Artes Oscuras en 0.5 segundos por cada enemigo no-jefe dañado con éste.",
        "Reduce el enfriamiento de Artes Oscuras en 1 segundo por jefe dañado con éste.",
        "+{{darkArtsCD}} segundos al enfriamiento base de Artes Oscuras."
    },

    ["node_jumppulse_name"] = "Pulso Con Cómo Saltar",
    ["node_jumppulse"] = "{{howToJumpPulse}}% chance de activar un pulso al caer con Cómo Saltar, infligiendo 150% de tu daño a los enemigos cercanos.",
    ["node_darkartscd_name"] = "Enfriamiento De Artes Oscuras",
    ["node_darkartscd"] = "{{darkArtsCD}} segundos al enfriamiento de Artes Oscuras.",
    ["node_darkartscdreset_name"] = "Reinicio De Enfriamiento De Artes Oscuras",
    ["node_darkartscdreset"] = "{{darkArtsCDReset}}% chance de reiniciar el enfriamiento de Artes Oscuras al recibir daño.",
    ["node_darkartsdmg_name"] = "Daño Con Artes Oscuras",
    ["node_darkartsdmg"] = {
        "+{{darkArtsDmg}}% daño con Artes Oscuras.",
        "+{{darkArtsCD}} segundos al enfriamiento de Artes Oscuras."
    },
    ["node_darkarts_tearboost_name"] = "Bendición De Lágrimas Con Artes Oscuras",
    ["node_darkarts_tearboost"] = {
        "+{{darkArtsTears}}% lágrimas por 2.5 segundos luego de usar Artes Oscuras.",
        "+{{darkArtsCD}} segundos al enfriamiento de Artes Oscuras."
    },
    ["node_nondarkartsdmg_name"] = "Daño Diferente: Artes Oscuras",
    ["node_nondarkartsdmg"] = "+{{nonDarkArtsDmg}}% daño proveniente de fuentes que no sean Artes Oscuras.",
    ["node_darkarts_killboost_name"] = "Bendición De Matanza Con Artes Oscuras",
    ["node_darkarts_killboost"] = {
        "Cada 10 enemigos matados con Artes Oscuras, recibe +{{darkArtsKillStat}}% a una estadística aleatoria.",
        "Este bonus se reinicia en cada piso."
    },
    ["node_trollbombprotect_name"] = "Protección Contra Bombas Trol",
    ["node_trollbombprotect"] = "{{trollBombProtection}}% chance de que las bombas trol no te causen daño.",
    ["node_trollbombkill_luck_name"] = "Suerte Al Matar Con Bombas Trol",
    ["node_trollbombkill_luck"] = "+{{trollBombKillLuck}} suerte cada vez que una bomba trol mata a un enemigo.",


    -- T. BLUE BABY'S TREE --
    ["node_alacritouspurpose_name"] = "Alacridad Decidida",
    ["node_alacritouspurpose"] = {
        "+0.04 lágrimas al destruir popo, hasta +0.5, reiniciandose en cada piso.",
        "+0.04 suerte al destruir popo, hasta +2, reiniciandose en cada piso.",
        "El primer popo que destruyas en cada habitación crea 3 moscas azules, si tienes menos de 15 moscas activas."
    },
    ["node_treasuredwaste_name"] = "Residuos Preciados",
    ["node_treasuredwaste"] = {
        "El popo que tengas mantenido en el frasco actualmente otorga un efecto basado en su tipo:",
        "  - Normal: +0.02 a todas las estadísticas.",
        "  - Maíz: +2% a todas las estadísticas.",
        "  - En llamas: 5% chance de aplicar quemadura al dañar enemigos.",
        "  - Verde: 5% chance de aplicar veneno al dañar enemigos.",
        "  - Negro: 5% chance de aplicar confusión al dañar enemigos.",
        "  - Blanco: +8% daño y lágrimas.",
        "  - Gris: 8% chance de nulificar daño recibido.",
        "  - Gases: 40% chance de activar el efecto de Frijol Mantequilla al recibir daño.",
        "  - Líquido: +6% velocidad."
    },
    ["node_asceticsoul_name"] = "Alma Ascética",
    ["node_asceticsoul"] = {
        "Mientras tengas 8 o más bombas de popo, 7% chance al matar a un enemigo de crear 1/2 corazón de alma,",
        "hasta 5 veces por piso."
    },
    ["node_slothlegacy_name"] = "Legado de Pereza",
    ["node_slothlegacy"] = {
        "Comienza con Cabeza Podrida de Bob.",
        "Dañar a un jefe con la Cabeza Podrida de Bob crea 3 chargers aliados, una vez por piso.",
        "La Cabeza Podrida de Bob inflige 60% menos daño."
    },

    ["node_holdpoopregain_name"] = "Recuperación De Popo",
    ["node_holdpoopregain"] = "{{holdPoopRegain}}% chance de recuperar el popo usado con el frasco.",
    ["node_holdbuffs_name"] = "Bendición Del Frasco",
    ["node_holdbuffs"] = {
        "+{{holdEmptySpeed}}% velocidad mientras el frasco esté vacío.",
        "+{{holdFullLuck}}% suerte mientras el frasco no esté vacío."
    },
    ["node_poopdmgbuff_name"] = "Daño Por Popo",
    ["node_poopdmgbuff"] = "Gana +{{poopDamageBuff}}% daño por 2 segundos al destruir popo en habitaciones.",
    ["node_pooptransmutation_name"] = "Transmutación De Popo",
    ["node_pooptransmutation"] = {
        "0.5% chance de transmutar un popo aleatorio en tu barra a una versión diferente al conseguir popo",
        "recolectable, usando el siguiente orden:",
        "Normal -> Gases -> Bomba -> Maíz -> Gris -> En llamas -> Verde -> Diarrea Explosiva -> Líquido ->",
        "Negro -> Blanco"
    },
    ["node_smallpoopupg_name"] = "Mejora De Popo Recolectable",
    ["node_smallpoopupg"] = "{{poopPickupEnlarge}}% chance de convertir popo pequeño recolectable a popo grande.",
    ["node_rainbowpoopbless_name"] = "Bendición Del Popo Arcoíris",
    ["node_rainbowpoopbless"] = {
        "+{{rainbowPoopLuck}}% suerte al destruir popo arcoíris, hasta +35%.",
        "El bonus de suerte se reduce a la mitad al entrar a un nuevo piso.",
        "{{rainbowPoopSoul}}% chance de conseguir un corazón de alma al destruir popo arcoíris."
    },
    ["node_bobheadfly_name"] = "Moscas Con Cabeza De Bob",
    ["node_bobheadfly"] = {
        "{{bobHeadFlySpawn}}% chance de crear una mosca azul por cada enemigo dañado con la Cabeza Podrida de Bob,",
        "hasta 8 por habitación."
    },
    ["node_brownnuggethold_name"] = "Nugget Café Por Frasco",
    ["node_brownnuggethold"] = "{{holdBrownNugget}}% chance de activar el efecto de Nugget Café al usar el frasco, hasta 5 veces por habitación.",
    ["node_specialpoopfind_name"] = "Hallazgo De Popos Especiales",
    ["node_specialpoopfind"] = {
        "{{specialPoopFind}}% chance de que los popos encontrados en las habitaciones sean reemplazados por variantes",
        "especiales, hasta 4 por habitación."
    },


    -- T. EVE'S TREE --
    ["node_bloodwrath_name"] = "Ira Sanguinaria",
    ["node_bloodwrath"] = {
        "Comienza con un contenedor de corazón rojo adicional.",
        "-1.5% daño por cada 1/2 corazón rojo restante.",
        "Al perder corazones rojos por cualquier motivo, esta reducción se vuelve positiva por 5 segundos."
    },
    ["node_resilientblood_name"] = "Sangre Resistente",
    ["node_resilientblood"] = {
        "Los coágulos tienen un 25% chance de nulificar daño recibido.",
        "Los coágulos reciben 50% menos daño."
    },
    ["node_blessedblood_name"] = "Sangre Bendecida",
    ["node_blessedblood"] = "Al entrar a un piso, si no tienes un coágulo eterno, crea uno.",
    ["node_congealedbuddy_name"] = "Amigo Coagulado",
    ["node_congealedbuddy"] = {
        "Comienza con Lil Clot absorbido.",
        "Lil Clot inflige 20% más daño.",
        "Tu infliges 30% menos daño."
    },
    ["node_mysticvampirism_name"] = "Vampirismo Místico",
    ["node_mysticvampirism"] = {
        "Comienza con Encanto del Vampiro.",
        "Cada 13 matanzas, 20% chance de transformar un coágulo rojo activo a un tipo diferente aleatorio,",
        "hasta 8 veces por piso."
    },

    ["node_clotheartdrop_name"] = "Corazones De Coágulos",
    ["node_clotheartdrop"] = {
        "Los coágulos tienen un {{clotHeartDrop}}% chance de tirar su tipo de corazón correspondiente ser destruidos.",
        "Los corazones creados por este efecto desaparecen luego de 3 segundos."
    },
    ["node_clotpulsedmg_name"] = "Daño Del Pulso De Coágulos",
    ["node_clotpulsedmg"] = "El pulso de coágulos adicionalmente inflige un {{clotPulseDmgInherit}}% de tu daño.",
    ["node_clothitpulse_name"] = "Pulso De Coágulos",
    ["node_clothitpulse"] = "Los coágulos liberan un pulso dañino al ser golpeados, infligiendo 3 de daño a enemigos cercanos.",
    ["node_lilclotdmg_name"] = "Daño De Lil Clot",
    ["node_lilclotdmg"] = "+{{lilClotDmg}}% daño infligido por Lil Clot.",
    ["node_redclotdmgabsorb_name"] = "Daño Por Absorción De Coágulos",
    ["node_redclotdmgabsorb"] = {
        "+{{redClotAbsorbDmg}}% daño por la habitación actual por cada coágulo rojo absorbido.",
        "Crear un coágulo rojo reduce el bonus actual por la misma cantidad."
    },
    ["node_soulclotabsorbtears_name"] = "Lágrimas Por Absorción De Coágulos",
    ["node_soulclotabsorbtears"] = {
        "+{{soulClotAbsorbTears}}% lágrimas por la habitación actual por cada coágulo de alma absorbido.",
        "Crear un coágulo de alma reduce el bonus actual por la misma cantidad."
    },
    ["node_clotdmg_name"] = "Daño De Coágulos",
    ["node_clotdmg"] = "+{{clotDmg}}% daño infligido por cualquier coágulo.",
    ["node_redclotheartdmg_name"] = "Daño De Coágulos Rojos Por Corazón",
    ["node_redclotheartdmg"] = "+{{redClotHeartDmg}}% daño infligido por coágulos rojos cada 1/2 corazón rojo restante.",
    ["node_soulclotheartdmg_name"] = "Daño De Coágulos De Alma Por Corazón",
    ["node_soulclotheartdmg"] = "+{{soulClotHeartDmg}}% daño infligido por coágulos de alma cada 1/2 corazón de alma restante.",
    ["node_blackclotbabylon_name"] = "Creación De Coágulos Negros",
    ["node_blackclotbabylon"] = {
        "{{blackClotBabylon}}% chance de crear un coágulo negro al matar enemigos mientras el efecto de Ramera de Babilonia",
        "esté activo, si tienes menos de 3 coágulos negros activos."
    },
    ["node_clotdestroyluck_name"] = "Suerte Por Coágulo Destruído",
    ["node_clotdestroyluck"] = "{{clotDestroyedLuck}}% chance de ganar +0.03 suerte cuando cualquier coágulo es destruído.",


    -- T. SAMSON'S TREE --
    ["node_balancedapproach_name"] = "Enfoque Equilibrado",
    ["node_balancedapproach"] = "Comienza con Libra.",
    ["node_tempered_name"] = "Templanza",
    ["node_tempered"] = {
        "Al entrar a una habitación con monstruos, pierde 30% de la carga actual de Berserk.",
        "Gana lágrimas por la habitación actual basado en las carga perdida.",
        "Si Furia Absoluta está asignada, +30% lágrimas mientras Berserk esté activo."
    },
    ["node_violentmarauder_name"] = "Merodeador Violento",
    ["node_violentmarauder"] = {
        "Comienza con Suplex!.",
        "Suplex! solo puede ser usado mientras Berserk esté activo.",
        "Pierde Suplex! por el resto del piso si es usado mientras el efecto de Berserk esté por terminar."
    },
    ["node_absoluterage_name"] = "Furia Absoluta",
    ["node_absoluterage"] = {
        "Gana el efecto de Berserk persistentemente. Infligir daño reduce la duración del efecto.",
        "Una vez terminado el efecto, gana carga de Berserk pasivamente.",
        "{{berserkDmg}}% daño mientras Berserk esté activo.",
        "{{berserkSpeed}}% velocidad mientras Berserk esté activo.",
        "-30% lágrimas mientras Berserk esté activo.",
        "Si consigues Primogenitura, las reducciones de daño, velocidad, y duración al infligir daño se dividen a la mitad."
    },

    ["node_tsamsonmeleedmg_name"] = "Daño Melé",
    ["node_tsamsonmeleedmg"] = {
        "+{{meleeDmg}}% daño melé.",
        "{{nonMeleeDmg}}% daño no melé."
    },
    ["node_berserkonhitcharge_name"] = "Carga De Berserk Al Golpear",
    ["node_berserkonhitcharge"] = "Al golpear enemigos, gana {{berserkHitChargeGain}}% de carga Berserk adicional.",
    ["node_berserkdur_name"] = "Duración De Berserk",
    ["node_berserkdur"] = "+{{berserkDuration}} segundos a la duración total de Berserk.",
    ["node_berserkdmgvsdur_name"] = "Daño Vs Duración De Berserk",
    ["node_berserkdmgvsdur"] = {
        "+{{berserkDmg}}% daño mientras Berserk esté activo.",
        "{{berserkDuration}} segundos a la duración de Berserk."
    },
    ["node_suplexcd_name"] = "Enfriamiento De Suplex",
    ["node_suplexcd"] = "{{suplexCooldown}} segundos al enfriamiento de Suplex!.",
    ["node_berserkcharsize_name"] = "Tamaño De Personaje Con Berserk",
    ["node_berserkcharsize"] = {
        "+{{berserkSize}}% tamaño del personaje mientras Berserk esté activo.",
        "(El daño infligido por Suplex! aumenta basado en el tamaño del personaje)"
    },
    ["node_berserkkilltempheart_name"] = "Corazones Temporales Por Matanza En Berserk",
    ["node_berserkkilltempheart"] = {
        "{{berserkKillTempHeart}}% chance de que los enemigos tiren 1/2 corazón rojo al morir mientras Berserk esté activo, el cual",
        "desaparece luego de 2 segundos."
    },
    ["node_redheartpickupluck_name"] = "Suerte Por Recolección De Corazones Rojos",
    ["node_redheartpickupluck"] = {
        "{{redHeartLuckSamson}}% chance de ganar +0.03 suerte al recolectar corazones rojos, hasta +1 por piso.",
        "Triplica la chance para corazones rojos temporales."
    },
    ["node_berserkspeedtrade_name"] = "Compensación De Velocidad Berserk",
    ["node_berserkspeedtrade"] = {
        "+{{berserkSpdTradeoff}}% velocidad mientras Berserk no esté activo.",
        "-0.0{{berserkSpdTradeoff}} velocidad máxima mientras Berserk esté activo."
    },


    -- T. AZAZEL'S TREE --
    ["node_curseborne_name"] = "Maldición Congénita",
    ["node_curseborne"] = {
        "Al entrar a una habitación con monstruos, aplica la maldición de Hemoptisis a un enemigo aleatorio por cada",
        "0.8 lágrimas que tengas como estadística.",
        "Afecta como mínimo a 1 monstruo.",
        "{{tears}} lágrimas."
    },
    ["node_gildedregrowth_name"] = "Rebrote Dorado",
    ["node_gildedregrowth"] = {
        "Comienza con Ala de Murciélago dorada absorbida.",
        "Gana alas de demonio al matar a 5 enemigos marcados en la habitación actual.",
        "-0.1 velocidad mientras no tengas vuelo."
    },
    ["node_brimsoul_name"] = "Alma Sulfúrica",
    ["node_brimsoul"] = {
        "Gana Azufre mientras tengas exactamente 2 corazones negros enteros.",
        "Pierde Azufre al romperse esta condición.",
        "{{brimstoneDmg}}% daño mientras tengas Azufre.",
        "Azufre ya no puede aparecer naturalmente."
    },
    ["node_darkbestowal_name"] = "Concesión Oscura",
    ["node_darkbestowal"] = {
        "Por cada 20 enemigos malditos que mates, gana un objeto pasivo del diablo aleatorio.",
        "Solo puede activarse una vez por habitación, y el efecto deja de contar matanzas hasta perder el objeto otorgado.",
        "Pierde el objeto otorgado luego de completar 3 habitaciones con el objeto."
    },

    ["node_hemoptysis_slow_name"] = "Chance De Ralentización Con Hemoptisis",
    ["node_hemoptysis_slow"] = "{{hemoptysisSlowChance}}% chance de ralentizar enemigos por 2 segundos al dañarlos con Hemoptisis.",
    ["node_cursedkilltears_name"] = "Lágrimas Por Matanza De Malditos",
    ["node_cursedkilltears"] = "{{cursedKillTears}}% chance de ganar +0.01 lágrimas para el piso actual al matar enemigos malditos, hasta +1.",
    ["node_proximitydmg_name"] = "Daño Por Proximidad",
    ["node_proximitydmg"] = "+{{proximityDamage}}% daño infligido a enemigos, reducido cuanto más lejos esten.",
    ["node_hemoptysis_speed_name"] = "Velocidad De Hemoptisis",
    ["node_hemoptysis_speed"] = "+{{hemoptysisSpeed}}% velocidad por 1 segundo al dañar enemigos con Hemoptisis.",
    ["node_brimstonedmg_name"] = "Daño Con Azufre",
    ["node_brimstonedmg"] = "+{{brimstoneDmg}}% daño mientras tengas Azufre.",
    ["node_flightlessdevildeal_name"] = "Tratos Gratis Sin Vuelo",
    ["node_flightlessdevildeal"] = "{{flightlessDevilDeal}}% chance de que los tratos con el diablo sean gratis mientras no tengas vuelo.",
    ["node_hemoptysisluck_name"] = "Suerte Por Matanza Con Hemoptisis",
    ["node_hemoptysisluck"] = {
        "{{hemoptysisKillLuck}}% chance de ganar +0.03 suerte al matar enemigos con Hemoptisis.",
        "Duplica la chance mientras tengas vuelo."
    },


    -- T. LAZARUS' TREE --
    ["node_ephemeralbond_name"] = "Unión Efímera",
    ["node_ephemeralbond"] = {
        "+{{ephemeralBond}} Unión Efímera",
        "Al entrar a un piso, por cada Unión Efímera que tengas, copia un objeto pasivo aleatorio poseído",
        "por tu forma opuesta.",
        "Los objetos copiados son removidos al entrar al siguiente piso."
    },
    ["node_greatoverlap_name"] = "Gran Superposición",
    ["node_greatoverlap"] = {
        "Completar una habitación sin recibir daño recupera una carga adicional a Cambio.",
        "30% chance de mantener 2 cargas de Cambio al usarlo. Si este efecto no se activa, 50% chance",
        "de mantener 1 carga.",
        "Recibir daño tiene un 50% chance de quitarle 1 carga a Cambio."
    },
    ["node_entanglement_name"] = "Enlazamiento",
    ["node_entanglement"] = {
        "Las estadísticas de tus dos formas se vuelven el promedio entre ellas.",
        "+{{allstatsPerc}}% a todas las estadísticas.",
        "Al recibir daño fatal, activa Cambio en vez de morir, y reduce la vida de tu forma resultante a",
        "1/2 corazón de alma. Esto solo puede ocurrir 1 vez por partida."
    },
    ["node_spiritus_name"] = "Spiritus",
    ["node_spiritus"] = {
        "Completar un piso sin recibir daño te otorga Primogenitura para el siguiente piso.",
        "Primogenitura ya no puede aparecer naturalmente."
    },

    ["node_ephemeralbondboss_name"] = "Unión Efímera Al Matar Jefe Sin Daño",
    ["node_ephemeralbondboss"] = {
        "Al entrar a un piso, {{ephBondBossHitless}}% chance de ganar 1 Unión Efímera si derrotaste al jefe del piso",
        "anterior sin recibir daño.",
        "Las Uniones Efímeras ganadas con este efecto duran hasta el próximo piso."
    },
    ["node_floorephbond_name"] = "Unión Efímera Por Piso",
    ["node_floorephbond"] = "Al entrar a un piso, {{ephBondFloor}}% chance de ganar 1 Unión Efímera para el piso actual.",
    ["node_flipbosshitcharge_name"] = "Recuperación De Carga De Cambio En Jefes",
    ["node_flipbosshitcharge"] = "{{flipBossHitCharge}}% chance de recuperar 1 carga de Cambio al dañar a un jefe.",
    ["node_flipspecialroomcharge_name"] = "Carga De Cambio En Habitaciones Especiales",
    ["node_flipspecialroomcharge"] = {
        "{{flipSpecialRoomCharge}}% chance de cargar Cambio completamente al entrar a una habitación del tesoro, tienda, diablo o",
        "ángel por primera vez en el piso."
    },
    ["node_flipmobhpdown_name"] = "Reducción De Vida De Monstruos Con Cambio",
    ["node_flipmobhpdown"] = "-{{flipMobHPDown}}% vida a todos los monstruos en la habitación al usar Cambio, hasta 4 veces por habitación.",
    ["node_floorwoodchest_name"] = "Cofres De Madera",
    ["node_floorwoodchest"] = {
        "{{floorWoodenChest}}% chance de crear un cofre de madera al entrar a un piso.",
        "Este efecto no se activa en el primer piso."
    },
    ["node_formstatupkill_name"] = "Aumento De Estadísticas Al Matar",
    ["node_formstatupkill"] = {
        "+{{lazFormKillStat}}% a una estadística aleatoria para la forma actual, cada 8 matanzas con la forma actual.",
        "Este bonus se reinicia en cada piso.",
        "Este efecto puede activarse hasta 8 veces por piso."
    },
    ["node_formhpdiffluck_name"] = "Suerte Por Diferencia De Vida Entre Formas",
    ["node_formhpdiffluck"] = {
        "+{{formHeartDiffLuck}} suerte por cada 1/2 corazón de diferencia entre tus dos formas, hasta +2.",
        "Cuenta el total de corazones de cualquier tipo."
    },


    -- T. EDEN'S TREE --
    ["node_serendipitoussoul_name"] = "Alma Fortuita",
    ["node_serendipitoussoul"] = {
        "Comienza con Alma de Eden.",
        "Alma de Eden no puede ser cambiada, y no puedes conseguir otros objetos activos mientras la tengas.",
        "Pierde todas las cargas con Alma de Eden al recibir daño.",
        "Al usar Alma de Eden, gana Primogenitura si no la tienes.",
        "Mientras tengas Primogenitura, usar cualquier objeto activo tiene un {{birthrightActiveRemoveChance}}% chance de removerla.",
        "Primogenitura ya no puede aparecer naturalmente."
    },
    ["node_blessedcrucifix_name"] = "Crucifijo Bendecido",
    ["node_blessedcrucifix"] = {
        "Comienza con Cruz de Madera absorbida.",
        "Cuando recibas daño fatal mientras tengas alguna Cruz de Madera (absorbida o no), nulifica el daño y",
        "pierde una Cruz de Madera.",
    },
    ["node_normalizedvitality_name"] = "Vitalidad Normalizada",
    ["node_normalizedvitality"] = {
        "Al entrar a un piso:",
        "  - Si tienes menos de 3 corazones rojos, gana un contenedor de corazón rojo.",
        "  - Si tienes más de 5 corazones rojos, pierde un contenedor de corazón rojo.",
        "  - Si tienes menos de 2 corazones de alma/negros, gana un corazón de alma.",
        "  - Si tienes más de 4 corazones de alma/negros, pierde un corazón de alma/negro.",
        "  - Si tienes corazones rotos, pierde uno."
    },
    ["node_chaostaketheworld_name"] = "Que El Caos Se Apodere Del Mundo",
    ["node_chaostaketheworld"] = {
        "Comienza con el efecto de Caos.",
        "Recibir daño activa el efecto de D10, una vez por habitación.",
        "Usar un objeto activo con por lo menos 2 cargas adicionalmente activa el efecto de Manuscritos del Mar Muerto."
    },

    ["node_itemrerollavoid_name"] = "Evitación De Rerolleo De Items",
    ["node_itemrerollavoid"] = "{{rerollAvoidance}}% chance de no rerollear objetos al recibir daño.",
    ["node_devilactiveonhit_name"] = "Objeto Activo Del Diablo Al Recibir Daño",
    ["node_devilactiveonhit"] = "{{devilActiveOnHit}}% chance de activar el efecto de un objeto del diablo activo aleatorio al recibir daño, una vez por habitación.",
    ["node_angelactiveonhit_name"] = "Objeto Activo Del Ángel Al Recibir Daño",
    ["node_angelactiveonhit"] = "{{angelActiveOnHit}}% chance de activar el efecto de un objeto del ángel activo aleatorio al recibir daño, una vez por habitación.",
    ["node_birthrightactiverem_name"] = "Chance De Perder Primogenitura",
    ["node_birthrightactiverem"] = "{{birthrightActiveRemoveChance}}% chance de perder Primogenitura al usar objetos activos.",
    ["node_shieldactivestat_name"] = "Estadísticas Al Usar Activos Con Escudos",
    ["node_shieldactivestat"] = {
        "+{{shieldActiveStat}}% a una estadística aleatoria al usar un objeto activo mientras tengas el escudo de Manto Sangrado o Cruz de Madera y",
        "hayan monstruos en la habitación, una vez por habitación.",
        "Este bonus se reinicia en cada piso."
    },
    ["node_treasureitemonhit_name"] = "Objeto Del Tesoro Al Recibir Daño",
    ["node_treasureitemonhit"] = {
        "Al recibir daño, {{treasureItemOnHit}}% chance de obtener un objeto pasivo aleatorio de la habitación del tesoro para",
        "la habitación actual como efecto innato, excluyendo objetos que den vida o que ya tengas.",
        "Este efecto solo puede activarse una vez por habitación."
    },
    ["node_higherqualreroll_name"] = "Chance De Reroll De Mejor Calidad",
    ["node_higherqualreroll"] = {
        "Al rerollear tus objetos, {{higherQualityReroll}}% chance de rerollear uno de los objetos resultantes a uno con +1 calidad.",
        "Este efecto solo puede activarse 5 veces por piso."
    },
    ["node_minluck_name"] = "Suerte Mínima",
    ["node_minluck"] = {
        "+{{minLuck}} suerte mínima.",
        "Requiere asignar el nodo \"Base Mínima De Suerte\" para tener efecto."
    },
    ["node_baseminluck_name"] = "Base Mínima De Suerte",
    ["node_baseminluck"] = "Tu suerte mínima ahora es {{minLuck}}.",


    -- T. LOST'S TREE --
    ["node_glass_specter_name"] = "Espectro de Vidrio",
    ["node_glass_specter"] = {
        "+{{damage}} velocidad y daño.",
        "Tu velocidad se vuelve un multiplicador de daño si está por encima de 1.",
        "Reduce este bonus de daño por la mitad mientras tengas un escudo activo.",
        "Cada 4 habitaciones completadas mientras tengas un escudo, quita todos los escudos.",
        "Ya no comienzas con una Carta Sagrada."
    },
    ["node_helpinghands_name"] = "Manos Amigas",
    ["node_helpinghands"] = {
        "Las habitaciones del Diablo/Ángel tienen un 50% chance de contener una Carta Sagrada adicional si",
        "no tienes una.",
        "Recolectar una Carta Sagrada quita todos los demás objetos en la habitación del Diablo/Ángel.",
        "Recolectar un objeto o hacer un trato en la habitación del Diablo/Ángel quita todas las Cartas Sagradas presentes.",
        "Al derrotar a Mama, crea una Carta Sagrada si no tienes una.",
        "Ahora puedes apilar Cartas Sagradas recolectando más mientras ya tengas una."
    },
    ["node_deferredaegis_name"] = "Égida Diferida",
    ["node_deferredaegis"] = {
        "Completar un piso entero sin usar más de 1 Carta Sagrada te otorga un escudo de Manto Sagrado.",
        "Si el nodo Espectro de Vidrio está asignado, aumenta el retraso antes de quitar escudos en +4 habitaciones."
    },
    ["node_spindown_name"] = "Reductor",
    ["node_spindown"] = {
        "Comienza con Dado Reductor.",
        "Pierde Dado Reductor luego de usarlo 2 veces.",
        "-0.05 velocidad por cada objeto afectado en la habitación al usar Dado Reductor, hasta -0.35."
    },

    ["node_qual0upg_name"] = "Mejora De Calidad 0",
    ["node_qual0upg"] = {
        "Al entrar a una habitación por primera vez, {{quality0Upgrade}}% chance de rerollear objetos de calidad 0 a un",
        "objeto aleatorio de calidad 1 del mismo grupo.",
        "Los nodos de mejora de calidad solo se activan una vez basado en la calidad inicial del objeto."
    },
    ["node_qual1upg_name"] = "Mejora De Calidad 1",
    ["node_qual1upg"] = {
        "Al entrar a una habitación por primera vez, {{quality1Upgrade}}% chance de rerollear objetos de calidad 1 a un",
        "objeto aleatorio de calidad 2 del mismo grupo.",
        "Los nodos de mejora de calidad solo se activan una vez basado en la calidad inicial del objeto."
    },
    ["node_qual2upg_name"] = "Mejora De Calidad 2",
    ["node_qual2upg"] = {
        "Al entrar a una habitación por primera vez, {{quality2Upgrade}}% chance de rerollear objetos de calidad 2 a un",
        "objeto aleatorio de calidad 3 del mismo grupo.",
        "Los nodos de mejora de calidad solo se activan una vez basado en la calidad inicial del objeto."
    },
    ["node_roomenterspeed_name"] = "Velocidad De Entrada A Habitación",
    ["node_roomenterspeed"] = "+{{roomEnterSpd}}% velocidad al entrar a una habitación con monstruos, la cual disminuye a 0 sobre 4 segundos.",
    ["node_speed_decaydur_name"] = "Duración De Disminución De Velocidad",
    ["node_speed_decaydur"] = "+{{roomEnterSpdDecayDur}} segundos de duración a la disminución de velocidad de entrada a habitación.",
    ["node_shieldlessboss_speed_name"] = "Velocidad Al Completar Jefe Sin Escudos",
    ["node_shieldlessboss_speed"] = "+{{shieldlessBossSpeed}} velocidad para el siguiente piso al completar la habitación del jefe sin tener o recibir escudos.",
    ["node_champholycard_name"] = "Cartas Sagradas De Campeones",
    ["node_champholycard"] = "{{champHolyCardDrop}}% chance de que los campeones tiren una Carta Sagrada al morir, una vez cada 2 pisos.",
    ["node_stairwayboon_name"] = "Bendición De La Escalera",
    ["node_stairwayboon"] = {
        "{{stairwayBoon}}% chance de recibir La Escalera al completar una habitación del jefe.",
        "Recibir golpes reduce la chance total de activar este efecto por la mitad, aunque tengas escudos presentes.",
        "Entrar a una habitación del diablo/ángel reduce la chance total de activar este efecto por la mitad.",
        "Pierde La Escalera una vez que ésta se active al entrar a un piso."
    },
    ["node_deathtrial_name"] = "Juicio De La Muerte",
    ["node_deathtrial"] = {
        "Al recibir daño fatal en (o por delante de) el 4to piso que entres, {{deathTrial}}% chance de activar el efecto de Olvídame Ya en vez de morir.",
        "Una vez ocurrido esto:",
        "  - Muerte aparece. Muerte recibe 66% menos daño durante esta pelea.",
        "  - Pierde todas tus Cartas Sagradas y escudos presentes.",
        "Este efecto solo puede activarse una vez por partida."
    },
    ["node_holycardluck_name"] = "Suerte De Cartas Sagradas",
    ["node_holycardluck"] = "+{{holyCardLuck}} suerte para el piso actual al usar una Carta Sagrada.",


    -- T. LILITH'S TREE --
    ["node_chargingbehemoth_name"] = "Gigante De Carga",
    ["node_chargingbehemoth"] = {
        "El ataque de látigo inflige {{whipDmg}}% más daño.",
        "Los enemigos golpeados con el ataque de látigo son ralentizados por 1 segundo.",
        "{{tearsPerc}}% lágrimas.",
        "{{nonWhipDmg}}% daño con golpes que no sean del látigo."
    },
    ["node_mightygestation_name"] = "Gestación Poderosa",
    ["node_mightygestation"] = {
        "Comienza con Bebé Doblador absorbido.",
        "+{{tearsPerc}}% lágrimas.",
        "+{{nonWhipDmg}}% daño con golpes que no sean del látigo.",
        "{{whipDmg}}% daño con el ataque de látigo."
    },
    ["node_coordinated_demons_name"] = "Demonios Coordinados",
    ["node_coordinated_demons"] = {
        "Mientras dispares, periódicamente activa un pulso alrededor de Gello, infligiendo 70% de tu daño a",
        "enemigos cercanos.",
        "El retraso entre pulsos se basa en tu estadística de lágrimas.",
        "Luego de retractar a Gello, esperar 2 segundos aumentará el daño de tu siguiente ataque de látigo en 30%.",
        "-0.15 velocidad mientras dispares."
    },
    ["node_chimericamalgam_name"] = "Amalgama Quimérica",
    ["node_chimericamalgam"] = {
        "Cada 2 pisos, crea Primogenitura en la primer habitación si no la tienes.",
        "Al obtener Primogenitura, convierte a todos tus familiares actuales a Mini-Delirio.",
        "Al obtener Primogenitura, -40% daño.",
        "Mientras tengas Primogenitura, +8% daño al entrar a un nuevo piso, hasta +50%.",
        "Primogenitura ya no puede aparecer naturalmente."
    },

    ["node_whipdmgvstears_name"] = "Daño De Látigo Vs Lágrimas",
    ["node_whipdmgvstears"] = {
        "+{{whipDmg}}% daño con el ataque de látigo.",
        "{{tearsPerc}}% lágrimas."
    },
    ["node_tlilith_pulsedmg_name"] = "Daño Del Pulso",
    ["node_tlilith_pulsedmg"] = "El pulso dañino inflige un {{gelloPulseDmg}}% adicional de tu daño.",
    ["node_pulsekillblackheart_name"] = "Corazón Negro Al Matar Con Pulso",
    ["node_pulsekillblackheart"] = {
        "Los enemigos matados con el pulso dañino tienen un {{pulseKillBlackHeart}}% chance de tirar un corazón negro,",
        "si tienes menos de 2 corazones negros, una vez por habitación.",
        "Los corazones negros creados por este efecto desaparecen luego de 3 segundos."
    },
    ["node_whipspeedbuff_name"] = "Velocidad Por Látigo",
    ["node_whipspeedbuff"] = "+{{whipSpeed}}% velocidad por 1 segundo luego de usar el ataque de látigo.",
    ["node_gellotearbonus_name"] = "Lágrimas Bonus Por Gello",
    ["node_gellotearbonus"] = {
        "Lentamente gana hasta +{{gelloTearsBonus}} lágrimas mientras Gello esté retractado.",
        "Mientras dispares, el bonus decae a 0 sobre 3 segundos."
    },
    ["node_cord_dmg_name"] = "Daño Del Cordón",
    ["node_cord_dmg"] = {
        "Mientras Gello esté fuera, inflige {{cordDamage}}% de tu daño a enemigos atrapados en su cordón cada segundo.",
        "{{cordBleed}}% chance de infligir sangrado por 4 segundos a los enemigos afectados."
    },
    ["node_treasurefamiliar_name"] = "Familiar En Habitación Del Tesoro",
    ["node_treasurefamiliar"] = {
        "Mientras no tengas Primogenitura, {{tLilithTreasureBaby}}% chance de reemplazar el objeto de la habitación del tesoro",
        "con un bebé familiar aleatorio."
    },
    ["node_nearbykill_luck_name"] = "Suerte Por Muerte Cercana",
    ["node_nearbykill_luck"] = {
        "{{nearbyKillLuck}}% chance de ganar +0.03 suerte al matar enemigos dentro de 1.5 casillas de ti.",
        "Reduce el bonus total a la mitad al entrar a un nuevo piso."
    },
    ["node_famitemallstat_name"] = "Estadísticas Por Objetos De Familiar",
    ["node_famitemallstat"] = "+{{familiarItemAllstats}}% a todas las estadísticas por cada objeto de familiar obtenido.",


    -- T. KEEPER'S TREE --
    ["node_fortunatespender_name"] = "Gastador Afortunado",
    ["node_fortunatespender"] = {
        "+1.5 suerte para el piso actual mientras no hayas comprado objetos.",
        "+0.02 suerte por moneda gastada en compras, hasta un total de +3.",
        "Al entrar a un piso, -0.5 suerte si realizaste menos de 4 compras en el piso anterior.",
        "Esta reducción de suerte no se aplica durante el Ascenso."
    },
    ["node_marquessofflies_name"] = "Marqués De Las Moscas",
    ["node_marquessofflies"] = {
        "Cada vez que consigas monedas, 50% chance de crear una mosca azul si tienes menos de 20 moscas.",
        "Cada vez que una moneda te cure, 20% chance de obtener Mente de Colmena para la habitación actual si no la tienes.",
        "Aumenta el daño infligido por moscas azules en 1% por moneda que tengas, hasta 50%.",
        "-1% velocidad por mosca azul presente."
    },
    ["node_strangecoupon_name"] = "Cupón Extraño",
    ["node_strangecoupon"] = {
        "Comienza con Cupón.",
        "Cada vez que consigas cargas con Cupón, {{couponNullifyChance}}% chance de nulificar las cargas ganadas.",
        "Luego de usar Cupón un total de 4 veces, piérdelo y obten Rebajas de Steam.",
        "Pierde Rebajas de Steam luego de comprar 4 objetos con ésta presente."
    },
    ["node_blessedpennies_name"] = "Centavos Bendecidos",
    ["node_blessedpennies"] = {
        "Las tiendas tienen un 25% chance de vender un trinket de moneda adicional, a doble de precio.",
        "Al derrotar al jefe del piso, si no recibiste daño en el resto del piso, absorbe tu trinket actual si éste",
        "es un trinket de moneda.",
        "Crea una moneda al absorber un trinket de moneda de esta manera.",
        "Al recibir daño, 20% chance de perder los trinkets de monedas que tengas (no absorbidos)."
    },
    ["node_voodootrick_name"] = "Truco Vudú",
    ["node_voodootrick"] = {
        "Completar un piso sin recibir daño más de 3 veces te otorga Cabeza Vudú para el siguiente piso.",
        "Cabeza Vudú ya no puede aparecer naturalmente."
    },

    ["node_tempcointimer_name"] = "Duración De Monedas Temporales",
    ["node_tempcointimer"] = "+{{vanishCoinTimer}} segundos a la duración de las monedas temporales.",
    ["node_cointearchance_name"] = "Chance De Lágrimas De Moneda",
    ["node_cointearchance"] = {
        "{{coinTearsChance}}% chance de que las lágrimas disparadas sean lágrimas de moneda.",
        "Si la chance total está por encima de 40%, Cabeza de Keeper ya no puede aparecer naturalmente.",
        "Las lágrimas de moneda infligen 10% más daño contra monstruos dorados."
    },
    ["node_gildmobpennydrop_name"] = "Monedas Por Monstruos Dorados",
    ["node_gildmobpennydrop"] = "{{gildMonsterPenny}}% chance de que los monstruos dorados tiren una moneda adicional al morir.",
    ["node_gildmobluck_name"] = "Suerte Por Monstruos Dorados",
    ["node_gildmobluck"] = "{{gildMonsterLuck}}% chance de ganar +0.05 suerte para el piso actual al matar a un monstruo dorado.",
    ["node_gildmobspeed_name"] = "Velocidad Por Monstruos Dorados",
    ["node_gildmobspeed"] = "+{{gildMonsterSpeed}}% velocidad para la habitación actual al matar a un monstruo dorado.",
    ["node_gildmobpennyupg_name"] = "Mejora De Trinket De Moneda Por Monstruos Dorados",
    ["node_gildmobpennyupg"] = {
        "{{gildMonsterPennyUpgrade}}% chance de mejorar 1 trinket de moneda que tengas a su versión dorada al matar a un",
        "monstruo dorado."
    },
    ["node_gildmobs_name"] = "Monstruos Dorados",
    ["node_gildmobs"] = "{{gildMonsters}}% chance de que los monstruos en habitaciones se vuelvan dorados. No puede afectar a jefes.",
    ["node_voodoocursenickel_name"] = "Níquel Vudú En Habitaciones Malditas",
    ["node_voodoocursenickel"] = {
        "Mientras tengas Cabeza Vudú, {{voodooCurseNickel}}% chance de que las habitaciones malditas tengan un níquel",
        "adicional presente."
    },
    ["node_couponchargenull_name"] = "Nulificación De Cargas De Cupón",
    ["node_couponchargenull"] = "{{couponNullifyChance}}% chance de nulificar cargas ganadas con Cupón.",
    ["node_blueflydmg_name"] = "Daño De Moscas Azules",
    ["node_blueflydmg"] = "+{{blueFlyDamage}}% daño infligido por moscas azules.",
    ["node_steamsalekeep_name"] = "Chance De Mantener Rebajas De Steam",
    ["node_steamsalekeep"] = "{{steamSaleKeep}}% chance de mantener Rebajas de Steam al comprar más de 4 objetos teniéndola.",


    -- T. APOLLYON'S TREE --
    ["node_electrifiedswarm_name"] = "Enjambre Eléctrico",
    ["node_electrifiedswarm"] = {
        "Comienza con Cable de Extensión absorbido.",
        "Las lágrimas disparadas por langostas tienen un 33% chance de ser eléctricas.",
        "Los rayos del Cable de Extensión infligen 33% menos daño."
    },
    ["node_closekeeper_name"] = "Colmenero",
    ["node_closekeeper"] = {
        "Las langostas te siguen mucho más cercanamente.",
        "+2% daño recibido por enemigos por cada langosta cerca de este, hasta 20%."
    },
    ["node_carrionlocusts_name"] = "Langostas Carroñeras",
    ["node_carrionlocusts"] = {
        "+1% a una estadística aleatoria cada vez que una langosta mate a un enemigo, hasta +12% de cada estadística.",
        "Cada 20 enemigos matados por langostas, gana un trinket de langosta absorbido aleatorio que no tengas.",
        "Entrar a un piso reduce los bonuses de este efecto por la mitad y quita los trinkets de langosta absorbidos."
    },
    ["node_greatdevourer_name"] = "Gran Devorador",
    ["node_greatdevourer"] = {
        "Ahora solo puedes tener hasta 1 langosta.",
        "Cada vez que hubieras obtenido una langosta, en cambio añade +8% daño y velocidad a la langosta existente, hasta +200%.",
        "Duplica el daño del rayo de Cable de Extensión si este se dirige a una langosta.",
        "Triplica tu chance total de que las langostas disparen lágrimas, y éstas infligen un {{locustTearDmgInherit}}% adicional de tu daño.",
        "Si Enjambre Eléctrico está asignado, las lágrimas de las langostas siempre estarán electrificadas."
    },

    ["node_extensioncorddmg_name"] = "Daño Del Rayo De Cable De Extensión",
    ["node_extensioncorddmg"] = "Los rayos de Cable de Extensión infligen un {{extCordDmgInherit}}% adicional de tu daño si se dirigen a alguna langosta.",
    ["node_extensioncordslow_name"] = "Ralentización Con Rayos De Cable De Extensión",
    ["node_extensioncordslow"] = {
        "{{extCordSlow}}% chance de que los rayos de Cable de Extensión ralentizen a los enemigos afectados por 2 segundos,",
        "si se dirigen a alguna langosta."
    },
    ["node_locusttears_name"] = "Lágrimas De Langostas",
    ["node_locusttears"] = {
        "1.5% chance de que las langostas disparen una pequeña lágrima hacia enemigos cercanos cada vez que dispares.",
        "Las lágrimas de langosta infligen 20% de tu daño como base."
    },
    ["node_locustteardmg_name"] = "Daño De Lágrimas De Langosta",
    ["node_locustteardmg"] = "Las lágrimas de langostas ganan un {{locustTearDmgInherit}}% adicional de tu daño.",
    ["node_locustlostcontact_name"] = "Lágrimas De Langostas Espectrales",
    ["node_locustlostcontact"] = "{{locustTearSpectral}}% chance de que las lágrimas disparadas por langostas sean espectrales y perforantes.",
    ["node_locustkillpickup_name"] = "Recolectables Por Matanzas De Langostas",
    ["node_locustkillpickup"] = {
        "{{locustKillPickup}}% chance de que los enemigos matados por langostas tiren una moneda/llave/bomba adicional, hasta",
        "2 veces por habitación."
    },
    ["node_locustkilltears_name"] = "Bendición De Lágrimas Por Matanzas De Langostas",
    ["node_locustkilltears"] = "+{{locustKillTears}}% lágrimas por 2 segundos cada vez que una langosta mata a un enemigo.",
    ["node_cricketlegonkill_name"] = "Pata De Grillo Al Matar",
    ["node_cricketlegonkill"] = "{{killCricketLeg}}% chance de obtener Pata de Grillo absorbida al matar enemigos.",
    ["node_cricketlegspeed_name"] = "Velocidad Con Pata De Grillo",
    ["node_cricketlegspeed"] = "+{{cricketLegSpeed}}% velocidad mientras tengas Pata de Grillo.",
    ["node_locustdmg_name"] = "Daño De Langostas",
    ["node_locustdmg"] = "+{{locustDmg}}% daño infligido por langostas.",
    ["node_locustkill_luck_name"] = "Suerte Por Matanzas De Langostas",
    ["node_locustkill_luck"] = {
        "{{locustKillLuck}}% chance de ganar +0.04 suerte cuando una langosta mata a un enemigo.",
        "Reduce el bonus total por la mitad al entrar a un nuevo piso."
    },


    -- T. FORGOTTEN'S TREE --
    ["node_recall_name"] = "Llamado!",
    ["node_recall"] = {
        "Comienza con Primogenitura.",
        "+0.4 segundos al enfriamiento de Llamado al usarlo, hasta +4.",
        "Reinicia el enfriamiento de Llamado al entrar a un nuevo piso.",
        "Primogenitura ya no puede aparecer naturalmente."
    },
    ["node_harmonizedspecters_name"] = "Espectros Armónicos",
    ["node_harmonizedspecters"] = {
        "+8% daño infligido por Olvidado Corrupto mientras esté en el piso.",
        "+8% daño infligido por Olvidado Corrupto a enemigos cerca de Alma Corrupta.",
        "+8% daño infligido por Olvidado Corrupto mientras un Bony aliado (cualquier variante) esté presente."
    },
    ["node_ballistosseous_name"] = "Proyectiles Oseos",
    ["node_ballistosseous"] = {
        "Olvidado Corrupto dispara lágrimas de hueso persecutoras hacia Alma Corrupta mientras esté en el piso, si",
        "hay monstruos restantes en la habitación.",
        "Mientras sostengas a Olvidado Corrupto, dispara estas lágrimas hacia enemigos cercanos, a 40% de la cadencia",
        "de disparo normal.",
        "Las lágrimas de hueso infligen 50% de tu daño."
    },
    ["node_magnetizedshell_name"] = "Caparazón Magnético",
    ["node_magnetizedshell"] = {
        "Comienza con Atractor Extraño.",
        "{{speedPerc}}% velocidad.",
        "+2% velocidad para la habitación actual al matar a un enemigo cerca de Olvidado Corrupto, hasta +20%."
    },

    ["node_forgholdspeed_name"] = "Velocidad Al Sostener A Olvidado",
    ["node_forgholdspeed"] = "+{{forgHoldSpeed}}% velocidad mientras sostienes a Olvidado Corrupto.",
    ["node_forgboneteardmg_name"] = "Daño De Lágrimas De Hueso",
    ["node_forgboneteardmg"] = "Las lágrimas de hueso de Olvidado Corrupto infligen un {{forgBoneTearDmg}}% adicional de tu daño.",
    ["node_forgbonetearpara_name"] = "Parálisis Con Lágrimas De Hueso",
    ["node_forgbonetearpara"] = "{{forgBoneTearPara}}% chance de que las lágrimas de hueso de Olvidado Corrupto paralizen a los enemigos por 1 segundo.",
    ["node_forgbonetearslow_name"] = "Ralentización Con Lágrimas De Hueso",
    ["node_forgbonetearslow"] = "{{forgBoneTearSlow}}% chance de que las lágrimas de hueso de Olvidado Corrupto ralentizen a los enemigos por 2 segundos.",
    ["node_paramobdmg_name"] = "Daño Contra Parálisis",
    ["node_paramobdmg"] = "+{{paraEnemyDmg}}% daño recibido por enemigos paralizados.",
    ["node_recalldmg_name"] = "Bendición De Daño Con Llamado",
    ["node_recalldmg"] = "+{{recallDmg}}% daño por 2 segundos luego de usar Llamado.",
    ["node_forgtele_name"] = "Telekinesis Con Lanzamiento Del Olvidado",
    ["node_forgtele"] = "{{forgTelekinesis}}% chance de activar el efecto de Telekinesis al lanzar a Olvidado Oscuro.",
    ["node_forgbonetearluck_name"] = "Suerte Por Matanzas Con Lágrimas De Hueso",
    ["node_forgbonetearluck"] = {
        "{{forgBoneTearKillLuck}}% chance de ganar +0.03 suerte cuando las lágrimas de hueso de Olvidado Corrupto matan a un enemigo.",
        "Reduce este bonus por la mitad al entrar a un nuevo piso."
    },


    -- T. BETHANY'S TREE --
    ["node_bloodharvest_name"] = "Cosecha de Sangre",
    ["node_bloodharvest"] = {
        "Matar a un enemigo con por lo menos 12 HP tiene un 25% chance de crear 1/2 corazón rojo, el cual desaparece luego",
        "de 3 segundos, hasta 6 veces por habitación.",
        "Golpear a un jefe tiene un 7% chance de crear 1/2 corazón rojo, el cual desaparece luego de 3 segundos, hasta",
        "4 veces por habitación.",
        "Estas chances son reducidas por 0.3% por cada Carga de Sangre que tengas sobre 30."
    },
    ["node_resilientflickers_name"] = "Fuegos Resistentes",
    ["node_resilientflickers"] = {
        "Los fuegos fatuos de Lemegeton reciben 60% menos daño.",
        "Los fuegos fatuos de Lemegeton infligen 35% más daño de contacto.",
        "Recupera completamente la vida de un fuego fatuo cuando este mata a un enemigo con daño de contacto.",
        "-0.03 suerte por cada fuego fatuo presente sobre 5."
    },
    ["node_othersideseeker_name"] = "Buscadora De Espejismos",
    ["node_othersideseeker"] = {
        "Comienza con 3 Llaves de Cristal absorbidas.",
        "Derrotar a Mama sin recibir daño te otorga una Llave de Cristal absorbida adicional.",
        "+1% a todas las estadísticas para el piso actual al completar una habitación roja, hasta +10%."
    },
    ["node_inheritedchaos_name"] = "Caos Heredado",
    ["node_inheritedchaos"] = {
        "Al entrar a un piso, crea un fuego fatuo con Caos si no tienes uno.",
        "Los fuegos fatuos con Caos reciben 200% más daño al ser golpeados.",
        "-3% a todas las estadísticas cada vez que un fuego fatuo con Caos es destruído, hasta -12%."
    },

    ["node_redheartroomdmg_name"] = "Daño Por Corazones Rojos",
    ["node_redheartroomdmg"] = "+{{redHeartRoomDmg}}% daño para la habitación actual al recolectar corazones rojos, hasta +15%.",
    ["node_wisptearretal_name"] = "Represalias De Fuegos Fatuos",
    ["node_wisptearretal"] = {
        "{{wispHomingTearRetal}}% chance de que los fuegos fatuos disparen una lágrima persecutora cuando reciben daño.",
        "Éstas lágrimas infligen 5 de daño."
    },
    ["node_wispactivehomtears_name"] = "Lágrimas De Fuegos Fatuos Por Activos",
    ["node_wispactivehomtears"] = {
        "{{wispActiveTears}}% chance de que los fuegos fatuos disparen una lágrima persecutora en tu dirección al usar",
        "un objeto activo.",
        "Éstas lágrimas infligen 30% de tu daño + 2 de daño adicional por carga usada."
    },
    ["node_destroywispitem_name"] = "Objetos De Fuegos Fatuos Destruídos",
    ["node_destroywispitem"] = "{{destroyedWispItem}}% chance de obtener el objeto perteneciente a un fuego fatuo destruído por el resto del piso.",
    ["node_bluekeyonred_name"] = "Llave Azul Al Completar Habitación Roja",
    ["node_bluekeyonred"] = {
        "{{blueKeyRedClear}}% chance de obtener una Llave Azul absorbida para el piso actual al completar una habitación roja,",
        "si no tienes una."
    },
    ["node_bloodchargestat_name"] = "Estadísticas Al Usar Cargas De Sangre",
    ["node_bloodchargestat"] = {
        "{{bloodChargeStat}}% chance de ganar +0.4% a una estadística aleatoria por carga de sangre consumida, hasta 30",
        "veces por piso."
    },
    ["node_wispkillsoul_name"] = "Corazones De Alma Por Matanzas De Fuegos Fatuos",
    ["node_wispkillsoul"] = {
        "{{wispKillSoul}}% chance de que los enemigos matados por fuegos fatuos o sus lágrimas tiren 1/2 corazón de alma si",
        "tienes menos de 3 corazones de alma, hasta 4 veces por habitación."
    },
    ["node_homingtearfirereq_name"] = "Tiempo Requerido Por Lágrima Coalescente",
    ["node_homingtearfirereq"] = {
        "{{tBethHomingTear}} segundos al tiempo total requerido por Lágrima Persecutora Coalescente.",
        "{{tBethHomingTearFear}}% chance de que esta lágrima cause miedo en los enemigos que dañe."
    },
    ["node_coalescinghomtear_name"] = "Lágrima Persecutora Coalescente",
    ["node_coalescinghomtear"] = {
        "Cada {{tBethHomingTear}} segundos totales disparando, adicionalmente dispara una lágrima perforante y persecutora que",
        "inflige 150% de tu daño."
    },
    ["node_tbethkill_luck_name"] = "Suerte Al Matar",
    ["node_tbethkill_luck"] = {
        "{{tBethKillLuck}}% chance de ganar +0.03 suerte al matar enemigos mientras tengas 1 corazón de alma/negro o menos.",
        "Triplica la chance y suerte ganada contra jefes."
    },


    -- T. JACOB'S TREE --
    ["node_reaperwraiths_name"] = "Espectros Segadores",
    ["node_reaperwraiths"] = {
        "Comienza con Manto Sagrado.",
        "Comienza con un corazón eterno adicional. Entrar a un piso te otorga un corazón eterno si no tienes uno.",
        "Al entrar a un piso, pierde todos los corazones de alma/negros.",
        "Jacob Corrupto ahora comienza en su estado espiritual, y entrar a un nuevo piso ya no lo revive.",
        "Esau Corrupto ya no puede dañarte."
    },
    ["node_wrathfulchains_name"] = "Cadenas Coléricas",
    ["node_wrathfulchains"] = {
        "Cuando Esau Corrupto es desencadenado por Anima Sola, todos los enemigos no-jefes son ralentizados por 3 segundos.",
        "Usar Anima Sola mientras Esau Corrupto está presente adicionalmente encadena a otro enemigo aleatorio en la habitación.",
        "Los enemigos encadenados por Anima Sola reciben {{chainedEnemyDmg}}% más daño.",
        "Golpear a un enemigo encadenado por Anima Sola inflige 40% del daño recibido a otros enemigos cercanos."
    },
    ["node_spiritualcovenant_name"] = "Pacto Espiritual",
    ["node_spiritualcovenant"] = {
        "Golpear a un enemigo causa que Esau Corrupto lo persiga, si Jacob Corrupto está en su estado espiritual.",
        "El daño de contacto base de Esau Corrupto se vuelve 200% de tu estadística de daño, con máximo 40."
    },
    ["node_kineticvengeance_name"] = "Venganza Cinética",
    ["node_kineticvengeance"] = {
        "Esau Corrupto inflige 25% más daño durante su embestida.",
        "Esau Corrupto inflige 25% menos daño mientras no esté embistiendo."
    },

    ["node_darkesauproxbuff_name"] = "Bendición De Proximidad A Esau Corrupto",
    ["node_darkesauproxbuff"] = {
        "+{{darkEsauProxDmgSpeed}}% velocidad y daño cuando estes cerca de Esau Corrupto.",
        "Éste efecto se mantiene por 2 segundos al romperse la condición."
    },
    ["node_darkesaudmg_name"] = "Daño De Esau Corrupto",
    ["node_darkesaudmg"] = "+{{darkEsauDmg}}% daño infligido por Esau Corrupto hacia monstruos.",
    ["node_animasolacd_name"] = "Enfriamiento De Anima Sola",
    ["node_animasolacd"] = "{{animaSolaCooldown}} segundos al enfriamiento de Anima Sola.",
    ["node_animasolatears_name"] = "Bendición De Lágrimas De Anima Sola",
    ["node_animasolatears"] = "+{{animaSolaKillTears}}% lágrimas para el piso actual al matar a un enemigo encadenado por Anima Sola, hasta +15%.",
    ["node_eternalheartconv_name"] = "Conversión A Corazones Eternos",
    ["node_eternalheartconv"] = {
        "{{heartEternalConv}}% chance de convertir corazones rojos encontrados a corazones eternos mientras Jacob está en su estado espiritual.",
        "Mientras Jacob está en su estado espiritual, los corazones eternos actúan como escudos, similarmente a las Cartas Sagradas."
    },
    ["node_slowedmobdmg_name"] = "Daño Recibido Por Enemigos Ralentizados",
    ["node_slowedmobdmg"] = "Los enemigos ralentizados reciben {{slowEnemyDmg}}% más daño.",
    ["node_animasoladur_name"] = "Duración De Anima Sola",
    ["node_animasoladur"] = "+{{animaSolaDuration}}% a la duración de las cadenas de Anima Sola.",
    ["node_darkesaukill_luck_name"] = "Suerte Por Matanzas De Esau Corrupto",
    ["node_darkesaukill_luck"] = "{{darkEsauKillLuck}}% chance de ganar +0.04 para el piso actual cuando Esau Corrupto mata a un enemigo.",
    ["node_animasolachains_name"] = "Encadenamientos Adicionales De Anima Sola",
    ["node_animasolachains"] = {
        "{{animaAddChains}}% chance de que Anima Sola encadene a un enemigo adicional al usarse.",
        "Este efecto puede activarse múltiples veces si la chance total excede 100%."
    },


    -- T. SIREN'S TREE --
    ["node_soulofthesiren_name"] = "Alma de la Sirena",
    ["node_soulofthesiren"] = {
        "Asigna este nodo para desbloquear el Alma de la Sirena como una variante de piedra de alma.",
        "Requiere completar la Boss Rush y Hush con Sirena Corrupta.",
        "Alma de la Sirena: encanta a los monstruos en la habitación por 10 segundos. Por los siguientes 60 segundos,",
        "gana 3 bebés familiares aleatorios, un Collar de la Amistad absorbido, y encanta a los monstruos por 10",
        "segundos al entrar a las habitaciones."
    },
    ["node_shadowmeld_name"] = "Shadowmeld",
    ["node_shadowmeld"] = {
        "Mientras estés en una habitación con monstruos, Manifest Melody se vuelve Shadowmeld.",
        "Shadowmeld crea una marca de sombra en tu posición actual.",
        "Usar Shadowmeld de vuelta te hunde en las sombras, y luego reapareces en la posición de la marca de sombra.",
        "Mientras te hundes o reapareces, y por 0.5 segundos después, no puedes recibir daño.",
        "Presiona la tecla de Tirar para quitar las marcas de sombra presentes."
    },
    ["node_darkarpeggio_name"] = "Arpegio Oscuro",
    ["node_darkarpeggio"] = {
        "Cada 4 segundos totales disparando, tus Minions de Sirena disparan lágrimas persecutoras que",
        "infligen miedo a los enemigos que dañen."
    },
    ["node_chromaticblessing_name"] = "Bendición Cromática",
    ["node_chromaticblessing"] = {
        "Al invocar un familiar con Manifest Melody, gana estadísticas basado en las notas usadas:",
        "  - Izquierda: +0.5% velocidad",
        "  - Derecha: +0.5% lágrimas",
        "  - Arriba: +0.5% daño",
        "  - Abajo: +0.5% rango y suerte",
        "Cada mejora individual tiene un límite total de 15%."
    },
    ["node_grandconsonance_name"] = "Gran Consonancia",
    ["node_grandconsonance"] = {
        "Cada vez que obtengas un familiar, en cambio absorbe su poder y gana un efecto único a ese familiar.",
        "-4% daño infligido a enemigos por cada familiar que obtengas que haga daño, hasta -48%."
    },
    ["node_songofthefew_name"] = "Canción de los Pocos",
    ["node_songofthefew"] = {
        "Comienza con Canción de Cuna Olvidada absorbida.",
        "Una vez que consigas por lo menos 2 familiares que hagan daño, 20% chance de perder una Canción de Cuna Olvidada",
        "cada vez que obtengas más familiares.",
        "Esta chance aumenta en 15% por cada familiar que obtengas por encima de 3."
    },
    ["node_chromaticdissonance_name"] = "Disonancia Cromática",
    ["node_chromaticdissonance"] = {
        "Cada vez que obtienes un objeto de familiar por primera vez, reemplazalo con un familiar aleatorio diferente",
        "de la misma calidad, si es posible.",
        "Una vez activado 10 veces este efecto, obtener un objeto de familiar quita otro objeto de familiar aleatorio diferente",
        "de la misma calidad que tengas."
    },

    ["node_fearedmobdmg_name"] = "Daño A Enemigos Asustados",
    ["node_fearedmobdmg"] = "Los enemigos asustados reciben {{fearedDmg}}% más daño.",
    ["node_fearedtearburst_name"] = "Estallido De Lágrimas Por Muerte De Asustados",
    ["node_fearedtearburst"] = {
        "{{fearedTearBurst}}% chance de que los enemigos asustados creen un estallido de 3-4 lágrimas persecutoras al morir,",
        "que causan miedo al dañar enemigos.",
        "Estas lágrimas infligen 4% de la vida del monstruo matado como daño, con un mínimo de 3 de daño."
    },
    ["node_acridgaze_name"] = "Mirada Agria",
    ["node_acridgaze"] = {
        "Cada 1.5 segundos totales disparando, crea un pulso que daña y asusta a enemigos cercanos por 2 segundos.",
        "El daño infligido por este pulso es 120% de tu estadística de suerte, hasta 10.",
        "+{{acridGaze}}% tamaño del pulso."
    },
    ["node_sirenminiondmg_name"] = "Daño Del Minion De Sirena",
    ["node_sirenminiondmg"] = "{{sirenMinionDmg}}% más daño infligido por tus Minions de Sirena.",
    ["node_darkarpeggiodelay_name"] = "Retraso De Lágrimas De Arpegio Oscuro",
    ["node_darkarpeggiodelay"] = "{{darkArpeggioTearDelay}} segundos totales requeridos para que tus Minions de Sirena disparen la lágrima de Arpegio Oscuro.",
    ["node_shadowmeldexplosion_name"] = "Explosión De Shadowmeld",
    ["node_shadowmeldexplosion"] = {
        "{{shadowmeldExplosion}}% chance de causar una explosión oscura al reaparecer con Shadowmeld, infligiendo 100% de",
        "tu daño a enemigos cercanos y asustándolos."
    },
    ["node_shadowmelddmg_name"] = "Daño De Explosión De Shadowmeld",
    ["node_shadowmelddmg"] = "La explosión de Shadowmeld inflige un {{shadowmeldExplosionDmg}}% adicional de tu daño.",
    ["node_fearedkillblackheart_name"] = "Corazón Negro Al Matar Asustados",
    ["node_fearedkillblackheart"] = {
        "{{blackHeartFearKill}}% chance de recibir 1/2 corazón negro al matar a un enemigo asustado, si tienes menos de",
        "3 corazones negros, hasta 2 veces por habitación."
    },
    ["node_fearedkill_luck_name"] = "Suerte Al Matar Asustados",
    ["node_fearedkill_luck"] = "{{fearedKillLuck}}% chance de ganar +0.02 suerte al matar a un enemigo asustado, hasta +3."
}