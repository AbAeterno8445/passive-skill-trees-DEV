return {
    ---- CHARACTER TREE NODE MODIFIERS ----
    ["node_crimsoncore_name"] = "Nodo Carmesí Nuclear",
    ["node_crimsoncore"] = {
        "Asigna para elegir cualquier nodo mediano del árbol del personaje actual.",
        "Mientras este asignado, gana los efectos del nodo elegido."
    },
    ["node_crimsonuniv_name"] = "Nodo Carmesí Universal",
    ["node_crimsonuniv"] = {
        "Asigna para elegir cualquier nodo mediano del árbol global.",
        "Mientras este asignado, gana los efectos del nodo elegido."
    },
    ["node_crimsondivergent_name"] = "Nodo Carmesí Divergente",
    ["node_crimsondivergent"] = {
        "Asigna para elegir cualquier nodo mediano de los arboles de otros personajes.",
        "Mientras este asignado, gana los efectos del nodo elegido."
    },

    -- ISAAC'S TREE --
    ["node_magicdie_name"] = "Dado Mágico",
    ["node_magicdie"] = {
        "Usar el D6 otorga un buff permanente de estadísticas. Las estadísticas dependen del tipo de habitación",
        "en la que se use el D6:",
        "- Ángel: +7% velocidad y lágrimas",
        "- Diablo: +6% daño y rango",
        "- Tesoro y Tienda: +7% velocidad de disparo y suerte",
        "- Jefe: si ya tienes un buff, éste se aumenta un +3%. Si no, otorga +3% a todas las estadísticas",
        "- Cualquier otra habitación: +2% a todas las estadísticas",
        "Solo puedes tener uno de estos buffs a la vez. Usar el D6 en una habitación distinta reemplaza las",
        "estadísticas ganadas.",
    },
    ["node_intermittentconceptions_name"] = "Concepciones Intermitentes",
    ["node_intermittentconceptions"] = {
        "Comienza la partida con Primogenitura.",
        "Cuando entras a una habitación con pedestales de objetos la primera vez, pierdes Primogenitura.",
        "Luego de conseguir 2 objetos pasivos, recibe Primogenitura de vuelta.",
        "Éste efecto se repite."
    },
    ["node_isaacblessing_name"] = "Bendición de Isaac",
    ["node_isaacblessing"] = {
        "Comienza la partida con +{{isaacBlessing}}% a todas las estadísticas.",
        "Reiniciar la partida remueve éste efecto.",
        "Derrotar al Corazón de Mama reactiva éste efecto para la próxima partida."
    },
    ["node_boonoftheordinary_name"] = "Don del Ordinario",
    ["node_boonoftheordinary"] = {
        "Mientras tengas por lo menos 25 monedas, tu velocidad mínima se vuelve 1.33.",
        "Mientras tengas por lo menos 12 bombas, tus ataques ganan 10% chance de infligir doble daño.",
        "Mientras tengas por lo menos 12 llaves, gana Gotas para los ojos.",
        "Gotas para los ojos ya no puede aparecer naturalmente."
    },

    ["node_allstats_name"] = "Aumento De Estadísticas",
    ["node_allstats"] = "+{{allstats}} a todas las estadísticas.",
    ["node_allstatchance_name"] = "Chance de Estadísticas Al Entrar",
    ["node_allstatchance"] = "Al entrar a una habitación con monstruos, {{allstatsRoom}}% chance de ganar +4% a todas las estadísticas para la habitación actual.",
    ["node_allstatbirthright_name"] = "Estadísticas - Primogenitura",
    ["node_allstatbirthright"] = "+{{allstatsBirthright}} a todas las estadísticas mientras tengas Primogenitura.",
    ["node_dicepickups_name"] = "Recolectables Al Usar Dados",
    ["node_dicepickups"] = "{{d6Pickup}}% chance al usar cualquier dado de crear un recolectable aleatorio (moneda, bomba, llave o corazón).",
    ["node_dicecharge_name"] = "Cargas Para Dados",
    ["node_dicecharge"] = "{{d6HalfCharge}}% chance al usar cualquier dado de mantener la mitad de su carga activa.",
    ["node_chestreclose_name"] = "Re-encerradura De Cofres",
    ["node_chestreclose"] = "{{chestReclose}}% chance de volver a cerrar cualquier cofre 1 segundo después de abierto.",
    ["node_pickupdupe_name"] = "Duplicación De Recolectables",
    ["node_pickupdupe"] = "{{pickupDupe}}% chance de duplicar monedas/llaves/bombas que aparezcan.",
    ["node_pickupboons_name"] = "Don De Recolectables",
    ["node_pickupboons"] = {
        "Para el piso actual:",
        "  +{{pickupBoons}}% daño por bomba colectada, hasta 10%.",
        "  +{{pickupBoons}}% lágrimas por llave colectada, hasta 10%.",
        "  +{{pickupBoons}}% velocidad por moneda colectada, hasta 10%."
    },


    -- MAGDALENE'S TREE
    ["node_magdaleneblessing_name"] = "Bendición De Magdalena",
    ["node_magdaleneblessing"] = {
        "+{{speed}} velocidad.",
        "{{damage}} daño.",
        "-0.02 velocidad y +0.2 daño por cada contenedor de corazón rojo que tengas después del cuarto."
    },
    ["node_crystalheart_name"] = "Corazón Cristalino",
    ["node_crystalheart"] = {
        "Delicioso Corazón recupera 1/2 corazón adicional.",
        "7% chance al usar Delicioso Corazón de convertir un corazón rojo a un corazón de hueso."
    },
    ["node_blood_donor_name"] = "Donadora Sanguínea",
    ["node_blood_donor"] = {
        "Las Máquinas de Donación de Sangre otorgan 1 carga a tus objetos activos al usarse.",
        "Si posees Delicioso Corazón, éste tiene 50% chance de ganar 2 cargas en vez de 1."
    },
    ["node_blesserheart_name"] = "Corazón Bendito",
    ["node_blesserheart"] = {
        "Usar Delicioso Corazón mientras tienes la vida llena otorga Bendición de Corazones a",
        "hasta 3 cofres en la habitación."
    },
    ["node_innerglow_name"] = "Iluminación Interna",
    ["node_innerglow"] = "Al usar un objeto activo con por lo menos 3 cargas, 33% chance de adicionalmente activar el efecto de Delicioso Corazón",

    ["node_yumheartheal_name"] = "Curación De Delicioso Corazón",
    ["node_yumheartheal"] = "{{yumHeartHealHalf}}% chance de recuperar 1/2 corazón adicional al usar Delicioso Corazón.",
    ["node_bloodmachinespawn_name"] = "Aparición De Máquinas De Donación De Sangre",
    ["node_bloodmachinespawn"] = {
        "{{bloodMachineSpawn}}% chance de hacer aparecer una Máquina de Donación de Sangre al comienzo de un piso.",
        "No se aplica al primer piso."
    },
    ["node_blooddonoluck_name"] = "Suerte Por Máquinas De Donación De Sangre",
    ["node_blooddono"] = {
        "+{{bloodDonationLuck}} suerte al usar una Máquina de Donación de Sangre.",
        "Reduce éste bonus a la mitad al entrar al siguiente piso."
    },
    ["node_blooddononickel_name"] = "Níquel Al Donar Sangre",
    ["node_blooddononickel"] = "{{bloodDonationNickel}}% chance de crear un níquel adicional al donar sangre.",
    ["node_roomclearheal_name"] = "Curación Al Completar Habitación",
    ["node_roomclearheal"] = {
        "{{healOnClear}}% chance de curar 1/2 corazón al completar una habitación.",
        "Duplica la chance y curación en habitaciones del jefe."
    },
    ["node_heartblessedchests_name"] = "Cofres Con Bendición De Corazones",
    ["node_heartblessedchests"] = {
        "+{{heartblessedChests}}% chance de otorgar Bendición de Corazones a los cofres que aparezcan.",
        "Los cofres con Bendición de Corazones pueden contener 1-2 corazones aleatorios adicionales.",
        "Éstos corazones tienen un 70% chance de ser rojos."
    },
    ["node_heartblessedspeed_name"] = "Cofres Bendecidos: Velocidad",
    ["node_heartblessedspeed"] = "+{{heartblessedSpeed}}% velocidad para la habitación actual al abrir un cofre con Bendicion de Corazones, hasta 12%.",
    ["node_fullhpcharging_name"] = "Carga Con Vida Llena",
    ["node_fullhpcharging"] = {
        "Al usar un objeto activo, {{fullHealthCharge}}% chance to mantener 1 carga por cada contenedor de corazón rojo",
        "si tienes la vida llena."
    },
    ["node_allstatfullhp_name"] = "Estadísticas Con Vida Llena",
    ["node_allstatfullhp"] = {
        "+{{allstatsFullRed}} a todas las estadísticas si tienes por lo menos 1 contenedor de corazón rojo y tienes",
        "la vida llena."
    },


    -- CAIN'S TREE --
    ["node_impromptugambler_name"] = "Improvisación Ludopática",
    ["node_impromptugambler"] = {
        "Crea un Juego de Grúa en las habitaciones del tesoro. Éstos pueden contener objetos de las habitaciones",
        "del tesoro, ángel, diablo o tienda, y quitan 2 monedas adicionales al usarse.",
        "Interactuar con el Juego de Grúa quita el objeto regular de la habitación del tesoro.",
        "En cambio, conseguir el objeto regular quita el Juego de Grúa."
    },
    ["node_thievery_name"] = "Robo",
    ["node_thievery"] = {
        "+{{stealChance}}% chance de robar objetos de la tienda en vez de comprarlos.",
        "Al robar objetos, Codicia tendra una chance de aparecer luego de derrotar al jefe del piso.",
        "Cada objeto robado aumenta ésta chance basado en su precio (precio * 3)%."
    },
    ["node_ficklefortune_name"] = "Fortuna Frágil",
    ["node_ficklefortune"] = {
        "+7% suerte mientras tengas un trinket.",
        "Tu suerte mínima es 1 mientras tengas un trinket.",
        "7% chance al recibir daño de arrojar tu trinket.",
        "Los trinkets arrojados tienen 7% chance de desaparecer."
    },
    ["node_goldengimmick_name"] = "Truco Dorado",
    ["node_goldengimmick"] = {
        "Al entrar a un piso, 15% chance de crear una Máquina Dorada aleatoria, hasta 2 veces por partida.",
        "Cada 4 usos de una Máquina Dorada consume una moneda adicional y otorga +2% daño para el piso actual,",
        "hasta 12%."
    },
    ["node_wealthsmith_name"] = "Forjador de Riquezas",
    ["node_wealthsmith"] = {
        "Mientras tengas por lo menos 20 monedas y menos de 10 llaves, gana Pay to Play.",
        "+0.2% lágrimas por diferencia entre monedas y llaves, hasta 15%.",
        "Pay to Play ya no puede aparecer naturalmente."
    },

    ["node_stealchance_name"] = "Chance De Robo",
    ["node_stealchance"] = "+{{stealChance}}% chance de robar objetos de la tienda en vez de comprarlos.",
    ["node_randtrinketonclear_name"] = "Trinket Aleatorio Al Completar",
    ["node_randtrinketonclear"] = "{{trinketOnClear}}% chance de crear un trinket aleatorio al completar una habitación, si no tienes ninguno.",
    ["node_freemachine_name"] = "Uso De Máquina Gratis",
    ["node_freemachine"] = "{{freeMachinesChance}}% chance para las máquinas que usen monedas de costar nada al usarse.",
    ["node_arcadereveal_name"] = "Revelación De Arcade",
    ["node_arcadereveal"] = "{{arcadeReveal}}% chance de revelar el Arcade en el mapa si está presente en el piso.",
    ["node_shopreveal_name"] = "Revelación De Tienda",
    ["node_shopreveal"] = "{{shopReveal}}% chance de revelar la Tienda en el mapa si está presente en el piso.",
    ["node_roomclearnickel_name"] = "Níquel Al Completar",
    ["node_roomclearnickel"] = {
        "{{nickelOnClear}}% chance de crear un níquel adicional al completar una habitación.",
        "Duplica la chance en habitaciones del jefe."
    },
    ["node_gildedmachines_name"] = "Máquinas Doradas",
    ["node_gildedmachines"] = {
        "2% chance de volver doradas a las máquinas que cuesten monedas, al encontrarlas por primera vez.",
        "Las Máquinas Doradas tienen un 50% chance de ser gratis y otorgan +0.5% suerte para el piso actual",
        "al usarse."
    },


    -- JUDAS' TREE --
    ["node_darkheart_name"] = "Corazón Oscuro",
    ["node_darkheart"] = {
        "Comienza con un corazón negro adicional.",
        "Los corazones de alma ahora cuentan también como corazones oscuros para otros efectos.",
        "-6% daño y velocidad mientras no tengas corazones oscuros.",
        "El Libro de Belial quita esta reducción para la habitación actual al usarse."
    },
    ["node_innerdemon_name"] = "Demonio Interno",
    ["node_innerdemon"] = {
        "Comienza con Sombra de Judas.",
        "-45% daño con Dark Judas."
    },
    ["node_sacrificedarkness_name"] = "Oscuridad Sacrificada",
    ["node_sacrificedarkness"] = {
        "Al agarrar un corazón negro, actívalo y recibe un corazón de alma.",
        "+1% a todas las estadísticas por corazón negro sacrificado, hasta 6%, reiniciandose por piso.",
        "35% chance de convertir corazones de almas encontrados a corazones negros."
    },
    ["node_tenetofbelial_name"] = "Principio de Belial",
    ["node_tenetofbelial"] = {
        "Usar un objeto activo con por lo menos 4 cargas adicionalmente activa el efecto de Libro de Belial.",
        "Luego de activar éste efecto 15 veces, se vuelve inactivo y ganas Primogenitura, si no la tienes.",
        "Activar el efecto de Libro de Belial tiene un 50% chance de quitar sobrecargas de los objetos activos.",
        "Primogenitura ya no puede aparecer naturalmente."
    },
    ["node_darkapotheosis_name"] = "Apoteosis Oscura",
    ["node_darkapotheosis"] = {
        "Usar el Libro de Belial te convierte a Dark Judas por la habitación actual.",
        "Cuando se activa éste efecto, los contenedores de corazones rojos se convierten a corazones negros.",
        "Sombra de Judas ya no puede aparecer naturalmente."
    },

    ["node_darkjudas_speed_name"] = "Velocidad Con Dark Judas",
    ["node_darkjudas_speed"] = "+{{darkJudasSpeed}}% velocidad con Dark Judas.",
    ["node_darkjudas_shotspdrange_name"] = "Velocidad De Disparo Y Rango Con Dark Judas",
    ["node_darkjudas_shotspdrange"] = "+{{darkJudasShotspeedRange}}% velocidad de disparo y rango con Dark Judas.",
    ["node_darkcharges_name"] = "Cargas Oscuras",
    ["node_darkcharges"] = {
        "{{belialBossHitCharge}}% chance de ganar una carga con objetos activos al dañar a un jefe mientras tengas corazones",
        "oscuros. Genera hasta 12 cargas por habitación."
    },
    ["node_luckyblackhearts_name"] = "Corazones Negros Al Matar",
    ["node_luckyblackhearts"] = {
        "Los monstruos con por lo menos 50 HP tienen {{blackHeartLuckDrop}}% chance por cada 0.5 suerte de arrojar",
        "un corazón negro al morir.",
        "Si tienes por lo menos 5 suerte, reduce el HP necesario a 30.",
        "Éste efecto puede activarse hasta 3 veces por piso."
    },
    ["node_blackheartconv_name"] = "Conversión De Corazones Negros",
    ["node_blackheartconv"] = "{{node_blackheartconv}}% chance de reemplazar cualquier corazón encontrado con corazones negros.",


    -- BLUE BABY'S TREE --
    ["node_bluegambit_name"] = "Gambito Azul",
    ["node_bluegambit"] = {
        "La primera carta que encuentres garantiza ser V - El Hierofante.",
        "La primera píldora que encuentres garantiza ser Bolas de Acero.",
        "20% chance de recibir 1/2 corazón de daño al usar cartas o píldoras que no sean las nombradas arriba.",
        "Las cartas reversas no activan éste efecto de daño."
    },
    ["node_brownblessing_name"] = "Bendición Marrón",
    ["node_brownblessing"] = {
        "Comienza con Popó Petrificado.",
        "Usar Popó tiene un 7% chance de crear un objeto de popó. Ésto no se aplica en el primer piso."
    },
    ["node_slippingessence_name"] = "Esencia Desvaneciente",
    ["node_slippingessence"] = {
        "Perder un corazón de alma tiene un 40% chance de crear un corazón de alma entero.",
        "Al activarse éste efecto, reduce la chance a la mitad y recibe -0.6 suerte."
    },
    ["node_beandiet_name"] = "Dieta de Frijoles",
    ["node_beandiet"] = {
        "Comienza con un Frijol Gigante absorbido.",
        "Al usar Popó, adicionalmente activa el efecto de algún frijol activo aleatorio."
    },

    ["node_souloncardpill_name"] = "Corazón De Alma Con Píldoras/Cartas",
    ["node_souloncardpill"] = "{{soulOnCardPill}}% chance de recibir 1/2 corazón de alma al usar una píldora/carta.",
    ["node_poopitemluck_name"] = "Suerte Con Objetos Popó",
    ["node_poopitemluck"] = "+{{poopItemLuck}} suerte por objeto popó que tengas.",
    ["node_pooptrinketluck_name"] = "Suerte Con Trinkets Popó",
    ["node_pooptrinketluck"] = "+{{poopTrinketLuck}} suerte mientras tengas un trinket popó.",
    ["node_poopallstats_name"] = "Estadísticas Al Usar Popó",
    ["node_poopallstats"] = {
        "+{{thePoopAllStats}} a todas las estadísticas al usar Popó, una vez por habitación.",
        "Se reinicia en cada habitación."
    },
    ["node_soultearsrange_name"] = "Lágrimas Y Rango Con Corazones De Alma",
    ["node_soultearsrange"] = {
        "+{{soulHeartTearsRange}}% lágrimas y rango cuando consigues corazones de alma, hasta 10%.",
        "Se reinicia en cada piso."
    },
    ["node_cardpillpoop_name"] = "Popó Al Usar Píldora/Carta",
    ["node_cardpillpoop"] = "{{cardPillPoop}}% chance de activar el efecto de Popó al usar una píldora/carta.",
    ["node_beanspeedbuff_name"] = "Velocidad Al Usar Frijol",
    ["node_beanspeedbuff"] = "+{{beanActiveSpeed}}% velocidad por 5 segundos luego de usar cualquier frijol activo.",


    -- EVE'S TREE --
    ["node_heartless_name"] = "Descorazonada",
    ["node_heartless"] = {
        "Cada habitación que completes otorga +0.5% a todas las estadísticas, hasta 10%.",
        "Agarrar cualquier corazón reduce éste bonus a la mitad."
    },
    ["node_darkprotection_name"] = "Protección Oscura",
    ["node_darkprotection"] = {
        "Al llegar a 1 corazón o menos de vida por primera vez, gana un corazón negro.",
        "El efecto se reinicia al derrotar al Corazón de Mama."
    },
    ["node_carrionavian_name"] = "Ave Carroñera",
    ["node_carrionavian"] = {
        "+0.15 daño cuando ave muerta mata a un enemigo, hasta +3, reiniciandose en cada piso.",
        "Si ave muerta mata a un jefe, gana +0.6 daño permanente (hasta +1.2 por habitación)."
    },
    ["node_phantomcrows_name"] = "Cuervos Fantasma",
    ["node_phantomcrows"] = {
        "Comienza con Pata del Ave de Eva absorbida.",
        "0.5% chance de crear un ave muerta fantasmal adicional para la habitación actual cada vez",
        "que un ave muerta inflige daño, una vez por habitación."
    },

    ["node_deadbirdshield_name"] = "Escudo De Ave Muerta",
    ["node_deadbirdshield"] = "{{deadBirdNullify}}% chance de nulificar el daño recibido que despierte a la ave muerta.",
    ["node_deadbird_dmg_name"] = "Daño Con Ave Muerta",
    ["node_deadbird_dmg"] = "+{{activeDeadBirdDamage}} daño mientras la ave muerta esté activa.",
    ["node_deadbird_speed_name"] = "Velocidad Con Ave Muerta",
    ["node_deadbird_speed"] = "+{{activeDeadBirdSpeed}} velocidad mientras la ave muerta esté activa.",
    ["node_deadbird_tears_name"] = "Lágrimas Con Ave Muerta",
    ["node_deadbird_tears"] = "+{{activeDeadBirdTears}} lágrimas mientras la ave muerta esté activa.",
    ["node_deadbird_range_name"] = "Rango Con Ave Muerta",
    ["node_deadbird_range"] = "+{{activeDeadBirdRange}} rango mientras la ave muerta esté activa.",
    ["node_deadbird_shotspeed_name"] = "Velocidad De Disparo Con Ave Muerta",
    ["node_deadbird_shotspeed"] = "+{{activeDeadBirdShotspeed}} velocidad de disparo mientras la ave muerta esté activa.",
    ["node_deadbird_famdmg_name"] = "Daño Del Ave Muerta",
    ["node_deadbird_famdmg"] = "La ave muerta adicionalmente inflige un {{deadBirdInheritDamage}}% de tu daño por golpe.",
    ["node_roomclearluck_belowfull_name"] = "Suerte Al Completar Con Vida Faltante",
    ["node_roomclearluck_belowfull"] = {
        "+{{luckOnClearBelowFull}} suerte al completar una habitación con corazones rojos faltantes.",
        "El bonus se reinicia en cada piso."
    },
    ["node_allstatoneheart_name"] = "Estadísticas Con Un Corazón",
    ["node_allstatoneheart"] = "+{{allstatsOneRed}} a todas las estadísticas mientras tengas solo un corazón.",
    ["node_evemascarachamp_name"] = "Rímel De Eva Al Matar Campeón",
    ["node_evemascarachamp"] = "{{eveMascaraChamp}}% chance de obtener Rímel de Eva por la habitación actual al matar a un campeón.",


    -- SAMSON'S TREE --
    ["node_hasted_name"] = "Apresurado",
    ["node_hasted"] = {
        "+10% lágrimas y velocidad de disparo.",
        "Recibir daño reduce este bonus por 1.5%, hasta 5 veces.",
        "El efecto se reinicia en cada piso."
    },
    ["node_ragebuildup_name"] = "Furia Acumulada",
    ["node_ragebuildup"] = {
        "+0.02 daño al atacar a un enemigo, hasta +3.",
        "Recibir daño reinicia el bonus."
    },
    ["node_hearty_name"] = "Fortitud",
    ["node_hearty"] = {
        "Comienza con un corazón rojo adicional.",
        "+1.5% daño por cada 1/2 corazón rojo faltante."
    },
    ["node_bloodcrowned_name"] = "Coronación Sanguínea",
    ["node_bloodcrowned"] = {
        "Comienza con Corona Sangrienta absorbida.",
        "Al entrar a un nuevo piso, 2% chance de perder Corona Sangrienta por cada 1/2 corazón rojo faltante.",
        "Entrar a un piso del capítulo 4 con vida llena y la Corona Sangrienta hace aparecer una Corona del Diablo."
    },

    ["node_samsontempdmg_name"] = "Daño Temporal",
    ["node_samsontempdmg"] = {
        "+{{samsonTempDamage}}% daño por 2.5 segundos luego de matar a un enemigo, o golpear a un jefe 8 veces.",
        "El efecto no se acumula."
    },
    ["node_samsontempspeed_name"] = "Velocidad Temporal",
    ["node_samsontempspeed"] = {
        "+{{samsonTempSpeed}}% velocidad por 2.5 segundos luego de matar a un enemigo, o golpear a un jefe 8 veces.",
        "El efecto no se acumula."
    },
    ["node_speedwhenhit_name"] = "Velocidad Al Recibir Daño",
    ["node_speedwhenhit"] = "+{{speedWhenHit}}% velocidad al recibir daño, hasta 15%, reiniciandose en cada habitación.",
    ["node_bossculling_name"] = "Ejecución De Jefes",
    ["node_bossculling"] = "{{bossCulling}}% chance al golpear a un jefe de infligir 10x daño si éste tiene menos de 10% HP.",
    ["node_quickbossluck_name"] = "Suerte Al Matar Jefe Rápidamente",
    ["node_quickbossluck"] = {
        "+{{bossQuickKillLuck}} suerte si completas la habitación del jefe dentro de 30 segundos despues de entrar,",
        "hasta +3."
    },
    ["node_bossflawlessluck_name"] = "Suerte Al Matar Jefe Sin Golpes",
    ["node_bossflawlessluck"] = "+{{bossFlawlessLuck}} suerte si completas la habitación del jefe sin ser golpeado, hasta +3.",
    ["node_treasuredoubleheart_name"] = "Doble Corazón Rojo En Habitaciones Del Tesoro",
    ["node_treasuredoubleheart"] = {
        "{{treasureDoubleHeart}}% chance de que las habitaciones del tesoro adicionalmente contengan un doble",
        "corazón rojo."
    },


    -- AZAZEL'S TREE --
    ["node_bloodcharge_name"] = "Carga Sanguínea",
    ["node_bloodcharge"] = {
        "+{{range}} rango.",
        "{{tearsPerc}}% lágrimas."
    },
    ["node_demonicsouvenirs_name"] = "Souvenirs Demoníacos",
    ["node_demonicsouvenirs"] = {
        "Crea III - La Emperatriz cada dos pisos, comenzando con el primero.",
        "Crea un trinket demoníaco aleatorio en el comienzo del segundo piso al que entres.",
        "+6% daño y lágrimas mientras tengas un trinket demoníaco."
    },
    ["node_demonhelpers_name"] = "Demonios Ayudantes",
    ["node_demonhelpers"] = {
        "{{devilBeggarBlackHeart}}% chance de recibir 1/2 corazón negro al ayudar a un mendigo demoníaco.",
        "Cuando un mendigo demoníaco otorga una recompensa, 33% chance de crear un familiar demoníaco.",
        "5% chance de crear un mendigo demoníaco en el comienzo de un piso, comenzando desde el segundo piso.",
        "Ésta chance se duplica en cada piso hasta 40%, y se reinicia cuando uno aparece."
    },
    ["node_demonicambition_name"] = "Ambición Demoníaca",
    ["node_demonicambition"] = {
        "Obten Cabeza de Cabra mientras tengas 4 corazones negros o más.",
        "Cabeza de Cabra ya no puede aparecer naturalmente."
    },
    ["node_earlybird_name"] = "Madrugador",
    ["node_earlybird"] = {
        "Comienza con un corazón negro adicional.",
        "Al dejar el primer piso, pierde un corazón negro/de alma si tienes más de 1 contenedor de corazones total."
    },

    ["node_blackheartdeals_name"] = "Corazones Negros Por Tratos",
    ["node_blackheartdeals"] = "{{blackHeartOnDeals}}% chance de conseguir un corazón negro al gastar corazones por objetos (e.g. tratos con el diablo).",
    ["node_eviltrinketluck_name"] = "Suerte Con Trinket Demoníaco",
    ["node_eviltrinketluck"] = "+{{evilTrinketLuck}} suerte mientras tengas un trinket demoníaco.",
    ["node_freedevilbeggar_name"] = "Mendigo Demoníaco Asistente",
    ["node_freedevilbeggar"] = "{{devilBeggarBlackHeart}}% chance de recibir 1/2 corazón negro al ayudar a un mendigo demoníaco.",
    ["node_cardusedmg_name"] = "Daño Al Usar Cartas",
    ["node_cardusedmg"] = "+{{cardFloorDamage}} daño al usar una carta, hasta +3, reiniciandose en cada piso.",
    ["node_cardusetears_name"] = "Lágrimas Al Usar Cartas",
    ["node_cardusetears"] = "+{{cardFloorTears}} lágrimas al usar una carta, hasta +3, reiniciandose en cada piso",


    -- LAZARUS' TREE --
    ["node_soulfulawakening_name"] = "Despertar Espiritual",
    ["node_soulfulawakening"] = {
        "Crea un corazón de alma al morir.",
        "+2 suerte.",
        "-0.5 suerte al morir."
    },
    ["node_kingcurse_name"] = "Maldición Del Rey",
    ["node_kingcurse"] = {
        "Comienza con Damocles activado.",
        "Al entrar a un piso nuevo, quita Damocles si lo tienes, o lo re-añade si no.",
        "-10% a todas las estadísticas mientras no seas Lazarus Risen.",
        "-1 suerte mientras no seas Lazarus Risen."
    },
    ["node_trueending_name"] = "Un Final Verdadero?",
    ["node_trueending"] = {
        "El jefe del primer piso, Mama y el Corazón de Mama crean la carta Rey Suicida al morir.",
        "+2% a todas las estadísticas con Lazarus Risen por cada carta Rey Suicida usada."
    },
    ["node_growingcontrition_name"] = "Arrepentimiento Creciente",
    ["node_growingcontrition"] = {
        "Comienza con Primogenitura.",
        "Pierde Primogenitura al morir 3 veces.",
        "Si no tienes Primogenitura, completar una habitación del jefe sin recibir daño tiene un 10% chance",
        "de otorgar Primogenitura.",
        "Primogenitura ya no puede aparecer naturalmente."
    },

    ["node_lazdmg_name"] = "Daño De Lázaro",
    ["node_lazdmg"] = "+{{lazarusDamage}} daño. Recibe la mitad de éste bonus con Lazarus Risen.",
    ["node_laztears_name"] = "Lágrimas De Lázaro",
    ["node_laztears"] = "+{{lazarusTears}} lágrimas. Recibe la mitad de éste bonus con Lazarus Risen.",
    ["node_lazrange_name"] = "Rango De Lázaro",
    ["node_lazrange"] = "+{{lazarusRange}} rango. Recibe la mitad de éste bonus con Lazarus Risen.",
    ["node_lazspeed_name"] = "Velocidad De Lázaro",
    ["node_lazspeed"] = "+{{lazarusSpeed}} velocidad. Recibe la mitad de éste bonus con Lazarus Risen.",
    ["node_lazluck_name"] = "Suerte De Lázaro",
    ["node_lazluck"] = "+{{lazarusLuck}} suerte. Recibe la mitad de éste bonus con Lazarus Risen.",
    ["node_luckyallstat_name"] = "Estadísticas Afortunadas",
    ["node_luckyallstat"] = "+{{luckyAllStats}} a todas las estadísticas mientras tu suerte sea positiva.",
    ["node_planc_name"] = "Plan C",
    ["node_planc"] = "{{momPlanC}}% chance de crear Plan C al derrotar a Mama.",
    ["node_lazclearhearts_name"] = "Corazones Con Lázaro Al Completar",
    ["node_lazclearhearts"] = {
        "{{lazarusClearHearts}}% chance de crear 1/2 corazón rojo adicional al completar una habitación con Lázaro.",
        "{{lazarusClearHearts}}% chance de crear 1/2 corazón de alma adicional al completar una habitación con Lazarus Risen.",
    },


    -- EDEN'S TREE --
    ["node_chaotictreasury_name"] = "Tesorería Caótica",
    ["node_chaotictreasury"] = {
        "La habitación del tesoro del primer piso contiene un pedestal adicional con Caos.",
        "Mientras tengas Caos, las habitaciones del tesoro crean un objeto adicional.",
        "Agarrar un objeto en una habitación del tesoro quita todos los demás pedestales en la habitación."
    },
    ["node_sporadicgrowth_name"] = "Crecimiento Esporádico",
    ["node_sporadicgrowth"] = {
        "Comienza con Jeringa Rota absorbida.",
        "Al comenzar una partida, aplica +1% a una estadística aleatoria 6 veces.",
        "Al entrar a un piso más allá del primero, aplica +1% a una estadística aleatoria 2 veces."
    },
    ["node_starblessed_name"] = "Bendición Estelar",
    ["node_starblessed"] = {
        "Comienza con un objeto pasivo aleatorio adicional de la habitación del tesoro.",
        "El jefe del primer piso adicionalmente crea XVII - Las Estrellas al morir."
    },
    ["node_edenhairdo_name"] = "Peinado De Eden",
    ["node_edenhairdo"] = {
        "Una vez asignado, presiona Asignar para elegir un peinado para Eden.",
        "El peinado elegido permanece siempre activo.",
        "No cuesta SP."
    },
    ["node_spaghettification_name"] = "Espaguetificación",
    ["node_spaghettification"] = {
        "Comienza con Billete de 3 Dólares, el cual se pierde cuando recibas daño.",
        "Al recibir daño:",
        "   - Por 5 segundos, obten el efecto de Pastel de Frutas.",
        "   - Luego, por 5 segundos, obten el efecto de Galleta de Plastilina.",
        "20% chance de activar éste efecto al completar una habitación sin recibir daño."
    },
    ["node_clayshaping_name"] = "Moldeador De Arcilla",
    ["node_clayshaping"] = "Comienza con Arcilla de Modelar absorbida.",

    ["node_treasurechaoticepi_name"] = "Epifanía Caótica En Tienda/Tesoro",
    ["node_treasurechaoticepi"] = {
        "{{treasureItemCEpiphany}}% chance de activar Epifanía Caótica al conseguir un objeto de la habitación del tesoro o",
        "la tienda por primera vez."
    },
    ["node_specialitemchaoticepi_name"] = "Epifanía Caótica Con Objetos Especiales",
    ["node_specialitemchaoticepi"] = "{{devilItemCEpiphany}}% chance de activar Epifanía Caótica al conseguir un objeto del diablo, ángel o habitación del jefe por primera vez",
    ["node_passiveitemluck_name"] = "Suerte De Objetos Pasivos",
    ["node_passiveitemluck"] = "-0.01 a +{{itemRandLuck}} suerte al conseguir cualquier objeto pasivo por primera vez.",
    ["node_passiveitemluck2"] = "-0.5% a +{{itemRandLuckPerc}}% suerte al conseguir cualquier objeto pasivo por primera vez.",
    ["node_trinketluck_name"] = "Suerte De Trinkets",
    ["node_trinketluck"] = "-0.01 a +{{trinketRandLuck}} suerte al conseguir cualquier trinket por primera vez.",
    ["node_randstartpickup_name"] = "Monedas/Llaves/Bombas Adicionales",
    ["node_randstartpickup"] = "{{startCoinKeyBomb}}% chance de comenzar con una moneda, llave o bomba adicional.",
    ["node_edenblessing_name"] = "Bendición De Eden",
    ["node_edenblessing"] = {
        "{{edenBlessingSpawn}}% chance de crear Bendición del Eden en el comienzo de un piso, comenzando desde el segundo.",
        "Éste efecto solo puede activarse una vez por partida."
    },
    ["node_myosotisonclear_name"] = "Myosotis Al Completar",
    ["node_myosotisonclear"] = {
        "{{myosotisOnClear}}% chance de obtener Myosotis absorbido al completar una habitación sin recibir daño, si",
        "no tienes uno.",
        "Pierde cualquier Myosotis absorbido luego de entrar a un nuevo piso."
    },
    ["node_cursechaoticepi_name"] = "Epifanía Caótica En Habitación Maldita",
    ["node_cursechaoticepi"] = {
        "{{curseRoomCEpiphany}}% chance de activar Epifanía Caótica al entrar a una habitación maldita.",
        "Epifanía Caótica:",
        "   - 25% chance de añadir +2-4% a una estadística aleatoria.",
        "   - 25% chance de crear una moneda/llave/bomba doble.",
        "   - 20% chance de crear un corazón aleatorio.",
        "   - 20% chance de crear un cofre regular.",
        "   - 10% chance de crear un cofre especial."
    },


    -- THE LOST'S TREE --
    ["node_spectraladvantage_name"] = "Ventaja Espectral",
    ["node_spectraladvantage"] = {
        "+2% daño y +0.15 suerte por cada corazón que hubieras conseguido de los objetos que obtengas, hasta",
        "un total de 40% daño y +3 suerte.",
        "Si obtienes Primogenitura, gana +8% lágrimas.",
        "No funciona con objetos activos que otorgan corazones."
    },
    ["node_sacredaegis_name"] = "Escudo Sagrado",
    ["node_sacredaegis"] = {
        "Desbloquea Manto Sagrado con El Perdido al asignar éste nodo.",
        "Manto Sagrado se regenera 7 segundos después de perderlo, una vez por habitación.",
        "-7% a todas las estadísticas al perder Manto Sagrado, hasta 2 veces, reiniciandose en cada habitación."
    },
    ["node_heartseekerphantasm_name"] = "Fantasma Cazacorazones",
    ["node_heartseekerphantasm"] = {
        "Corazones rojos y eternos encontrados son convertidos a corazones de alma.",
        "Agarrar un corazón de alma o negro otorga +0.1 suerte, hasta +3.",
        "+1% a todas las estadísticas cada 3 corazones recolectables conseguidos, hasta 20%."
    },
    ["node_vagrantsoul_name"] = "Alma Vagante",
    ["node_vagrantsoul"] = {
        "Comienza con El Alma.",
        "Al entrar a un piso, 10% chance de perder El Alma.",
        "El Alma ya no puede aparecer naturalmente."
    },

    ["node_killinghitneg_name"] = "Negación De Daño Terminante",
    ["node_killinghitneg"] = "{{killingHitNegation}}% chance de negar daño recibido si éste te hubiera matado.",
    ["node_inactivemantlestats_name"] = "Estadísticas Con Manto Sagrado Desactivado",
    ["node_inactivemantlestats"] = "+{{noHolyMantleAllStats}} a todas las estadísticas mientras Manto Sagrado esté inactivo.",
    ["node_soulheart_tears_name"] = "Lágrimas Por Corazones De Alma",
    ["node_soulheart_tears"] = "Los corazones de alma otorgan +{{soulHeartTears}} al agarrarse, hasta +1.",
    ["node_blackheart_dmg_name"] = "Daño Por Corazones Negros",
    ["node_blackheart_dmg"] = "Los corazones negros otorgan +{{blackHeartDamage}} al agarrarse, hasta +3.",
    ["node_eternald6charge_name"] = "Carga Del D6 Eterno",
    ["node_eternald6charge"] = "{{eternalD6Charge}}% chance de no consumir cargas al usar el D6 Eterno.",
    ["node_soulonclear_name"] = "Corazón De Alma Al Completar",
    ["node_soulonclear"] = {
        "{{soulHeartOnClear}}% chance de crear un corazón de alma adicional al completar una habitación sin recibir",
        "daño, hasta 4 veces por piso."
    },
    ["node_blessedpennyconv_name"] = "Moneda A Moneda Bendecida",
    ["node_blessedpennyconv"] = "{{pennyToBlessed}}% chance de convertir monedas encontradas a Moneda Bendecida si no tienes una, una vez por piso.",


    -- LILITH'S TREE --
    ["node_minionmaneuver_name"] = "Maniobras De Esbirros",
    ["node_minionmaneuver"] = {
        "+3% velocidad por familiar activo, hasta 15%.",
        "Usar el Cajón de Amigos duplica el bonus máximo de éste efecto para la habitación actual."
    },
    ["node_heavyfriends_name"] = "Amigos Pesados",
    ["node_heavyfriends"] = {
        "Comienza con Amigos X Siempre.",
        "{{speedPerc}}% velocidad.",
        "{{damagePerc}}% daño."
    },
    ["node_daemonarmy_name"] = "Ejército Demoníaco",
    ["node_daemonarmy"] = {
        "Comienza con un Íncubo adicional.",
        "Mama crea un Íncubo adicional al morir si no recibiste daño a lo largo de toda la partida hasta entonces.",
        "Bebes familiares que no sean Íncubo ya no pueden aparecer."
    },
    ["node_companionshipgravitas_name"] = "Gravitación Compañera",
    ["node_companionshipgravitas"] = "Comienza con un Collar de la Amistad absorbido.",

    ["node_famkillsoul_name"] = "Corazón De Alma Por Matanza Familiar",
    ["node_famkillsoul"] = "{{familiarKillSoulHeart}}% chance de que los enemigos matados por familiares tiren 1/2 corazón de alma adicional.",
    ["node_activefamluck_name"] = "Suerte Por Familiares Activos",
    ["node_activefamluck"] = "+{{activeFamiliarsLuck}} suerte por familiar activo.",
    ["node_incubusdmg_name"] = "Daño De Íncubo",
    ["node_incubusdmg"] = "+{{activeIncubusDamage}}% daño por íncubo activo.",
    ["node_incubustears_name"] = "Lágrimas De Íncubo",
    ["node_incubustears"] = "+{{activeIncubusTears}}% lágrimas por íncubo activo.",
    ["node_boxfriendcharge_name"] = "Carga Del Cajón De Amigos",
    ["node_boxfriendcharge"] = "{{boxOfFriendsCharge}}% chance de mantener 1 carga al usar el Cajón de Amigos.",
    ["node_boxfriendstats_name"] = "Estadísticas Por Cajón De Amigos",
    ["node_boxfriendstats"] = "+{{boxOfFriendsAllStats}} a todas las estadísticas al usar el Cajón de Amigos, reiniciandose cada habitación.",
    ["node_monstermanualclear_name"] = "Manual De Monstruos Al Completar",
    ["node_monstermanualclear"] = {
        "{{monsterManualOnClear}}% chance de activar el efecto del Manual de Monstruos al completar una habitación",
        "sin recibir daño a 7 segundos de entrar, hasta 3 veces por piso."
    },


    -- KEEPER'S TREE --
    ["node_keeperblessing_name"] = "Bendición De Keeper",
    ["node_keeperblessing"] = {
        "Curarse con monedas otorga 1 moneda, hasta 4 veces por habitación.",
        "20% chance al usar Moneda de Madera de crear una moneda adicional."
    },
    ["node_gulp_name"] = "Gulp!",
    ["node_gulp"] = {
        "Crea una Moneda Tragada cada dos pisos, comenzando en el primero.",
        "+1.5 suerte mientras tengas Moneda Tragada.",
        "30% chance de perder Moneda Tragada al recibir daño.",
        "Gana 1-4 monedas al perder la Moneda Tragada de ésta manera."
    },
    ["node_avidshopper_name"] = "Ávido Comprador",
    ["node_avidshopper"] = {
        "Comienza con Rebajas de Steam.",
        "Comienza con 5 monedas adicionales.",
        "Pierde 1-3 monedas al recibir daño, hasta 5 veces por piso."
    },
    ["node_bluekin_name"] = "Parentaje Azul",
    ["node_bluekin"] = {
        "Comienza con Infestación.",
        "Al recibir daño, 30% chance de obtener Miasis por la habitación actual."
    },

    ["node_coinshield_name"] = "Escudo De Monedas",
    ["node_coinshield"] = {
        "{{coinShield}}% chance de negar daño que te hubiera matado, si tienes mas de 0 monedas.",
        "Negar daño de ésta manera quita todas tus monedas y cargas de objetos activos."
    },
    ["node_purchaseluck_name"] = "Suerte Al Comprar",
    ["node_purchaseluck"] = {
        "+{{itemPurchaseLuck}} suerte al comprar un objeto.",
        "Al entrar a un piso, reduce el bonus actual por la mitad."
    },
    ["node_purchasekeepcoins_name"] = "Mantenimiento De Monedas Al Comprar",
    ["node_purchasekeepcoins"] = "{{purchaseKeepCoins}}% chance de mantener 1-3 monedas al comprar un objeto.",
    ["node_greedboss_name"] = "Codicia",
    ["node_greedboss"] = "{{firstBossGreed}}% chance de que Codicia aparezca luego de derrotar al jefe del primer piso.",
    ["node_greedlesshp_name"] = "Menos Salud Para Codicia",
    ["node_greedlesshp"] = "Codicia tiene {{greedLowerHealth}}% menos vida.",
    ["node_greedcoins_name"] = "Monedas Adicionales Para Codicia",
    ["node_greedcoins"] = {
        "{{greedNickelDrop}}% chance de que Codicia tire un níquel adicional al morir.",
        "{{greedDimeDrop}}% chance de que Codicia tire un dime adicional al morir."
    },
    ["node_blueflydeath_dmg_name"] = "Daño Por Moscas Azules",
    ["node_blueflydeath"] = "+{{blueFlyDeathDamage}} daño cada vez que muere una mosca azul, hasta +1.2, reiniciandose en cada piso.",


    -- APOLLYON'S TREE --
    ["node_apollyonblessing_name"] = "Bendición De Apollyon",
    ["node_apollyonblessing"] = {
        "40% chance de mantener la mitad de la carga al usar Vacío.",
        "Ya no puedes recibir Maldición del Ciego."
    },
    ["node_null_name"] = "Nulo",
    ["node_null"] = {
        "Al entrar a un piso, si Vacío no absorbio objetos activos, gana +5% a todas las estadísticas, hasta 15%.",
        "Si Vacío absorbio objetos activos, 50% de conseguir una carga extra al completar una habitación.",
        "-10% a todas las estadísticas mientras no tengas Vacío."
    },
    ["node_harbingerlocusts_name"] = "Presagio De Las Langostas",
    ["node_harbingerlocusts"] = {
        "Crea un trinket de langosta aleatorio en el segundo piso que entres.",
        "Crea un trinket de langosta aleatorio luego de derrotar a Mama.",
        "2% chance de que los campeones tiren un trinket de langosta aleatorio al morir, una vez por piso.",
        "Usar Vacío consume a todos los trinkets de langostas en la habitación, absorbiendolos."
    },
    ["node_reverseannihilation_name"] = "Aniquilación Reversa",
    ["node_reverseannihilation"] = "Al borrar a un monstruo, activa el efecto de Buscador de Amigos, hasta 3 veces por piso.",

    ["node_voidblueflies_name"] = "Moscas Azules Del Vacío",
    ["node_voidblueflies"] = "{{voidBlueFlies}}% chance de crear 4 moscas azules al usar Vacío.",
    ["node_voidbluespiders_name"] = "Arañas Azules Del Vacío",
    ["node_voidbluespiders"] = "{{voidBlueSpiders}}% chance de crear 3 arañas azules al usar Vacío.",
    ["node_voidannihilation_name"] = "Aniquilación Del Vacío",
    ["node_voidannihilation"] = "{{voidAnnihilation}}% chance matar a un enemigo no-jefe aleatorio en la habitación al usar Vacío.",
    ["node_eraserspawn_name"] = "Borrador",
    ["node_eraserspawn"] = "{{eraserSecondFloor}}% chance de que el segundo y el quinto piso contengan un Borrador adicional en sus habitaciones del tesoro.",
    ["node_locustsluck_name"] = "Suerte De Langostas",
    ["node_locustsluck"] = "+{{locustHeldLuck}} suerte mientras tengas una langosta. Consumir un trinket de langosta otorga +{{locustConsumedLuck}} suerte.",
    ["node_locustconquestboon_name"] = "Bendición De Conquista",
    ["node_locustconquestboon"] = "+{{locustConquestSpeed}}% velocidad por langosta de conquista que tengas, hasta 15%.",
    ["node_locustdeathboon"] = "Bendición De Muerte",
    ["node_locustdeath"] = "+{{deathLocustTears}}% lágrimas por langosta de muerte que tengas, hasta 15%.",
    ["node_locustfamineboon_name"] = "Bendición De Hambruna",
    ["node_locustfamineboon"] = "+{{famineLocustRangeShotspeed}}% rango y velocidad de disparo por langosta de hambruna que tengas, hasta 15%.",
    ["node_locustpestilence_boon"] = "Bendición De Pestilencia",
    ["node_locustpestilence"] = "+{{pestilenceLocustLuck}}% suerte por langosta de pestilencia que tengas, hasta 12%.",
    ["node_locustwarboon_name"] = "Bendición De Guerra",
    ["node_locustwarboon"] = "+{{warLocustDamage}}% daño por langosta de guerra que tengas, hasta 15%.",


    -- THE FORGOTTEN'S TREE --
    ["spiritful_prefix"] = "[Espiritual]",
    ["node_soulful_name"] = "Alma Contundente",
    ["node_soulful"] = {
        "Perder un corazón de hueso crea un corazón de alma.",
        "-0.25 suerte cuando pierdes un corazón de hueso."
    },
    ["node_innerflare_name"] = "Conflagración Interna",
    ["node_innerflare"] = {
        "El Alma hace 15% más daño contra enemigos ralentizados.",
        "Cambiar a El Alma ralentiza a los enemigos en la habitación por 2 segundos, una vez por habitación."
    },
    ["node_spiritbringer_name"] = "Espíritu Compañero",
    ["node_spiritbringer"] = {
        "Gana el efecto de Bombas Fantasma.",
        "Mientras El Alma este fuera, gana el efecto de Quinteto.",
        "[Espiritual] Solo puedes asignar 1 nodo Espiritual a la vez."
    },
    ["node_spirit_taker_name"] = "Espíritu Recaudador",
    ["node_spirit_taker"] = {
        "Gana el efecto de Vade Retro.",
        "Cambiar personajes activa Vade Retro.",
        "[Espiritual] Solo puedes asignar 1 nodo Espiritual a la vez."
    },
    ["node_spiritreaper_name"] = "Espíritu Segador",
    ["node_spiritreaper"] = {
        "Gana los efectos de Purgatorio y Alma Hambrienta.",
        "[Espiritual] Solo puedes asignar 1 nodo Espiritual a la vez."
    },
    ["node_spiritprotector_name"] = "Espíritu Protector",
    ["node_spiritprotector"] = {
        "Gana el efecto de Alma Perdida.",
        "Comienza con los trinkets Alma Perdida y Tu Alma absorbidos.",
        "[Espiritual] Solo puedes asignar 1 nodo Espiritual a la vez."
    },
    ["node_spiritgambler_name"] = "Espíritu Ludópata",
    ["node_spiritgambler"] = {
        "Al entrar a un piso, aplica un nodo espiritual aleatorio distinto a éste.",
        "[Espiritual] Solo puedes asignar 1 nodo Espiritual a la vez."
    },
    ["node_osteomancy_name"] = "Osteomancia",
    ["node_osteomancy"] = {
        "Al entrar a un piso, gana el efecto de un objeto de hueso aleatorio, si no lo tienes.",
        "Entrar a un nuevo piso reemplaza el objeto previo.",
        "Si no recibiste daño en el piso anterior, aplica 2 objetos de hueso en vez de 1.",
    },
    ["node_necromancy_name"] = "Nigromancia",
    ["node_necromancy"] = {
        "Comienza con Libro de los Muertos.",
        "Usar un objeto activo que no sea Libro de los Muertos tiene un 7% chance de activar el efecto de éste por carga usada.",
        "Mmientras tengas 3 o más corazones de hueso, tus monstruos aliados se vuelven immune a las explosiones."
    },

    ["node_boneitemdmg_name"] = "Daño Melé Por Objeto De Hueso",
    ["node_boneitemdmg"] = "+{{boneItemMelee}}% daño melé con El Olvidado por cada objeto de hueso obtenido.",
    ["node_innerflareslowdur_name"] = "Duración De Ralentización Para Conflagración Interna",
    ["node_innerflareslowdur"] = "+{{innerFlareSlowDuration}} segundos a la ralentización de Conflagración Interna.",
    ["node_forgbirthright_name"] = "Primogenitura Al Completar",
    ["node_forgbirthright"] = {
        "{{forgBirthright}}% chance de conseguir Primogenitura para el piso actual al completar una habitación sin",
        "recibir daño, a 7 segundos de entrar."
    },
    ["node_soulwispclear_name"] = "Fuego Fatuo Al Completar",
    ["node_soulwispclear"] = {
        "Mientras El Alma tenga por lo menos 4 corazones de alma, {{soulWispOnClear}}% chance de crear",
        "un fuego fatuo al completar habitaciones."
    },
    ["node_redtoboneconv_name"] = "Corazones Rojos A Hueso",
    ["node_redtoboneconv"] = {
        "{{redFullToBone}}% chance de convertir corazones enteros rojos encontrados a corazones de hueso si tienes 2 corazones",
        "de hueso o menos.",
        "Éste efecto solo puede activarse una vez por habitación."
    },
    ["node_treasureboneitem_name"] = "Objeto De Hueso En Habitación Del Tesoro",
    ["node_treasureboneitem"] = {
        "Al entrar a una habitación del tesoro, {{treasureBoneItem}}% chance de reemplazar el pedestal con un objeto de hueso",
        "aleatorio, hasta 2 veces por partida."
    },
    ["node_carrionprincessclear_name"] = "Princesa De La Carroña Al Completar",
    ["node_carrionprincessclear"] = {
        "Mientras El Olvidado tenga por lo menos 2 corazones de hueso, {{forgCarrionPrincess}}% chance de crear una Princesa de la",
        "Carroña aliada al completar habitaciones, hasta 4."
    },
    ["node_soultearswisp_name"] = "Lágrimas Por Fuegos Fatuos",
    ["node_soultearswisp"] = "+{{soulWispTears}}% lágrimas por fuego fatuo activo.",
    ["node_flawlessclearpbone_name"] = "Hueso Pulido Al Completar",
    ["node_flawlessclearpbone"] = {
        "{{flawlessClearPBone}}% chance de obtener un hueso pulido absorbido por el resto del piso al completar una habitación sin",
        "recibir daño.",
        "Al recibir daño, misma chance de perder un hueso pulido absorbido."
    },


    -- BETHANY'S TREE --
    ["node_willothewisp_name"] = "Fortaleza Fatua",
    ["node_willothewisp"] = {
        "Tus fuegos fatuos reciben 60% menos daño.",
        "+0.5 daño por la habitación actual cuando un fuego fatuo es destruído, hasta +2.5."
    },
    ["node_soultrickle_name"] = "Hilos de Alma",
    ["node_soultrickle"] = {
        "Obtener un corazón de alma o negro cura 1/2 corazón rojo.",
        "Mientras tengas la vida llena, 30% chance de convertir corazones rojos encontrados a corazones de alma.",
        "Los fuegos fatuos tienen 5% chance de crear 1/2 corazón de alma al recibir daño. Éste efecto solo",
        "puede ocurrir hasta 2 veces por habitación."
    },
    ["node_fatependulum_name"] = "Destino Pendular",
    ["node_fatependulum"] = {
        "Comienza con Metrónomo.",
        "{{chargeOnClear}}% chance al completar una habitación de recibir una carga activa adicional.",
        "{{soulChargeOnClear}}% chance al completar una habitación de recibir una carga de alma adicional.",
        "-50% a todas las estadísticas mientras no tengas Metrónomo."
    },
    ["node_chaoticwisps_name"] = "Fuegos Fatuos Caóticos",
    ["node_chaoticwisps"] = "Cada vez que un fuego fatuo es creado, 50% chance de convertirlo a un fuego fatuo de objeto aleatorio.",

    ["node_activeitemwisp_name"] = "Fuego Fatuo Por Objeto Activo",
    ["node_activeitemwisp"] = {
        "{{activeItemWisp}}% chance de generar un fuego fatuo regular adicional al usar un objeto activo con",
        "por lo menos 1 carga."
    },
    ["node_clearsoulcharge_name"] = "Carga De Alma Al Completar",
    ["node_clearsoulcharge"] = "{{soulChargeOnClear}}% chance de obtener una carga de alma al completar una habitación.",
    ["node_wispdestroyluck_name"] = "Suerte Por Fuego Fatuo Destruído",
    ["node_wispdestroyluck"] = "+{{wispDestroyedLuck}} suerte cuando un fuego fatuo es destruido, hasta +2.",
    ["node_wisporbitalboon_name"] = "Bendición Orbital De Fuegos Fatuos",
    ["node_wisporbitalboon"] = "Al entrar a un piso, +{{wispFloorBuff}}% a todas las estadísticas por cada fuego fatuo que tengas en órbita, hasta 15%.",
    ["node_redheartsoulcharge_name"] = "Carga De Alma Por Corazón Rojo",
    ["node_redheartsoulcharge"] = "{{redHeartsSoulCharge}}% chance de obtener una carga de alma al agarrar un corazón rojo.",


    -- JACOB & ESAU'S TREE --
    ["node_heartlink_name"] = "Corazón Enlazados",
    ["node_heartlink"] = {
        "Los aumentos de corazones rojos son aplicados a ambos hermanos.",
        "-1% daño, lágrimas y rango por cada 1/2 diferencia de corazones rojos entre cada hermano, aplicado al",
        "hermano con menor vida total.",
    },
    ["node_coordination_name"] = "Coordinación",
    ["node_coordination"] = {
        "Causar daño 5 veces con Jacob otorga a Esau +10% lágrimas.",
        "Causar daño 5 veces con Esau otorga a Jacob +10% daño.",
        "Éste efecto se reinicia en cada habitación."
    },
    ["node_keepthematbay_name"] = "Frenación",
    ["node_keepthematbay"] = {
        "Al entrar a una habitación con monstruos, si algún hermano tiene por lo menos 3 contenedores de corazón rojo,",
        "15% chance de activar el efecto de Reloj de Arena.",
        "Si el efecto no es activado, duplica la chance para la próxima habitación."
    },
    ["node_choices_name"] = "Decisiones?",
    ["node_choices"] = {
        "Comienza con Hay Opciones (Jacob) y Más Opciones (Esau).",
        "Cuando un hermano recibe daño, 15% chance de perder el objeto de opciones correspondiente a éste.",
        "Ésta chance se aumenta en 5% por cada piso avanzado.",
        "Hay Opciones y Más Opciones ya no pueden aparecer naturalmente."
    },

    ["node_brotherhitneg_name"] = "Negación De Daño Entre Hermanos",
    ["node_brotherhitneg"] = {
        "{{brotherHitNegation}}% chance de negar daño que hubiera matado a un hermano si el otro tiene mas de 1 corazón rojo restante.",
        "Al activarse este efecto, el hermano opuesto pierde todos los corazones rojos excepto 1."
    },
    ["node_heartluck_name"] = "Suerte De Corazones",
    ["node_heartluck"] = {
        "+0.01 suerte por cada corazón lleno de cualquier tipo con el hermano que tenga menor vida total.",
        "El bonus es otorgado a ambos hermanos."
    },
    ["node_brotheritemallstat_name"] = "Estadísticas Con Objetos De Hermano",
    ["node_brotheritemallstat"] = "+{{jacobItemAllstats}}% a todas las estadísticas por cada objeto obtenido con el hermano opuesto, hasta 15%.",
    ["node_birthright_name"] = "Primogenitura",
    ["node_jacob_birthright"] = {
        "{{jacobBirthright}}% chance de que Mama adicionalmente tire Primogenitura al morir.",
        "Si Mama no tira Primogenitura, el Corazón de Mama tendrá la mitad de ésta chance de tirarla."
    },
    ["node_jacobheartonkill_name"] = "Corazón Al Matar Con Jacob",
    ["node_jacobheartonkill"] = "{{jacobHeartOnKill}}% chance de que los enemigos matados por Jacob tiren 1/2 corazón rojo adicional, una vez por habitación.",
    ["node_esausoulonkill_name"] = "Corazón De Alma Al Matar Con Esau",
    ["node_esausoulonkill"] = "{{esauSoulOnKill}}% chance de que los enemigos matados por Esau tiren 1/2 corazón de alma adicional, una vez por habitación.",
    ["node_slowparaext_name"] = "Extensión De Ralentización/Parálisis",
    ["node_slowparaext"] = {
        "Dañar a enemigos afectados por ralentización o parálisis extiende la duración del efecto por {{slowParaExtension}} segundos,",
        "hasta 4 veces por enemigo."
    },
    ["node_redstewboon_name"] = "Bendición Del Guisado Rojo",
    ["node_redstewboon"] = {
        "Al entrar a un piso, {{redStewBoon}}% chance de crear un Guisado Rojo por cada habitación completada sin",
        "recibir daño en el piso previo."
    },


    -- SIREN'S TREE --
    ["harmonic_prefix"] = "[Armónico]",
    ["node_darksongstress_name"] = "Cantante De La Oscuridad",
    ["node_darksongstress"] = {
        "Los enemigos no encantados reciben 8% menos daño.",
        "8% chance al matar a un enemigo encantado de otorgar 1 carga a Canción de la Sirena.",
        "Usar Canción de la Sirena quita estos efectos y otorga +8% daño y velocidad por la habitación actual."
    },
    ["node_songofdarkness_name"] = "Canción De Oscuridad",
    ["node_songofdarkness"] = {
        "2% chance de crear un corazón negro adicional al completar una habitación.",
        "[Armónico] Los enemigos encantados que mates aumentan esta chance en 0.4%, hasta 6%.",
        "[Armónico] +0.1 daño por cada 1/2 corazón negro restante que tengas.",
        "Los modificadores armónicos se desactivan si tienes mas de 2 nodos de canción asignados."
    },
    ["node_songoffortune_name"] = "Canción De Fortuna",
    ["node_songoffortune"] = {
        "+1 suerte.",
        "[Armónico] Usar Canción de la Sirena tiene un 15% chance de otorgar +0.05 suerte.",
        "[Armónico] Por debajo de 4 suerte, 50% chance de que los enemigos encantados den +0.01 suerte al morir.",
        "[Armónico] Por encima de 4 suerte, 25% chance de que los enemigos encantados no den suerte al morir.",
        "Los modificadores armónicos se desactivan si tienes mas de 2 nodos de canción asignados."
    },
    ["node_songofcelerity_name"] = "Canción De Celeridad",
    ["node_songofcelerity"] = {
        "+{{tearsPerc}}% tears.",
        "[Armónico] +7% velocidad.",
        "[Armónico] +1% lágrimas al dañar a un enemigo encantado, hasta 15%, reiniciandose en cada habitación.",
        "Los modificadores armónicos se desactivan si tienes mas de 2 nodos de canción asignados."
    },
    ["node_songofawe_name"] = "Canción De Admiración",
    ["node_songofawe"] = {
        "+4% a todas las estadísticas al usar Canción de la Sirena, una vez por habitación, reiniciandose en cada habitación.",
        "[Armónico] Canción de la Sirena adicionalmente ralentiza a los enemigos un 90% por 2 segundos al usarse.",
        "[Armónico] Canción de la Sirena gana una carga adicional al completar una habitación.",
        "Los modificadores armónicos se desactivan si tienes mas de 2 nodos de canción asignados."
    },
    ["node_overwhelmingvoice_name"] = "Voz Abrumadora",
    ["node_overwhelmingvoice"] = {
        "Canción de la Sirena convierte a monstruos aliados de vuelta a enemigos al usarse.",
        "+5% daño para la habitación actual por cada monstruo convertido de esta manera, hasta 20%.",
        "Canción de la Sirena causa 6 de daño a los enemigos encantados. Éste daño aumenta con cada piso avanzado."
    },

    ["node_luckoncharmkill_name"] = "Suerte Al Matar Encantado",
    ["node_luckoncharmkill"] = "{{luckOnCharmedKill}}% chance de que los enemigos encantados den +0.01 suerte al morir.",
    ["node_mightoffortune_name"] = "Poder De La Fortuna",
    ["node_mightoffortune"] = "+{{mightOfFortune}}% a todas las estadísticas menos suerte por cada 1 suerte que tengas.",
    ["node_charmedretaliation_name"] = "Represalias A Encantados",
    ["node_charmedretaliation"] = "Si un enemigo encantado te daña, devuelve {{charmedRetaliation}} de daño.",
    ["node_charmedhitneg_name"] = "Negación De Daño Encantado",
    ["node_charmedhitneg"] = {
        "{{charmedHitNegation}}% chance de negar daño que te hubiera matado si este fue originado por un enemigo encantado.",
        "Éste efecto solo puede ocurrir una vez por habitación."
    },
    ["node_charmexplosion_name"] = "Explosiones De Encantados",
    ["node_charmexplosion"] = {
        "{{charmExplosions}}% chance de que los enemigos encantados exploten en una nube de feromonas al morir, causando",
        "4 de daño y encantando a otros enemigos cercanos."
    }
}