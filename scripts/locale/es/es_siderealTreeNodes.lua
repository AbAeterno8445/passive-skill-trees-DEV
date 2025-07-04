return {
    ---- SIDEREAL TREE NODE MODIFIERS ----
    ["node_siderealvicinity_name"] = "Vicinidad Sideral",
    ["node_siderealregion_name"] = "Región Sideral",
    ["node_siderealexpanse_name"] = "Expansión Sideral",
    ["node_siderealtravel"] = "Nodo de viaje del Árbol Sideral. Asignarlo no cuesta SP global, y en cambio cuesta Oboles Arcanos.",

    ["node_astralforge_name"] = "Forja Astral",
    ["node_astralforge"] = {
        "Desbloquea la Forja Astral y las Armas Astrales.",
        "Una vez asignado, presiona Asignar para acceder al menu de la forja."
    },
    ["node_bossastralweprate_name"] = "Tasa De Aparición De Armas Astrales Por Jefes",
    ["node_bossastralweprate"] = {
        "+{{astralWepBossRate}}% chance de que los jefes tiren un arma astral al morir, hasta 4 por habitación.",
        "Por encima de 100% chance total, múltiples armas pueden generarse por este efecto."
    },
    ["node_magicastralweps_name"] = "Armas Astrales Mágicas",
    ["node_magicastralweps"] = "+{{astralWepMagicRate}}% chance de que las armas astrales encontradas sean de rareza mágica.",
    ["node_ancientastralweps_name"] = "Armas Astrales Antiguas",
    ["node_ancientastralweps"] = "+{{astralWepAncientRate}}% chance de que las armas astrales encontradas sean de rareza antigua.",

    ["node_wepdrop_longsword_name"] = "Armas Astrales: Espadas Largas",
    ["node_wepdrop_longsword"] = "+{{astralWepRateLongsword}}% chance de que las armas astrales encontradas sean del tipo Espadas Largas.",
    ["node_wepdrop_estoc_name"] = "Armas Astrales: Estocs",
    ["node_wepdrop_estoc"] = "+{{astralWepRateEstoc}}% chance de que las armas astrales encontradas sean del tipo Estocs.",
    ["node_wepdrop_dagger_name"] = "Armas Astrales: Dagas",
    ["node_wepdrop_dagger"] = "+{{astralWepRateDagger}}% chance de que las armas astrales encontradas sean del tipo Dagas.",
    ["node_wepdrop_quickblade_name"] = "Armas Astrales: Hojas Rápidas",
    ["node_wepdrop_quickblade"] = "+{{astralWepRateQuickblade}}% chance de que las armas astrales encontradas sean del tipo Hojas Rápidas.",
    ["node_wepdrop_spear_name"] = "Armas Astrales: Lanzas",
    ["node_wepdrop_spear"] = "+{{astralWepRateSpear}}% chance de que las armas astrales encontradas sean del tipo Lanzas.",
    ["node_wepdrop_trident_name"] = "Armas Astrales: Tridentes",
    ["node_wepdrop_trident"] = "+{{astralWepRateTrident}}% chance de que las armas astrales encontradas sean del tipo Tridentes.",
    ["node_wepdrop_scythe_name"] = "Armas Astrales: Guadañas",
    ["node_wepdrop_scythe"] = "+{{astralWepRateScythe}}% chance de que las armas astrales encontradas sean del tipo Guadañas.",
    ["node_wepdrop_axe_name"] = "Armas Astrales: Hachas",
    ["node_wepdrop_axe"] = "+{{astralWepRateAxe}}% chance de que las armas astrales encontradas sean del tipo Hachas.",
    ["node_wepdrop_greataxe_name"] = "Armas Astrales: Hachas Pesadas",
    ["node_wepdrop_greataxe"] = "+{{astralWepRateGreataxe}}% chance de que las armas astrales encontradas sean del tipo Hachas Pesadas.",
    ["node_wepdrop_shortbow_name"] = "Armas Astrales: Arcos Cortos",
    ["node_wepdrop_shortbow"] = "+{{astralWepRateShortbow}}% chance de que las armas astrales encontradas sean del tipo Arcos Cortos.",
    ["node_wepdrop_bow_name"] = "Armas Astrales: Arcos",
    ["node_wepdrop_bow"] = "+{{astralWepRateBow}}% chance de que las armas astrales encontradas sean del tipo Arcos.",
    ["node_wepdrop_crossbow_name"] = "Armas Astrales: Ballestas",
    ["node_wepdrop_crossbow"] = "+{{astralWepRateCrossbow}}% chance de que las armas astrales encontradas sean del tipo Ballestas.",
    ["node_wepdrop_gauntlet_name"] = "Armas Astrales: Guanteletes",
    ["node_wepdrop_gauntlet"] = "+{{astralWepRateGauntlet}}% chance de que las armas astrales encontradas sean del tipo Guanteletes.",
    ["node_wepdrop_greatmace_name"] = "Armas Astrales: Mazas Pesadas",
    ["node_wepdrop_greatmace"] = "+{{astralWepRateGreatMace}}% chance de que las armas astrales encontradas sean del tipo Mazas Pesadas.",
    ["node_wepdrop_whip_name"] = "Armas Astrales: Látigos",
    ["node_wepdrop_whip"] = "+{{astralWepRateWhip}}% chance de que las armas astrales encontradas sean del tipo Látigos.",

    ["node_sidecachechanceboost_name"] = "Mejora De Chance De Caches Siderales",
    ["node_sidecachechanceboost"] = {
        "Al entrar a un nuevo piso, +{{sideCacheFloorChance}}% chance añadida a todas las fuentes de Caches Siderales de otros nodos.",
        "Este efecto no se aplica durante el Ascenso."
    },
    ["node_sidecachechall_name"] = "Caches Siderales - Habitaciones Del Desafío",
    ["node_sidecachechall"] = "{{sideCacheChallenge}}% chance de que un Cache Sideral aparezca al completar una habitación del desafío.",
    ["node_sidecachebossroom_name"] = "Caches Siderales - Habitaciones Del Jefe",
    ["node_sidecachebossroom"] = "{{sideCacheBoss}}% chance de que un Cache Sideral aparezca al completar una habitación del jefe (excluye 1er piso).",
    ["node_sidecacheregchest_name"] = "Caches Siderales - Cofres Regulares",
    ["node_sidecacheregchest"] = {
        "{{sideCacheRegChest}}% chance de que los cofres regulares sean reemplazados con un Cache Sideral al aparecer.",
        "Afecta hasta 2 cofres por habitación."
    },
    ["node_sidecachekeycons_name"] = "Consumo De Llaves Con Caches Siderales",
    ["node_sidecachekeycons"] = "{{sideCacheNoKey}}% chance de no consumir llaves al abrir un Cache Sideral.",
    ["node_sidecachereplica_name"] = "Replicación De Cache Sideral",
    ["node_sidecachereplica"] = "{{sideCacheReplica}}% chance de que los Caches Siderales creen un Cache adicional al abrirse, una vez por habitación.",
    ["node_sidecachesacks_name"] = "Sacos Con Caches Siderales",
    ["node_sidecachesacks"] = "{{sideCacheSacks}}% chance de que los Caches Siderales adicionalmente tiren 1-2 sacos al abrirse.",
    ["node_sidecacheastralweps_name"] = "Armas Astrales Con Caches Siderales",
    ["node_sidecacheastralweps"] = {
        "{{sideCacheAstralWep}}% chance de que los Caches Siderales adicionalmente tiren un arma astral aleatoria.",
        "Por encima de 100% chance total, múltiples armas pueden generarse por este efecto."
    },
    ["node_sidecachejewels_name"] = "Joyas Malditas Por Caches Siderales",
    ["node_sidecachejewels"] = "{{sideCacheJewel}}% chance de que los Caches Siderales adicionalmente tiren una Joya Maldecida al abrirse.",
    ["node_sidecachekeyret_name"] = "Retorno De Llaves Con Caches Siderales",
    ["node_sidecachekeyret"] = "{{sideCacheKeyReturn}}% chance de que los Caches Siderales devuelvan 1-2 llaves al abrirse.",

    ["node_bosssparkdust_name"] = "Polvo Estelar Reluciente Por Jefes",
    ["node_bosssparkdust"] = "+{{bossSparkStardust}}% chance de que los jefes den Polvo Estelar Reluciente al morir.",
    ["node_finalbossdust_name"] = "Polvo Estelar Antiguo Por Jefes Finales",
    ["node_finalbossdust"] = "+{{bossExtraAncientStardust}}% chance de que los jefes finales den 1 Polvo Estelar Antiguo adicional al morir.",
    ["node_prehonedweps_name"] = "Armas Pre-Afiladas",
    ["node_prehonedweps"] = {
        "{{preHonedWeps}}% chance de que las armas astrales encontradas tengan +1 filo.",
        "Esta chance se aplica una vez independientemente por cada nodo asignado de este tipo."
    },

    ["node_siderealuniv_name"] = "Universalización Sideral",
    ["node_siderealuniv"] = {
        "Los efectos del Árbol Sideral ahora pueden aplicarse a partidas que no sean expediciones.",
        "No permite Respec una vez asignado."
    },

    ["node_timelessbazaar_name"] = "Bazar Atemporal",
    ["node_timelessbazaar"] = {
        "Una vez asignado, presiona Asignar para acceder al menu del Bazar Atemporal.",
        "El Bazar Atemporal permite gastar SP global y oboles para comprar objetos a añadir en el comienzo de",
        "la próxima partida que comienzes."
    },
    ["node_bazaarqual0to1_name"] = "Calidad De Objeto Del Bazar 0 a 1",
    ["node_bazaarqual0to1"] = "{{bazaarQual1}}% chance al refrescar el Bazar de mejorar los objetos de calidad 0 a calidad 1.",
    ["node_bazaarqual1to2_name"] = "Calidad De Objeto Del Bazar 1 a 2",
    ["node_bazaarqual1to2"] = "{{bazaarQual1}}% chance al refrescar el Bazar de mejorar los objetos de calidad 1 a calidad 2.",
    ["node_bazaarqual2to3_name"] = "Calidad De Objeto Del Bazar 2 a 3",
    ["node_bazaarqual2to3"] = "{{bazaarQual1}}% chance al refrescar el Bazar de mejorar los objetos de calidad 2 a calidad 3.",
    ["node_bazaaraddoffer_name"] = "Ofertas Adicionales Del Bazar",
    ["node_bazaaraddoffer"] = {
        "{{bazaarExtraItem}}% chance al refrescar el Bazar de incluir una opción de objeto adicional.",
        "Por encima de 100% chance total, múltiples objetos pueden ser añadidos por este efecto."
    },
    ["node_bazaarselkeep_name"] = "Mantenimiento De Selección Del Bazar",
    ["node_bazaarselkeep"] = "{{bazaarSelKeep}}% chance de mantener las demás opciones de objetos al comprar un objeto en el Bazar.",
    ["node_bazaardevilitem_name"] = "Objetos Del Diablo Del Bazar",
    ["node_bazaardevilitem"] = "{{bazaarDevil}}% chance de que los objetos ofrecidos sean de la habitación del diablo al refrescar el Bazar.",
    ["node_bazaarangelitem_name"] = "Objetos Del Ángel Del Bazar",
    ["node_bazaarangelitem"] = "{{bazaarAngel}}% chance de que los objetos ofrecidos sean de la habitación del ángel al refrescar al Bazar.",
    ["node_bazaarrefresh_name"] = "Refresco Del Bazar",
    ["node_bazaarrefresh"] = "Habilita la funcionalidad de \"Refresco\" el Bazar, permitiendo usar SP global y oboles para rerollear la selección de objetos.",
    ["node_bazaarrefreshkeep_name"] = "Mantenimiento De Refresco Del Bazar",
    ["node_bazaarrefreshkeep"] = "{{bazaarRefreshKeep}}% chance de mantener el botón de refresco del Bazar al usarlo.",

    ["node_charspconv_name"] = "Conversión De Puntos De Personaje",
    ["node_charspconv"] = "Una vez asignado, presiona Asignar para convertir 1 punto de personaje a 1 punto de habilidad global.",
    ["node_globalspexchange_name"] = "Intercambio De Puntos De Habilidad Globales",
    ["node_obolexchange_name"] = "Intercambio De Oboles",
    ["node_obolexchange"] = "Una vez asignado, presiona Asignar para convertir 1 punto de habilidad global a 10 oboles arcanos.",

    ["node_ancwepbounties_name"] = "Cazas De Armas Antiguas",
    ["node_ancwepbounties"] = {
        "Asigna para desbloquear las Cazas de Armas Antiguas.",
        "Esto te permite gastar oboles para generar una Caza para un tipo de arma elegido.",
        "Las Cazas proveen una serie de objetivos a completar, y recompensan un arma antigua aleatoria del tipo elegido al",
        "completarse."
    },

    ["node_crimsonconvergence_name"] = "Convergencia Carmesí",
    ["node_crimsonconvergence"] = {
        "Una vez asignado, presiona Asignar para seleccionar una de varias bendiciones.",
        "Estas bendiciones se vuelven más poderosas cuanto más Núcleos Estelares Carmesí tengas con el personaje actual."
    },

    ["node_siderealartifact_name"] = "Artefacto Sideral",
    ["node_siderealartifact"] = {
        "Habilita la selección de Artefactos que proveen una condición para generar Energía, y",
        "un efecto activable al generar suficiente Energía.",
        "Por defecto solo puedes tener 1 artefacto Septentrional y 1 Meridional.",
        "Los nodos de artefactos pueden asignarse sin costo."
    },
    ["node_bloodseptentrion_name"] = "Septentrión Sanguíneo",
    ["node_taintbloodseptentrion_name"] = "Septentrión de Sangre Contaminada",
    ["node_icyseptentrion_name"] = "Septentrión Gélido",
    ["node_beastseekerseptentrion_name"] = "Septentrión Cazador de Bestias",
    ["node_giantseekerseptentrion_name"] = "Septentrión Cazador de Gigantes",
    ["node_rotseekerseptentrion_name"] = "Septentrión de la Podredumbre",
    ["node_titanseekerseptentrion_name"] = "Septentrión Cazador de Titanes",
    ["node_assassinseptentrion_name"] = "Septentrión Asesino",
    ["node_deathseekerseptentrion_name"] = "Septentrión Cazador de Muerte",
    ["node_allianceseptentrion_name"] = "Septentrión de Alianza",
    ["node_slayerseptentrion_name"] = "Septentrión Matador",
    ["node_magicseptentrion_name"] = "Septentrión Mágico",
    ["node_solarseptentrion_name"] = "Septentrión Solar",
    ["node_lunarseptentrion_name"] = "Septentrión Lunar",
    ["node_superstitiousseptentrion_name"] = "Septentrión Supersticioso",

    ["node_galvanicmeridion_name"] = "Meridión Galvánico",
    ["node_glacialmeridion_name"] = "Meridión Glacial",
    ["node_smitingmeridion_name"] = "Meridión Castigante",
    ["node_infectiousmeridion_name"] = "Meridión Infeccioso",
    ["node_virtuousmeridion_name"] = "Meridión Virtuoso",
    ["node_stonemeridion_name"] = "Meridión de Piedra",
    ["node_infernalmeridion_name"] = "Meridión Infernal",
    ["node_deadseameridion_name"] = "Meridión del Mar Muerto",
    ["node_flowingmeridion_name"] = "Meridión Afluente",
    ["node_osseousmeridion_name"] = "Meridión Óseo",
    ["node_monstrousmeridion_name"] = "Meridión Monstruoso",
    ["node_brimmeridion_name"] = "Meridión Siniestro",
    ["node_executionermeridion_name"] = "Meridión del Verdugo",
    ["node_blastingmeridion_name"] = "Meridión Explosivo",
    ["node_gildedmeridion_name"] = "Meridión Dorado",
    ["node_smeltermeridion_name"] = "Meridión de Fundición",
    ["node_siderealmeridion_name"] = "Meridión Sideral",
    ["node_snakeeyemeridion_name"] = "Meridión Ojo de Serpiente",
    ["node_bloodmoonmeridion_name"] = "Meridión de la Luna de Sangre",

    ["node_addseptentrional_name"] = "Elección Septentrional Adicional",
    ["node_addseptentrional"] = "Permite asignar un artefacto Septentrional adicional.",

    ["node_obolmagnetism_name"] = "Magnetismo de Oboles",
    ["node_obolmagnetism"] = "Los oboles arcanos recolectables son lentamente atraídos a tu posición.",

    ["node_ancwepcompendium_name"] = "Diccionario de Armas Antiguas",
    ["node_ancwepcompendium"] = {
        "Una vez asignado, presiona Asignar para abrir una lista de todas las armas antiguas disponibles",
        "para cada tipo de arma."
    },


    ---- CRIMSON CONVERGENCE ----
    ["ui_crimconv_mundaneSlaughter"] = "Matanza Mundana",
    ["ui_crimconv_mundaneSlaughter_desc"] = {"Por Núcleo Estelar Carmesí: +1% daño infligido a monstruos normales."},
    ["ui_crimconv_giantSlaughter"] = "Matanza de Gigantes",
    ["ui_crimconv_giantSlaughter_desc"] = {"Por Núcleo Estelar Carmesí: +1% daño infligido a campeones y jefes no finales."},
    ["ui_crimconv_titanSlaughter"] = "Matanza de Titanes",
    ["ui_crimconv_titanSlaughter_desc"] = {"Por Núcleo Estelar Carmesí: +2% daño infligido a jefes finales."},
    ["ui_crimconv_blightseeking"] = "Caza de Plagas",
    ["ui_crimconv_blightseeking_desc"] = {"Por Núcleo Estelar Carmesí: +1% daño infligido a enemigos con efectos de estado."},
    ["ui_crimconv_celerity"] = "Celeridad",
    ["ui_crimconv_celerity_desc"] = {"Tu velocidad mínima en habitaciones completadas se vuelve 1 + 0.04 por Núcleo Estelar Carmesí."},
    ["ui_crimconv_bloodshield"] = "Escudo Sanguíneo",
    ["ui_crimconv_bloodshield_desc"] = {
        "Al entrar a una habitación con monstruos, vuelvete invulnerable por 1.5 segundos.",
        "+0.1 segundos a la duración de la invulnerabilidad por Núcleo Estelar Carmesí."
    },
    ["ui_crimconv_abundanceGoods"] = "Abundancia: Bienes",
    ["ui_crimconv_abundanceGoods_desc"] = {
        "Por Núcleo Estelar Carmesí: Cada vez que aparece una moneda/llave/bomba, 1% chance de duplicarla.",
        "Triplica esta chance para recolectables temporales."
    },
    ["ui_crimconv_abundanceVitality"] = "Abundancia: Vitalidad",
    ["ui_crimconv_abundanceVitality_desc"] = {
        "Por Núcleo Estelar Carmesí: Cada vez que aparece un corazón, 1% chance de duplicarlo.",
        "Duplica esta chance para corazones temporales."
    },
    ["ui_crimconv_sanguineCharges"] = "Cargas Sanguinarias",
    ["ui_crimconv_sanguineCharges_desc"] = {
        "Por Núcleo Estelar Carmesí: When using an active item with at least 2 charges, 10% chance to",
        "Por Núcleo Estelar Carmesí: Al usar un objeto activo con al menos 2 cargas, 10% chance de retener 1 carga.",
        "Por encima de 100% chance total, múltiples cargas pueden ser retenidas.",
        "Este efecto puede sobrecargar los objetos activos."
    },
    ["ui_crimconv_fortuna"] = "Fortuna",
    ["ui_crimconv_fortuna_desc"] = {
        "Por Núcleo Estelar Carmesí: 1% de tu estadística de suerte es añadida a tu daño."
    },
    ["ui_crimconv_starstruck"] = "Deslumbre",
    ["ui_crimconv_starstruck_desc"] = {"Por Núcleo Estelar Carmesí: +3% oboles encontrados."}
}