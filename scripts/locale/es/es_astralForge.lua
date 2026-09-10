return {
    ---- ASTRAL FORGE (WEAPONS & UI) ----
    ["ui_astralForge"] = "Forja Astral",
    ["ui_astralwep"] = "Arma Astral",

    ["ui_wepInv"] = "Inventario de Armas",
    ["ui_decon"] = "Decon", -- from 'Deconstructing'
    ["ui_Imprint"] = "Impresión",
    ["ui_equippedWeapon"] = "Arma Equipada",
    ["ui_costs"] = "Costos",

    ["ui_missingYouHave"] = "faltante, tienes",

    ["ui_hoverMoreInfo"] = "Cursor encima para más información.",
    ["ui_allocToSelect"] = "Botón Asignar para seleccionar.",
    ["ui_shiftAllocUnequip"] = "Shift + Asignar para desequipar.",
    ["ui_invEmpty"] = "Inventario Vacío",
    ["ui_deconstructingWep"] = "Deconstruyendo Arma",
    ["ui_respecDecon"] = "Presiona Respec para deconstruir esta arma y obtener estos materiales.",
    ["ui_holdRespecDecon"] = "Mantén Respec por 1 segundo para deconstruir esta arma y obtener estos materiales.",

    ["ui_wepForging"] = "Forjado de Armas",
    ["ui_selWepToForge"] = "Selecciona un arma de tu inventario para comenzar a forjar.",
    ["ui_allocToSelHoverWepForge"] = "Presiona Asignar para seleccionar el arma encima del cursor a forjar.",
    ["ui_shiftAllocEquipHoverWep"] = "Shift + Asignar para equipar el arma encima del cursor.",
    ["ui_shiftHFavWep"] = "Shift + H para marcar el arma encima del cursor como favorita.",
    ["ui_shiftHFavThisWep"] = "Presiona Shift + H para marcar el arma en el cursor como favorita.",
    ["ui_shiftAllocEquipWith"] = "Shift + Asignar para equipar esta arma con {{charName}}.",

    ["ui_imprintNote1"] = "NOTA: La Impresión destruirá esta arma!",
    ["ui_imprintNote2"] = "Presiona Asignar para imprimir esta arma en la arma antigua actualmente seleccionada.",
    ["ui_imprintingWep"] = "Imprimiendo Arma",

    ["ui_toggleDeconMode"] = "Activar Modo Deconstrucción",
    ["ui_forgeDeconDesc"] = {
        "Presiona Asignar para activar el Modo Deconstrucción.",
        "Mientras este activo este modo, presiona Respec al tener el cursor encima de un arma para",
        "deconstruirla y conseguir materiales de forjado, destruyéndola en el proceso."
    },
    ["ui_toggleMultiDecon"] = "Activar Multi-Deconstrucción",
    ["ui_multiDeconDesc"] = {
        "Presiona Asignar para activar el Modo Multi-Deconstrucción.",
        "En este modo, puedes seleccionar múltiples armas con el botón Asignar para deconstruirlas en masa.",
        "Presiona Ctrl + Asignar al tener el cursor sobre un filtro o un arma para seleccionar todas las armas filtradas actualmente.",
        "Presiona Respec en un arma para deconstruir todas las armas seleccionadas.",
        {"Usar con cuidado! Asegurate de no seleccionar armas que quieras mantener.", PST.kcolors.STAR_ORANGE}
    },

    ["ui_Materials"] = "Materiales",
    ["ui_forgeMaterial"] = "Materiales de Forjado",
    ["ui_mundaneEssence"] = "Esencia Mundana",
    ["ui_sparklingEssence"] = "Esencia Reluciente",
    ["ui_ancientEssence"] = "Esencia Antigua",
    ["ui_sparklingStardust"] = "Polvo Estelar Reluciente",
    ["ui_ancientStardust"] = "Polvo Estelar Antiguo",

    ["ui_filter"] = "Filtro",
    ["ui_noHoning"] = "Sin Filo",
    ["ui_someHoning"] = "Algo de Filo",
    ["ui_maxHoning"] = "Filo Maximizado",
    ["ui_favorited"] = "Favoritos",
    ["ui_allocApplyFilter"] = "Presiona Asignar para aplicar este filtro.",

    ["ui_source"] = "Fuente",
    ["ui_equippedBy"] = "Equipado por",

    ["ui_mundaneEssence_src"] = "Deconstruyendo armas normales.",
    ["ui_sparklingEssence_src"] = "Deconstruyendo armas con modificadores (mágicas/antiguas).",
    ["ui_ancientEssence_src"] = "Deconstruyendo armas antiguas.",
    ["ui_sparklingStardust_src"] = "Matando jefes y completando habitaciones del desafío.",
    ["ui_ancientStardust_src"] = "Matando jefes finales.",
    ["ui_starblessedPrism_src"] = "Recompensa en Expediciones Uber.",

    ["ui_Honing"] = "Afilado",
    ["ui_Honing_desc"] = {"Afila el arma, mejorando su modificador implícito. Cada arma puede afilarse hasta 50 veces."},
    ["ui_Transmutation"] = "Transmutación",
    ["ui_Transmutation_desc"] = {"Transforma esta arma normal a mágica, añadiendo 1 modificador aleatorio."},
    ["ui_rerollMods"] = "Rerollear Modificadores",
    ["ui_rerollMods_desc"] = {"Rerollea los modificadores del arma. Puede resultar en 1 o 2 modificadores."},
    ["ui_addMod"] = "Añadir Modificador",
    ["ui_addMod_desc"] = {"Añade un modificador aleatorio si el arma solo tiene 1."},
    ["ui_removeMod"] = "Quitar Modificador",
    ["ui_removeMod_desc"] = {"Quita un modificador aleatorio si el arma tiene 2."},
    ["ui_alterMods"] = "Alterar Modificadores",
    ["ui_alterMods_desc"] = {"Rerollea los valores numéricos de los modificadores no-implícitos del arma."},
    ["ui_ancImprint"] = "Impresión Antigua",
    ["ui_ancImprint_desc"] = {
        "Imprime un modificador aleatorio de otra arma mágica hacia esta arma antigua.",
        "El arma mágica a usar debe tener más de 1 modificador.",
        "Solo puedes imprimir 1 modificador en cada arma antigua, o 2 si esta posee Bendición Estelar.",
        "Los modificadores impresos no pueden modificarse una vez aplicados."
    },
    ["ui_ancImprint_desc_imp"] = {
        "Pon el cursor sobre el arma mágica en el inventario a imprimir, y presiona Asignar para imprimir.",
        "Presiona Asignar sobre este botón para desactivar el modo de impresión antigua."
    },
    ["ui_ancUpgrade"] = "Mejora Antigua",
    ["ui_ancUpgrade_desc"] = {"Mejora el modificador único de esta arma antigua."},
    ["ui_starblessing"] = "Bendición Estelar",
    ["ui_starblessing_desc"] = {
        "Aplica un Prisma Estelar a esta arma, permitiendo imprimir un modificador adicional en ella.",
        "Aplicable 1 vez por arma antigua, si no posee una bendición estelar."
    },

    ["aforge_wepname_Longsword"] = "Espada Larga",
    ["aforge_wepname_Longswords"] = "Espadas Largas",
    ["aforge_wepname_Estoc"] = "Estoc",
    ["aforge_wepname_Estocs"] = "Estocs",
    ["aforge_wepname_Dagger"] = "Daga",
    ["aforge_wepname_Daggers"] = "Dagas",
    ["aforge_wepname_Quickblade"] = "Hoja Rápida",
    ["aforge_wepname_Quickblades"] = "Hojas Rápidas",
    ["aforge_wepname_Spear"] = "Lanza",
    ["aforge_wepname_Spears"] = "Lanzas",
    ["aforge_wepname_Trident"] = "Tridente",
    ["aforge_wepname_Tridents"] = "Tridentes",
    ["aforge_wepname_Scythe"] = "Guadaña",
    ["aforge_wepname_Scythes"] = "Guadañas",
    ["aforge_wepname_Axe"] = "Hacha",
    ["aforge_wepname_Axes"] = "Hachas",
    ["aforge_wepname_Greataxe"] = "Hacha Pesada",
    ["aforge_wepname_Greataxes"] = "Hachas Pesadas",
    ["aforge_wepname_Shortbow"] = "Arco Ligero",
    ["aforge_wepname_Shortbows"] = "Arcos Ligeros",
    ["aforge_wepname_Bow"] = "Arco",
    ["aforge_wepname_Bows"] = "Arcos",
    ["aforge_wepname_Gauntlet"] = "Guantelete",
    ["aforge_wepname_Gauntlets"] = "Guanteletes",
    ["aforge_wepname_Great Mace"] = "Maza Pesada",
    ["aforge_wepname_Great Maces"] = "Mazas Pesadas",
    ["aforge_wepname_Whip"] = "Látigo",
    ["aforge_wepname_Whips"] = "Látigos",

    ["aforge_ancname_Grey Wind"] = "Viento Fúnebre",
    ["aforge_ancname_Executioner"] = "Ejecutor",
    ["aforge_ancname_Sword of Song"] = "Espada Melódica",
    ["aforge_ancname_Redbeak"] = "Pico Rojo",
    ["aforge_ancname_Glowing Moonblade"] = "Espada Selénica",
    ["aforge_ancname_Maxwell's Thermic Engine"] = "Motor Térmico de Maxwell",
    ["aforge_ancname_Glowing Sunblade"] = "Espada Solar",
    ["aforge_ancname_Divine Interceptor"] = "Interceptadora Divina",

    ["aforge_ancname_Arcing Needle"] = "Aguja Eléctrica",
    ["aforge_ancname_Auric Persecutor"] = "Persecutor Áurico",

    ["aforge_ancname_The Scrambler"] = "El Codificador",
    ["aforge_ancname_Adrift Blade"] = "Hoja a la Deriva",
    ["aforge_ancname_Ivory Vampire"] = "Vampiro de Marfil",

    ["aforge_ancname_Nimble Twins"] = "Gemelos Ágiles",
    ["aforge_ancname_Crimson Altruist"] = "Altruista carmesí",
    ["aforge_ancname_Quicksilver"] = "Mercurio",

    ["aforge_ancname_Beastbane"] = "Perdición de las Bestias",
    ["aforge_ancname_Gravitas"] = "Gravitas",
    ["aforge_ancname_Boreal Frostspear"] = "Lanza Gélida Boreal",
    ["aforge_ancname_Viper Stinger"] = "Aguijón Viperino",

    ["aforge_ancname_Consecrator"] = "Consecrador",
    ["aforge_ancname_Verdant Green"] = "Tridente Verdeante",
    ["aforge_ancname_Lost Coral Trident"] = "Tridente Coral Perdido",
    ["aforge_ancname_Oceanic Might"] = "Poder Oceánico",

    ["aforge_ancname_Tale Ender"] = "Terminador de Historias",
    ["aforge_ancname_Crimson Reaper"] = "Segador Carmesí",
    ["aforge_ancname_Mobripper"] = "Segador de Multitudes",

    ["aforge_ancname_Starsteel Broadaxe"] = "Hacha de Acero Estelar",
    ["aforge_ancname_Ancient Runic Chopper"] = "Hacha Rúnica Antigua",
    ["aforge_ancname_Circuit Splitter"] = "Cortacircuitos",

    ["aforge_ancname_Berserker's Wrath"] = "Furia Frenética",
    ["aforge_ancname_Frozen Terror"] = "Terror Congelado",

    ["aforge_ancname_Storm's Advance"] = "Avance de la Tormenta",
    ["aforge_ancname_Quill Rain"] = "Lluvia de Púas",

    ["aforge_ancname_Gilded Seeker"] = "Buscador Dorado",
    ["aforge_ancname_Twisted Oakstring"] = "Arco de Roble Retorcido",
    ["aforge_ancname_Brute's Onslaught"] = "Embestida Bruta",
    ["aforge_ancname_Divine Messenger"] = "Mensajera Divina",

    ["aforge_ancname_Volatile Arbalest"] = "Ballesta Volátil",
    ["aforge_ancname_Avelyn"] = "Avelín",
    ["aforge_ancname_Precise Seeker"] = "Buscador Preciso",

    ["aforge_ancname_Magefist"] = "Puño Mágico",
    ["aforge_ancname_Ironhand"] = "Puño de Hierro",
    ["aforge_ancname_Metamorphic Claw"] = "Garras Metamórficas",

    ["aforge_ancname_Mighty Purifier"] = "Purificador Potente",
    ["aforge_ancname_Chaotic Tumult"] = "Tumulto Caótico",
    ["aforge_ancname_Firestarter"] = "Mazo Incendiario",
    ["aforge_ancname_Colossal Maul"] = "Mazo Colosal",
    ["aforge_ancname_Tolling Bell"] = "Campana Llamante",

    ["aforge_ancname_Snakebite"] = "Mordedura Viperina",
    ["aforge_ancname_Devil's Tongue"] = "Lengua del Diablo",
    ["aforge_ancname_Azurebinder"] = "Atadura Azur",
    ["aforge_ancname_Sacred Scourge"] = "Azote Sagrado",


    ["aforge_mod_desc_longswordImp"] = "+{{roll1}}% daño infligido a enemigos a 1.5 casillas de ti.",
    ["aforge_mod_desc_estocImp"] = {
        "Golpes consecutivos contra enemigos a 2 casillas de ti otorgan +{{roll1}}% lágrimas, hasta {{roll2}}%.",
        "Golpear a un enemigo a más de 2 casillas de ti reinicia el bonus."
    },
    ["aforge_mod_desc_daggerImp"] = {
        "{{roll1}}% chance de que tus golpes inflijan {{roll2}}% más daño.",
        "Duplica esta chance contra enemigos a 1.5 casillas de ti."
    },
    ["aforge_mod_desc_quickbladeImp"] = {
        "+{{roll1}} lágrimas por {{roll2}} segundo(s) al golpear a un enemigo, apilándose hasta {{roll3}}.",
        "Duplica la duración al golpear enemigos a 1.5 casillas de ti.",
        "Cada instancia de este efecto tiene su propia duración."
    },
    ["aforge_mod_desc_spearImp"] = {
        "+{{roll1}}% daño infligido a enemigos entre 1.5 y 2.5 casillas de ti.",
        "-{{roll2}}% daño infligido a enemigos a 1.5 casillas de ti."
    },
    ["aforge_mod_desc_tridentImp"] = {
        "Golpes consecutivos contra enemigos a más de 1.5 casillas de ti otorgan +{{roll1}}% daño y lágrimas, hasta {{roll2}}%.",
        "Golpear a un enemigo a 1.5 casillas de ti reinicia el bonus."
    },
    ["aforge_mod_desc_scytheImp"] = {
        "Golpear a un enemigo lanza un ataque circular que daña a enemigos cercanos por {{roll1}}% del daño original.",
        "Este efecto tiene un enfriamiento de {{roll2}} segundos."
    },
    ["aforge_mod_desc_axeImp"] = {
        "{{roll1}}% chance de causar sangrado por 3 segundos al golpear enemigos.",
        "+{{roll2}}% daño con golpes contra enemigos sangrantes."
    },
    ["aforge_mod_desc_greataxeImp"] = {
        "Cada {{roll1}} golpes contra cada enemigo les causa sangrado por 4 segundos.",
        "+{{roll2}}% daño por 2 segundos luego de golpear a un enemigo sangrante.",
        "{{roll3}}% lágrimas."
    },
    ["aforge_mod_desc_shortbowImp"] = {
        "+{{roll1}} velocidad de disparo.",
        "{{roll2}}% de tu velocidad de disparo por encima de 1 se vuelve un multiplicador de lágrimas, hasta +80%."
    },
    ["aforge_mod_desc_bowImp"] = {
        "+{{roll1}} velocidad de disparo.",
        "Los golpes contra enemigos infligen daño adicional cuanto más lejos de ti esten, hasta {{roll2}}%."
    },
    ["aforge_mod_desc_crossbowImp"] = {
        "{{roll1}} lágrimas.",
        "+{{roll2}} velocidad de disparo.",
        "Tu velocidad de disparo total se vuelve un multiplicador de daño, hasta {{roll3}}%."
    },
    ["aforge_mod_desc_gauntletImp"] = {
        "El arma puede tener un modificador mágico adicional. Los modificadores mágicos son más fuertes.",
        "El costo de Transmutación se reduce a la mitad en esta arma."
    },
    ["aforge_mod_desc_greatmaceImp"] = {
        "Golpear a un enemigo a 2.5 casillas de ti causa una onda que paraliza a enemigos cercanos por {{roll1}} segundos.",
        "Los enemigos ya paralizados afectados por la onda reciben {{roll2}}% de tu daño, limitado a 50.",
        "Este efecto tiene un enfriamiento de {{roll3}} segundos."
    },
    ["aforge_mod_desc_whipImp"] = {
        "Al golpear a un enemigo, dispara 5 lágrimas en línea en su dirección.",
        "Golpear enemigos con estas lágrimas aleatoriamente te otorga +{{roll1}}% velocidad o +{{roll1}}% lágrimas,",
        "hasta {{roll2}}%, por {{roll3}} segundos.",
        "Este efecto tiene un enfriamiento de 2 segundos."
    },

    ["aforge_mod_desc_dmgStatus"] = "+{{roll1}}% daño infligido a enemigos con estados de efecto.",
    ["aforge_mod_desc_dmgStatusSlow"] = "+{{roll1}}% daño infligido a enemigos ralentizados.",
    ["aforge_mod_desc_dmgStatusCharm"] = "+{{roll1}}% daño infligido a enemigos encantados.",
    ["aforge_mod_desc_dmgStatusPara"] = "+{{roll1}}% daño infligido a enemigos paralizados.",
    ["aforge_mod_desc_dmgStatusFear"] = "+{{roll1}}% daño infligido a enemigos asustados.",
    ["aforge_mod_desc_dmgStatusBleed"] = "+{{roll1}}% daño infligido a enemigos sangrantes.",
    ["aforge_mod_desc_dmgStatusPoison"] = "+{{roll1}}% daño infligido a enemigos envenenados.",
    ["aforge_mod_desc_dmgStatusBurn"] = "+{{roll1}}% daño infligido a enemigos quemándose.",
    ["aforge_mod_desc_consecFireDmg"] = "+{{roll1}}% daño infligido luego de disparar por 2 segundos consecutivos, reiniciandose al dejar de disparar.",
    ["aforge_mod_desc_consecFireDmg2"] = {
        "+{{roll1}}% daño infligido luego de disparar por 3 segundos consecutivos.",
        "Este efecto se reinicia 1 segundo después de dejar de disparar."
    },
    ["aforge_mod_desc_farEnemyDmg"] = "+{{roll1}}% daño infligido a enemigos a más de 2 casillas de ti.",
    ["aforge_mod_desc_closeEnemyDmg"] = "+{{roll1}}% daño infligido a enemigos a 2 casillas de ti.",
    ["aforge_mod_desc_baseDmg"] = "+{{roll1}} daño base.",
    ["aforge_mod_desc_baseDmg2"] = "+{{roll1}} daño base, removido por {{roll2}} segundos al recibir daño.",
    ["aforge_mod_desc_redHealDmg"] = {
        "Al recuperar corazones rojos, +{{roll1}}% daño infligido por 5 segundos por cada 1/2 corazón recuperado.",
        "Este efecto puede apilarse hasta {{roll2}}%."
    },
    ["aforge_mod_desc_soulHealDmg"] = {
        "Al conseguir corazones de alma, +{{roll1}}% daño infligido por 5 segundos por cada 1/2 corazón de alma conseguido.",
        "Este efecto puede apilarse hasta {{roll2}}%."
    },
    ["aforge_mod_desc_blackHealDmg"] = {
        "Al conseguir corazones negros, +{{roll1}}% daño infligido por 5 segundos por cada 1/2 corazón negro conseguido.",
        "Este efecto puede apilarse hasta {{roll2}}%."
    },
    ["aforge_mod_desc_purchaseDmg"] = {
        "+{{roll1}}% daño infligido por {{roll2}} segundos luego de comprar un objeto.",
        "Este efecto puede apilarse hasta {{roll3}}%"
    },
    ["aforge_mod_desc_coinPickupDmg"] = {
        "+{{roll1}}% daño infligido por {{roll2}} segundos luego de recolectar cualquier moneda.",
        "Este efecto puede apilarse hasta {{roll3}}%"
    },
    ["aforge_mod_desc_coinPermDmg"] = "+{{roll1}}% daño permanente al recolectar cualquier moneda valuada en 5 o más, hasta {{roll2}}%.",
    ["aforge_mod_desc_onHitEnemyDmgTaken"] = "Cuando recibas daño, los enemigos reciben {{roll1}}% más daño por {{roll2}} segundos.",
    ["aforge_mod_desc_flyGroundDmg"] = {
        "+{{roll1}}% daño infligido a enemigos voladores si no tienes vuelo.",
        "+{{roll1}}% daño infligido a enemigos no voladores si tienes vuelo."
    },
    ["aforge_mod_desc_activeFamDmg"] = "+{{roll1}}% daño infligido por cada familiar presente, hasta 40%.",
    ["aforge_mod_desc_famKillDmg"] = "+{{roll1}}% daño infligido por {{roll2}} segundos luego de que un familiar mate a un enemigo.",
    ["aforge_mod_desc_holyMantleDmg"] = "+{{roll1}}% daño infligido mientras tengas un escudo de Manto Sagrado.",
    ["aforge_mod_desc_eternalDmg"] = "+{{roll1}}% daño infligido mientras tengas un corazón eterno.",
    ["aforge_mod_desc_activeDmg"] = "+{{roll1}}% daño infligido por {{roll2}} segundos luego de usar un objeto activo.",
    ["aforge_mod_desc_healthyMobDmg"] = "+{{roll1}}% daño infligido a enemigos con más de 90% de vida.",
    ["aforge_mod_desc_injuredMobDmg"] = "+{{roll1}}% daño infligido a enemigos con menos de 15% de vida.",
    ["aforge_mod_desc_creepDmg"] = "+{{roll1}}% daño infligido mientras estés encima de algún charco.",
    ["aforge_mod_desc_playerCreepDmg"] = "+{{roll1}}% daño infligido por tus charcos.",
    ["aforge_mod_desc_laserDmg"] = "+{{roll1}}% daño infligido con lásers.",
    ["aforge_mod_desc_explosionDmg"] = "+{{roll1}}% daño infligido con explosiones.",
    ["aforge_mod_desc_injuredDmg"] = "+{{roll1}}% daño infligido mientras la mitad o más de tus contenedores de corazones rojos estén vacíos.",

    ["aforge_mod_desc_greyWind"] = {
        "{{roll1}}% chance al golpear de atacar a todos los enemigos a 2 casillas del objetivo, infligiendo",
        "{{roll2}}% del daño del golpe. Este efecto tiene un enfriamiento de 2 segundos.",
        "Si estos ataques golpean a 3 o menos enemigos, estos infligen un 50% más daño, causan sangrado por",
        "3 segundos, y el enfriamiento para esa activación es aumentada a 5 segundos.",
        "-0.6 daño base."
    },
    ["aforge_mod_desc_executioner"] = {
        "+{{roll1}}% daño.",
        "{{roll2}}% chance al golpear de ejecutar a enemigos que terminen con {{roll3}}% o menos de vida."
    },
    ["aforge_mod_desc_swordOfSong"] = {
        "{{roll1}}% chance al golpear de causar un pulso en la posición del enemigo que encanta a los enemigos cercanos por",
        "4 segundos.",
        "+1% daño cada vez que mates a un enemigo encantado.",
        "Cada {{roll2}} golpes contra monstruos encantados, reinicia el bonus de daño y activa el efecto de Lágrimas de Isaac."
    },
    ["aforge_mod_desc_redbeak"] = {
        "Si la mitad o más de tus contenedores de corazones rojos están vacíos:",
        "    +{{roll1}}% daño infligido.",
        "    {{roll2}}% chance de que tus golpes causen sangrado por 4 segundos.",
        "    {{roll3}}% chance de que los enemigos sangrantes tiren 1/2 corazón rojo al morir, el cual desaparece luego de 2 segundos.",
    },
    ["aforge_mod_desc_glowingMoonblade"] = {
        "Comienza con el efecto de Luna.",
        "-{{roll1}}% daño y lágrimas.",
        "Al entrar a una habitación secreta por primera vez, quita estas reducciones por el piso actual.",
        "Entrar a 2 habitaciones secretas otorga +{{roll2}} velocidad para el piso actual, una vez por piso."
    },
    ["aforge_mod_desc_maxwellEngine"] = {
        "+0.5% daño por 3 segundos al golpear a un enemigo, apilable hasta {{roll1}}%.",
        "Mientras el efecto esté al máximo:",
        "    {{roll2}}% chance de que tus golpes causen quemadura o ralentización por 3 segundos.",
        "    15% chance de que los enemigos con quemadura exploten al morir, infligiendo 30 de daño a enemigos cercanos.",
        "    15% chance de que los enemigos ralentizados se congelen al morir."
    },
    ["aforge_mod_desc_glowingSunblade"] = {
        "Comienza con el efecto de Sol.",
        "-{{roll1}}% daño y lágrimas.",
        "Al entrar a la habitación del jefe por primera vez, quita estas reducciones para el piso actual.",
        "Al entrar a la habitación del tesoro por primera vez, gana +{{roll2}} velocidad para el piso actual."
    },
    ["aforge_mod_desc_divineInterceptor"] = {
        "Al golpear a un enemigo a 2 casillas de ti, dispara una dispersión de proyectiles espada hacia el enemigo.",
        "Estos proyectiles espada infligen 50% de tu daño, limitado a 50.",
        "Nivel de mejora actual: {{roll1}}.",
        "Dispara un proyectil espada adicional con cada nivel de mejora.",
        "Nivel 3 de mejora: los proyectiles espada ahora perforan a los enemigos.",
        "Nivel 6 de mejora: los proyectiles espada ahora persiguen a los enemigos.",
        "Este efecto tiene 5 segundos de enfriamiento."
    },
    ["aforge_mod_desc_arcingNeedle"] = {
        "Cada 0.5 segundos disparando, {{roll1}}% chance de obtener el efecto de la Escalera de Jacob por {{roll2}} segundos.",
        "Esta chance aumenta un 1% continuamente al seguir disparando, y se reinicia al dejar de disparar.",
        "Obtener la Escalera de Jacob como objeto otorga +15% lágrimas."
    },
    ["aforge_mod_desc_auricPersecutor"] = {
        "La mitad de tus monedas ahora se aplican como un multiplicador de lágrimas, hasta {{roll1}}%.",
        "+{{roll2}}% daño para el piso actual al recolectar monedas valuadas en 5 o más, hasta {{roll3}}%."
    },
    ["aforge_mod_desc_scrambler"] = {
        "3% chance al golpear de confundir a los enemigos por 4 segundos. Triplica esta chance contra enemigos a 1.5 casillas de ti.",
        "Aumenta esta chance en 1% al entrar a un nuevo piso.",
        "Inflige {{roll1}}% más daño contra enemigos confundidos.",
        "Golpear a enemigos confundidos tiene un {{roll2}}% chance de quitar su confusión."
    },
    ["aforge_mod_desc_adriftBlade"] = "{{roll1}}% chance de infligir entre {{roll2}}% y {{roll3}}% del daño original al golpear.",
    ["aforge_mod_desc_ivoryVampire"] = {
        "Los corazones rojos pueden recolectarse aún con la vida llena.",
        "Cada 1/2 corazón rojo recolectado otorga {{roll1}}% velocidad, lágrimas y daño por {{roll2}} segundos,",
        "apilable hasta 8 veces.",
        "El temporizador de este efecto se pausa mientras estés en una habitación sin enemigos."
    },
    ["aforge_mod_desc_nimbleTwins"] = {
        "+{{roll1}}% lágrimas.",
        "Al golpear enemigos, adicionalmente dispara una lágrima roja lenta y una lágrima azul rápida hacia ellos.",
        "Estas lágrimas infligen {{roll2}}% de tu daño.",
        "Gana +3% daño por 2 segundos al golpear enemigos con la lágrima roja, apilable hasta {{roll3}}%.",
        "Gana +3% lágrimas por 2 segundos al golpear enemigos con la lágrima azul, apilable hasta {{roll3}}%."
    },
    ["aforge_mod_desc_crimsonAltruist"] = {
        "+{{roll1}}% daño al usar una máquina de donación de sangre, hasta 100%.",
        "+{{roll2}} lágrimas cada {{roll3}} usos de máquinas de donación de sangre.",
        "Reduce estos bonus a la mitad al entrar a un nuevo piso."
    },
    ["aforge_mod_desc_quicksilver"] = {
        "Presiona el botón de Tirar para realizar un Bloqueo. Bloquear para hasta 1 golpe entrante si es usado en el momento justo.",
        "Bloquear tiene un enfriamiento de {{roll1}} segundo(s). Solo puedes bloquear golpes provenientes de monstruos.",
        "Al bloquear un golpe:",
        "- Tu siguiente golpe inflige el doble de daño. Esto no se apila.",
        "- Gana +{{roll2}}% lágrimas y velocidad por 3 segundos."
    },
    ["aforge_mod_desc_beastbane"] = {
        "+{{roll1}}% daño infligido a jefes.",
        "Derrotar a un jefe otorga +{{roll2}}% daño permanente, una vez cada 2 pisos."
    },
    ["aforge_mod_desc_gravitas"] = {
        "Al golpear a enemigos a más de 2 casillas de ti, {{roll1}}% chance de disparar 3 lágrimas persecutoras que",
        "infligen {{roll2}}% de tu daño. 0.5 segundos de enfriamiento.",
        "Al golpear enemigos con las lágrimas persecutoras, 3% chance de obtener Doblador de Cucharas para la",
        "habitación actual."
    },
    ["aforge_mod_desc_borealSpear"] = {
        "{{roll1}}% chance al golpear enemigos de ralentizarlos por 3 segundos.",
        "Cuando golpeas a un enemigo ralentizado que esté a más de {{roll2}} casillas de ti, +1% chance de congelarlo.",
        "Golpear a enemigos repetidamente aumenta la chance de congelarlos (la chance es individual a cada enemigo)."
    },
    ["aforge_mod_desc_viperStinger"] = {
        "{{roll1}}% chance al golpear enemigos de paralizarlos por 2 segundos.",
        "Duplica la chance y duración contra enemigos no-jefes envenenados.",
        "Matar a un enemigo paralizado libera una nube tóxica por 4 segundos que envenena y daña a enemigos cercanos",
        "por {{roll2}}% de tu daño."
    },
    ["aforge_mod_desc_consecrator"] = {
        "Gana +{{roll1}}% daño al entrar a una habitación del diablo, hasta {{roll2}}%.",
        "Gana +{{roll1}}% lágrimas al entrar a una habitación del ángel, hasta {{roll2}}%.",
        "Estos bonus se reducen por la mitad al completar una habitación del jefe.",
        "+{{roll3}}% chance de encontrar habitaciones del diablo/ángel."
    },
    ["aforge_mod_desc_verdantGreen"] = {
        "{{roll1}}% chance al golpear de crear una nube venenosa.",
        "Esta chance se aumenta directamente con tu estadística de lágrimas, hasta +5%.",
        "Las nubes venenosas envenenan a los enemigos en ella por 4 segundos. Si estos ya estan envenenados, la nube les inflige",
        "{{roll2}}% de tu daño."
    },
    ["aforge_mod_desc_lostCoralTrident"] = {
        "Comienza con el efecto de Neptunus.",
        "-{{roll1}}% daño."
    },
    ["aforge_mod_desc_oceanicMight"] = {
        "Comienza con el efecto de Aquarius.",
        "Los charcos creados por ti infligen {{roll1}}% más daño.",
        "Golpear a enemigos que estén sobre charcos creados por ti tiene un 10% chance de causar una explosión de agua,",
        "infligiendo 25 de daño a enemigos cercanos. 2.5 segundos de enfriamiento.",
        "La chance de activar la explosión se vuelve 40% contra enemigos voladores."
    },
    ["aforge_mod_desc_taleEnder"] = {
        "+{{roll1}}% daño infligido contra enemigos con la vida llena.",
        "{{roll2}}% chance de matar instantáneamente al primer enemigo no-jefe que golpees en cada habitación.",
        "Al activarse este efecto, reduce su chance por la mitad. Esta chance se reinicia al entrar a un nuevo piso."
    },
    ["aforge_mod_desc_crimsonReaper"] = {
        "Al golpear a un enemigo con la vida llena, aplicale sangrado por {{roll1}} segundos.",
        "Duplica esta duración contra jefes.",
        "Los enemigos sangrantes que tengan menos de {{roll2}}% de vida reciben más daño, basado en su vida faltante",
        "por debajo de {{roll2}}%."
    },
    ["aforge_mod_desc_mobripper"] = {
        "El ataque circular del modificador implícito ahora inflige {{roll1}}% del daño del golpe original.",
        "Si el ataque circular mata a cualquier enemigo o golpea a un jefe, asusta a todos los enemigos golpeados por 3 segundos.",
        "-{{roll2}}% daño."
    },
    ["aforge_mod_desc_starsteelBroadaxe"] = {
        "+2% lágrimas por la habitación actual al golpear a enemigos sangrantes, hasta {{roll1}}%.",
        "Golpear a un jefe reduce su enfriamiento de efectos de estado en 0.5 segundos."
    },
    ["aforge_mod_desc_ancientRunicChopper"] = {
        "+{{roll1}}% daño permanente al usar una Runa, hasta {{roll2}}%.",
        "+{{roll3}}% lágrimas por 10 segundos al usar una Runa o Fragmento de Runa."
    },
    ["aforge_mod_desc_circuitSplitter"] = {
        "Golpear a un enemigo sangrante crea un anillo láser que lo persigue, dañando a otros enemigos cercanos",
        "por {{roll1}}% de tu daño por tick, máximo 5 de daño.",
        "Los anillos láser duran {{roll2}} segundos y permanecen en su lugar si el enemigo a perseguir muere.",
        "Hasta 3 anillos láser pueden estar presentes en la habitación simultáneamente."
    },
    ["aforge_mod_desc_berserkerWrath"] = {
        "Activa Berserk! al entrar a una habitación con monstruos, una vez por piso.",
        "Entrar a una habitación del jefe desactiva el efecto de Berserk!.",
        "+{{roll1}} segundos a la duración de Berserk!."
    },
    ["aforge_mod_desc_frozenTerror"] = {
        "Al golpear enemigos sangrantes, {{roll1}}% chance de ralentizarlos por 3 segundos.",
        "Al golpear enemigos ralentizados a {{roll2}} casilla(s) de ti, realiza un ataque circular alrededor tuyo",
        "que puede congelar a enemigos ralentizados. 1.5 segundos de enfriamiento.",
        "El ataque circular inflige {{roll3}}% de tu daño."
    },
    ["aforge_mod_desc_stormAdvance"] = {
        "Comienza con el efecto de 120 Voltios.",
        "Cada {{roll1}} golpes contra enemigos, lanza un abanico de lágrimas eléctricas hacia el último enemigo golpeado.",
        "Estas lágrimas infligen un {{roll2}}% de tu daño.",
        "Este efecto tiene un enfriamiento de 2 segundos."
    },
    ["aforge_mod_desc_quillRain"] = {
        "Comienza con el efecto de Leche de Soya.",
        "-{{roll2}}% daño infligido a enemigos a {{roll1}} casillas de ti."
    },
    ["aforge_mod_desc_gildedSeeker"] = {
        "Comienza con el efecto de Cabeza de Keeper.",
        "+1% daño al recolectar cualquier moneda si hay monstruos en la habitación, hasta {{roll1}}%.",
        "Este bonus se reduce a la mitad al completar una habitación."
    },
    ["aforge_mod_desc_twistedOakstring"] = {
        "Al golpear enemigos a más de {{roll1}} casillas de ti, crea una lágrima persecutora, espectral y causadora de miedo",
        "en su posición. 0.5 segundos de enfriamiento.",
        "Esta lágrima inflige {{roll2}}% del daño del golpe original."
    },
    ["aforge_mod_desc_bruteOnslaught"] = {
        "Al usar un objeto activo, por cada carga usada, aumenta el daño de los siguientes 5 golpes en {{roll1}}%.",
        "+{{roll2}}% lágrimas por 5 segundos luego de usar un objeto activo."
    },
    ["aforge_mod_desc_divineMessenger"] = {
        "Al golpear a un enemigo a más de 3 casillas de ti por primera vez en la habitación, crea un aura sagrada en",
        "su posición.",
        "El aura sagrada dura por el resto de la habitación, lentamente se mueve hacia ti, y otorga +1 daño, +0.4 lágrimas,",
        "y +{{roll1}}% daño y lágrimas mientras estes dentro."
    },
    ["aforge_mod_desc_volatileArbalest"] = {
        "{{roll1}}% chance de causar una pequeña explosión al golpear a enemigos a más de 2.5 casillas de ti,",
        "infligiendo {{roll2}}% de tu daño. 0.5 segundos de enfriamiento."
    },
    ["aforge_mod_desc_avelyn"] = {
        "Al disparar, lanza 3 lágrimas rápidas hacia un enemigo cercano. {{roll1}} segundos de enfriamiento.",
        "Estas lágrimas infligen {{roll2}}% de tu daño, y adicionalmente usan tu velocidad de disparo como un",
        "multiplicador de daño, si es mayor a 1."
    },
    ["aforge_mod_desc_preciseSeeker"] = {
        "Cada segundo, marca a un enemigo aleatorio si es posible, priorizando jefes.",
        "Cada {{roll1}} segundos, dispara una veloz lágrima peforante y espectral contra el enemigo marcado.",
        "Esta lágrima inflige {{roll2}}% de tu daño, hasta 60."
    },
    ["aforge_mod_desc_magefist"] = {
        "Puedes imprimir hasta 3 modificadores en esta arma.",
        "El costo de impresión se reduce a la mitad para esta arma.",
        "+{{roll1}}% a todas las estadísticas por modificador presente en esta arma."
    },
    ["aforge_mod_desc_ironhand"] = {
        "Posee 3 modificadores de arma implícitos aleatorios.",
        "No se pueden imprimir modificadores en esta arma.",
        "+{{roll1}}% a todas las estadísticas cada 10 de filo en esta arma."
    },
    ["aforge_mod_desc_metamorphicClaw"] = {
        "Imita el efecto de un arma antigua aleatoria (excepto guanteletes).",
        "El efecto elegido cambia en cada piso.",
        "Nivel de mejora antigua usado para los efectos: {{roll1}}."
    },
    ["aforge_mod_desc_mightyPurifier"] = {
        "Paraliza a muertos vivientes por {{roll1}} segundo(s) al golpearlos por primera vez.",
        "{{roll2}}% chance de bloquear daño proveniente de muertos vivientes.",
        "+{{roll3}}% daño infligido a muertos vivientes."
    },
    ["aforge_mod_desc_chaoticTumult"] = {
        "La onda implícita ahora activa un efecto de estado aleatorio al golpear por el doble de duración, en vez de parálisis.",
        "Al golpear a un enemigo con efecto de estado, 15% chance de dispersar ese efecto a un enemigo aleatorio",
        "a {{roll1}} casillas del enemigo golpeado.",
        "+1% daño para la habitación actual al matar enemigos con efectos de estado, hasta {{roll2}}%."
    },
    ["aforge_mod_desc_firestarter"] = {
        "{{roll1}}% chance de infligir quemadura por 5 segundos al golpear.",
        "La chance se triplica para las explosiones.",
        "Matar a un enemigo con quemadura tiene un 35% chance de causar una explosión que inflige {{roll2}}% de",
        "tu daño, limitado a 50.",
        "Recibir daño de un enemigo con quemadura te otorga +15% velocidad por 3 segundos."
    },
    ["aforge_mod_desc_colossalMaul"] = {
        "Duplica el daño de la onda implícita.",
        "+{{roll3}}% tamaño de la onda implícita.",
        "El daño de la onda implícita ahora puede afectar a enemigos sin importar si están paralizados.",
        "+{{roll1}} segundos al enfriamiento de la onda implícita.",
        "-{{roll2}}% velocidad y lágrimas mientras la onda implícita este en enfriamiento."
    },
    ["aforge_mod_desc_tollingBell"] = {
        "Comienza con el efecto de Leo.",
        "Cuando ciertos sonidos ocurran, gana un efecto temporal:",
        "- Explosiones: +{{roll1}}% velocidad por 3 segundos.",
        "- Piedras rotas: +{{roll2}}% daño por 4 segundos.",
        "- Puerta del jefe cerrándose: +{{roll3}}% lágrimas por 7 segundos."
    },
    ["aforge_mod_desc_snakebite"] = {
        "El efecto implícito ahora dispara 3 lágrimas envenenantes al golpear.",
        "Estas infligen {{roll1}}% más daño a enemigos ya envenenados."
    },
    ["aforge_mod_desc_devilTongue"] = {
        "Las lágrimas del efecto implícito petrifican a los enemigos golpeados por {{roll1}} segundo(s).",
        "Los enemigos ya petrificados reciben quemadura por 3 segundos en cambio.",
        "El enfriamiento del efecto implícito es aumentado a 3 segundos.",
        "+{{roll2}}% daño contra enemigos con quemadura."
    },
    ["aforge_mod_desc_azurebinder"] = {
        "Las lágrimas del efecto implícito obtienen el efecto de Lentilla Perdida y Mini-Planeta.",
        "Las lágrimas del efecto implícito vuelan por más tiempo.",
        "+{{roll1}}% daño por la habitación actual por lágrima bloqueada, hasta {{roll2}}%."
    },
    ["aforge_mod_desc_sacredScourge"] = {
        "Luego de eliminar a un muerto viviente, por {{roll1}} segundos gana los siguientes efectos:",
        "   - El efecto implícito dispara 2 lágrimas adicionales.",
        "   - Las lágrimas del efecto implícito vuelan por más tiempo.",
        "   - Reduce el enfriamiento del efecto implícito por la mitad."
    },


    ["ui_ancwepBounties"] = "Misiones De Armas Antiguas",
    ["ui_bounty"] = "Misión",
    ["ui_selType"] = "Tipo seleccionado",
    ["ui_leftRightSel"] = "Izquierda/Derecha para seleccionar",
    ["ui_noCurrentBounty"] = "No hay misión actual",
    ["ui_generateBounty1"] = "Selecciona el tipo de arma y manten Asignar por 1 segundo para generar",
    ["ui_generateBounty2"] = "una misión. La misión generada escogerá un arma antigua aleatoria del",
    ["ui_generateBounty3"] = "tipo seleccionado como recompensa.",
    ["ui_generateBountyCost"] = "Generar/rerollear una misión cuesta {{obolCoist}} oboles arcanos.",
    ["ui_bountyObjectivesTip"] = "Objetivos (presiona TAB para ver los modificadores del arma antigua)",
    ["ui_allocFinishBounty"] = "Mantén Asignar por 1 segundo al terminar para completar.",
    ["ui_respecAbandonBounty"] = "Mantén Respec por 1 segundo para abandonar esta misión.",
    ["ui_cannotProgBounty"] = "La partida actual no puede progresar esta misión (no es una expedición).",
    ["ui_weaponModBountyTip"] = "Modificadores del Arma (presiona TAB para ver los objetivos)"
}