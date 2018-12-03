shader = dxCreateShader('shader.fx')
terrain = {
  ['img/1.jpg'] = {'grassgrn256','brngrss2stonesb','grass128hv_blend_','sfn_rockgrass1','sfn_rock2','golf_fairway2','veg_bevtreebase','lodgrass_128hv','desgrassbrnsnd','sfn_rockgrass10','ws_football_lines2','bow_church_dirt_to_grass_side_t','sandstonemixb','grasspatch_64hv','desmuddesgrsblend_sw','grasstype7','grasspave256','trainground1','scumtiles3_lae','grassgrnbrnx256','forestfloorblendb','forestfloor256mudblend','hiwayinsideblend1_256','greyground2sand','grassdirtblend','ws_patchygravel','grasstype4_staw','grassshort2long256','grassdeep256','forestfloor4','grasstype3dirt','grassdeep256','grass_lawn_128hv','tenniscourt1_256','hiwayinsideblend2_256','hiwayblend1_256','desegravelgrassroadla','dirtblendlit','sl_sfngrssdrt01','sl_sfngrass01','golf_greengrass','golf_fairway3','golf_fairway1','golf_heavygrass','golf_hvygras_cpark','grass_dirt_64hv','grassdead1blnd','pavebsandend','grass_dry_64hv','grassdeadbrn256','grass10_stones256','sjmlahus28','sjmscorclawn3','grasstype510','grasstype510_10','desmudgrass','grass10dirt','roadblendcunt','ws_patchygravel','brngrss2stones','grasstype4-3','grasstype3','grasstype5_desdirt','dirtkb_64hv','desertgryard256grs2','des_dirt2grass','des_dirt1','grass','pavemiddirt_law','hllblf2_lae','forestfloorgrass','des_dirt1_glfhvy','hiwayinside5_256','des_dirt1_grass','grass_128hv','ffbranch_mountdirt','desmud2forstfloor','forestfloorblend','cw2_mountdirt2forest','rocktbrn128blnd','forest_rocks','desmud','grass10dirt','con2sand1b','vgsroadirt1_256','vgsroadirt2_256','con2sand1a','desgrassbrn_grn','des_dirt2gygrass','ws_traingravelblend','sw_stones','sw_sand','sw_crops','newcrop3','sjmscorclawn','dirtgaz64b','bow_church_grass_gen','hiwayinside4_256','grasstype10_4blend','forestfloor256_blenddirt','desertstones256forestmix','dirt64b2','grifnewtex1x_las','grassdry_128hv','grass4dirtytrans','bow_church_dirt','grasstype5_4','sw_grass01a','sw_grassb01','sw_grass01d','sw_dirt01','sfn_rocktbrn128','sfn_rockhole','sfncn_rockgrass3','sfn_grass1','des_dirtgrassmixbmp','grasstype4','grasstype4_forestblend','forestfloor256','grasstype4_10','grasstype10','des_dirtgrassmix_grass4','grass4dirty','dt_road2grasstype4','sw_grass01','grassdead1','bow_church_grass_alt','desertstones256','forestfloorblendded','grasstype4blndtodirt','grasstype4_mudblend','desertgryard256','desgreengrassmix','desertgravelgrass256','sw_stonesgrass','desgreengrass','yardgrass1', 'grassgrnbrn256', 'des_grass2scrub', 'des_scrub1_dirt1b', 'des_scrub1_dirt1a', 'vgs_rockbot1a', 'vgs_rockmid1a', 'des_ripplsand','des_rocky1_dirt1','des_scrub1_dirt1','des_scrub1','desstones_dirt1','des_dirt2dedgrass','des_dirt2','des_dirtgravel','des_dirt2blend','des_rocky1','des_roadedge1','des_roadedge2','des_panelconc','des_oldrunwayblend','desertstones256','grasstype5','grasstype5_dirt','desgrassbrn','des_grass2dirt1','des_yelrock','cw2_mountdirt','hiway2sand1a','hiwaygravel1_256','hiwaygravel1_lod','hiwayinside2_256','des_oldrunway','ws_rotten_concrete1','cw2_mountrock','cw2_mountdirtscree','grass4_des_dirt2','forestfloorbranch256','forestfloor3','des_dirt2grgrass','forestfloor3_forest','forestfloor_sones256','sw_sandgrass','sw_sandgrass4','sw_rockgrassb1','sw_rockgrass1','sw_rockgrassb2','des_dirt2 trackl','des_dirtgrassmixb','des_dirtgrassmixc','desertstones256grass','desmuddesgrsblend','hiwayinsideblend3_256','grasslong256','sf_garden3','golfcourselod_sfs_b'},
  ['img/5.jpg'] = {'tar_venturasjoin','crossing_law','desert_1linetar','desert_1line256','dt_roadblend','tar_1line256hvgtravel','tar_1line256hvlightsand','snpdwargrn1','tar_1line256hvblenddrtdot','tar_1line256hvblenddrt','tar_1line256hvblend2','tar_freewyleft','tar_freewyright','tar_lineslipway','lod_des_road1','des_1line256','des_1lineend','des_1linetar','tar_1line256hv','tar_1line256hvblend','roaddgrassblnd','tar_1linefreewy'},
  ['img/20.png'] = {'grassbrn2rockbrng2','mudyforest256','ws_sub_pen_conc2','mountainskree_stones256','rocktq128blender','concretemanky','des_dirt2trackr','carpark_128','sf_pave2','stones256128','bow_abpave_gen','sf_pave3','macpath_lae','sf_pave5','drvin_ground1','obhilltex1','des_dustconc','des_dirt2track','cos_hiwayout_256','con2sand1c','hiwayinside3_256','hiwayoutside_256','concretedust2_256128','stormdrain6','des_dirt2stones','vgs_rockwall01_128','des_dam_wall','sandgrnd128','vgs_shopwall01_128','grassbrn2rockbrn','parking2plain','parking2','rocktbrn128','rocktbrn128blndlit','cuntroad01_law','fancy_slab128','cst_rock_coast_sfw','venturas_fwend','desgrasandblend','cw2_mounttrailblank','rocktq128_forestblend2','rocktq128','desclifftypebs','cs_rockdetail2','cuntbrnclifftop','cuntbrncliffbtmbmp','cunt_botrock','stones256','grasstype4blndtomud'},
  ['img/73.png'] = {'waterclear256','newaterfal1_256'},
  ['img/40.png'] = {'sm_bark_light'},
  ['img/35.png'] = {'cloudmasked'},
  ['img/21.png'] = {'rocktq128_dirt','newrockgrass_sfw','rocktq128_forestblend','grassbrn2rockbrng','desclifftypebsmix','lasclifface','des_dirt1grass','cunt_toprock','desertgravelgrassroad','rocktq128_grass4blend'},
  ['img/13.jpg'] = {'ws_freeway3blend','ws_freeway3','vegasdirtyroad2_256','vegasroad3_256','sf_road5','sf_junction5','vegastriproad1_256','vegasroad2_256','hiwayend_256','hiwaymidlle_256','vegasroad1_256','vegasdirtyroad1_256','cos_hiwaymid_256','sl_freew2road1','roadnew4_512','roadnew4_256','dt_road','sl_roadbutt1','craproad1_lae','snpedtest1','roadnew4blend_256','snpedtest1blend','craproad7_lae7'},
  ['img/24.jpg'] = {'des_crackeddirt1','des_redrock1','des_redrock2','cw2_mounttrail'},
  ['img/81.png'] = {'greyground256sand','boardwalk_la','indund_64','rodeo3sjm','gb_nastybar08'},
  ['img/2.jpg'] = {'tar_1line256hvtodirt','dirttracksgrass256','grifnewtex1b','des_dirttrack1r'},
  ['img/53.png'] = {},
  ['img/32.png'] = {'sw_farmroad01','desmudtrail2','desmudtrail3','cw2_weeroad1','dirttracksforest','desmudtrail','dirttracksgrass256'},
  ['img/33.png'] = {'desgreengrasstrckend'},
  ['img/18.png'] = {},
  ['img/78.png'] = {'ws_alley_conc1','beachwalk_law','boardgate_law','stormdrain4_nt','studwalltop_law','block','stormdrain2_nt','block2','highshopwall1256','ws_sub_pen_conc','concreteblock_256','stormdrain5_nt','stonewall2_la','ws_freeway2','des_facmetal','des_factower','des_facmetalsoild','block2_high','des_dam_conc','ws_woodenscreen1','concretewall22_256','pinkpave'},
  ['img/79.png'] = {'64322938','sl_pavebutt1','hilcouwall2','bow_smear_cement','sjmhoodlawn4','backalley1_lae','sidewgrass4','sidewgrass3','sidewgrass_fuked','sidewgrass5','sidewgrass2','sidewgrass1','grassdry_path_128hv','grass_concpath2','laroad_offroad1','trainground3','ws_nicepave','nicepavegras_la','sidelatino1_lae','hiwayinside_256','blendpavement2b_256','blendpavement2_256','vegaspavement2_256','vegasdirtypave1_256','vegasdirtypave2_256','vegasdirtypaveblend1','vegasdirtypaveblend2','sjmhoodlawn42','dockpave_256','pierplanks_128','sf_pave6','newpavement','ws_oldpainted2','stonesandkb2_128','sf_pave4','sidewalk4_lae','cos_hiwayins_256','pavebsand256','kbpavementblend','kbpavement_test','sl_pavebutt2','laroad_centre1','craproad5_lae','craproad6_lae','pavebsand256grassblended','sjmhoodlawn41','sjmhoodlawn42b','easykerb','sandypath_law'},
  ['img/14.jpg'] = {'ws_traintrax1'},
  ['img/15.jpg'] = {'trainground2','concrete_64hv','concretenewb256','conchev_64hv','rail_stones256','sw_traingravelb1','ws_traingravel','heliconcrete','metpat64'},
  ['img/3.jpg'] = {'des_redrockmid','rockwall2_lae2','rocktbrn_dirt2','rock_country128','golf_grassrock'},
  ['img/face.png'] = {'cj_ped_head'},
  ['img/34.jpg'] = {'txgrass0_1','sm_des_bush1','sm_des_bush2','sm_des_bush3','txgrass1_1'},
  ['img/4.jpg'] = {'des_redrockbot','rockwall1_lae2','blendrock2grgrass'},
  ['img/19.png'] = {'des_dirttrackx'},
  ['img/64.png'] = {'ws_rottenwall','ws_sandstone1','ws_altz_wall10','3a516e58','sam_camo','mp_brick_128','mp_guardtowerthin_128','bonyrd_skin2'},
  ['img/concrete_21.jpg'] = {'rodeo3sjm','dt_road_stoplinea','plaintarmac1','ston_asfalt_iov_old_01','ws_sub_pen_conc3','ws_tunnelwall2','ws_airpt_concrete'},
  ['img/ws_wangcar1.jpg'] = {'ws_wangcar1'},
  ['img/ws_wangcar2.jpg'] = {'ws_wangcar2'},
  ['img/tree19Mi.png'] = {'tree19Mi','newtreeleaves128','newtreed256'},
  ['img/treeleaves1.png'] = {'treeleaves1'},
  ['img/txgrassbig0.png'] = {'txgrassbig0'},
  ['img/txgrassbig1.png'] = {'txgrassbig1'},
  ['img/bloodpool_64a.png'] = {'bloodpool_64a'},
  ['img/2123213.jpg'] = {},
  ['img/image022.jpg'] = {'bonyrd_skin1','redmetal','des_bytower1','alumox64','rusta256128','block2_low','dish_panel_a','dish_panel_b','dish_roundbit_a','dish_panel_c','metal1_128','des_plyon1'},
  ['img/22.png'] = {'golf_gravelpath','grass_path_128hv','des_quarryrd','des_quarryrdr','des_quarryrdl','cw2_mounttrail','cw2_mountroad','des_dirttrack1'},
  ['img/2.jpg'] = {'des_dirttrack1','des_dirttrackl'},
  ['img/52.png'] = {'cw2_mountdirt2grass'},
  ['img/58.png'] = {'ws_sub_pen_conc3','dt_road_stoplinea','curb_64h','ws_whitewall2_bottom','plaintarmac1','greyground256','bow_abattoir_conc2','lasunion994','crossing_law2'},
  ['img/98.png'] = {'sandnew_law'},
  ['img/42.png'] = {'elm_treegrn2'}
}

local textures = {}
local shader = {};

addEventHandler('onClientResourceStart', resourceRoot,
function()
  for i,v in pairs(terrain)do
    textures[i] = dxCreateTexture(i)
    if(textures[i])then
      shader[i] = dxCreateShader('shader.fx')
      dxSetShaderValue(shader[i], 'gTexture', textures[i])
      for _,textureName in ipairs(v)do
        engineApplyShaderToWorldTexture(shader[i], textureName)
      end
    end
  end
end)