-- by vet_ozm

local textureCache = {};
local streamedObjects = {};
local pModels = {};

setCloudsEnabled(false);
debug.sethook(nil);

local function getResourceSize(path)
	if not (fileExists(path)) then return 0; end;

	local file = fileOpen(path);
	local size = fileGetSize(file)

	fileClose(file);
	return size;
end

local function requestTexture(model, path)
	local txd = textureCache[path];

	if not (txd) then
		local size = getResourceSize(path);
		if (size == 0) then return false; end

		txd = engineLoadTXD(path, false);

		if not (txd) then
			return false;
		end

		textureCache[path] = txd;
	end
	return txd;
end

local function loadModel(model)
	if (model.loaded) then return true; end

	if (model.super) then
       local superModel = pModels[model.super];
       if (superModel) then
		    if not (loadModel(superModel)) then
			    return false;
		    end
       end
	end

	engineReplaceModel(model.model, model.id);
	engineReplaceCOL(model.col, model.id);

	model.loaded = true;
	return true;
end

local function freeModel(model)
	if not (model.loaded) then return true; end

	engineRestoreModel(model.id);
	engineRestoreCOL(model.id);

	model.loaded = false;
	if (model.super) then
       local superModel = pModels[model.super];
       if (superModel) then
		    freeModel(superModel);
       end
	end
end

local function modelStreamOut ()
	local pModel = pModels[getElementModel(source)];

	if not (pModel) then return end;

	if (pModel.lodID) then return true; end

	if (pModel.isRequesting == 2) then
		pModel.isRequesting = 1;
		return true;
	elseif (pModel.isRequesting == 3) then
		pModel.isRequesting = 4;
		return true;
	elseif (pModel.isRequesting) then return true; end

	pModel.numStream = pModel.numStream - 1;

	if (pModel.numStream == 0) then
		pModel.isRequesting = 3;

		freeModel(pModel);

		pModel.isRequesting = false;
	end
end

local function modelStreamIn ()
	local pModel = pModels[getElementModel(source)];

	if not (pModel) then return end;

	if (pModel.lodID) then return true; end

	if (pModel.isRequesting == 1) then
		pModel.isRequesting = false;
		return true;
	elseif (pModel.isRequesting) then return true; end

	pModel.numStream = pModel.numStream + 1;

	if not (pModel.numStream == 1) then return true; end

	pModel.isRequesting = 2;

	if not (loadModel(pModel)) then
		setElementInterior(source, 123);
		setElementCollisionsEnabled(source, false);
	end

	if (pModel.isRequesting == 2) then
		outputDebugString("invalid model request '"..pModel.name.."'");
		freeModel(pModel);
		pModel.isRequesting = false;

		pModel.numStream = 0;
	end
end

function loadModels ()
	local pModel, pTXD, pColl, pTable;

	pTable={
		{ 3981, "LODsh1-1", "buildsLOD", 3000, 3980 },
		{ 3983, "LODsh1-2", "buildsLOD", 3000, 3982 },
		{ 3985, "LOD_9flruk3", "gavno_LOD", 3000, 3984 },
		{ 3987, "LODr_whtile", "gavno_LOD", 3000, 3986 },
		{ 3993, "LODnomag", "gavno_LOD", 3000, 3990 },
		{ 3997, "LODunimag_dosa", "buildsLOD", 3000, 3996 },
		{ 3999, "LOD16flr", "gavno_LOD", 3000, 3998 },
		{ 4001, "LOD_5floor_3", "buildsLOD", 2999, 4000 },
		{ 4004, "LOD_674", "buildsLOD", 3000, 4002 },
		{ 4008, "LOD_hrush_6-7", "buildsLOD", 3000, 4006 },
		{ 4011, "LOD_5floor_1", "superLOD", 3000, 4010 },
		{ 4013, "LOD_5floor_2", "superLOD", 3000, 4012 },
		{ 4018, "LOD_cerkovs", "LOrus_cerkovs", 1500, 4017 },
		{ 4021, "LOD_resto", "LORUSRUS", 1500, 4019 },
		{ 4023, "LOD_medkol", "LORUSRUS", 1500, 4022 },
		{ 4028, "LOD_counthou01", "LORUS_counthou0", 1500, 4024 },
		{ 4029, "LOD_counthou02", "LORUS_counthou0", 1500, 4025 },
		{ 4030, "LOD_counthou03", "LORUS_counthou0", 1500, 4026 },
		{ 4031, "LOD_counthou04", "LORUS_counthou0", 1500, 4027 },
		{ 4033, "LOD_tep_stella", "LORUSRUS", 1500, 4032 },
		{ 4039, "LOD_shinmon01", "LOD_shinmon0", 1500, 4035 },
		{ 4041, "LOD_shinmon03", "LOD_shinmon0", 1500, 4037 },
		{ 4059, "LOD_selomag02", "LOD_selomag0", 1500, 4055 },
		{ 4060, "LOD_selomag03", "LOD_selomag0", 1500, 4056 },
		{ 4065, "LOD_2flrbld01", "LOD_2flrbld0", 1500, 4062 },
		{ 4066, "LOD_2flrbld02", "LOD_2flrbld0", 1500, 4063 },
		{ 4069, "rus_woodpart01", "rus_woodpart01", 150, 5536 },
		{ 4071, "LOD_kolhoz", "LOD_kolhoz", 1500, 4070 },
		{ 4075, "LOD_transsklad", "LOD_transsklad", 1500, 4073 },
		{ 4078, "LOD_barge", "LOD_barge", 1500, 4077 },
		{ 4087, "LOD_neft", "LOD_neft", 1500, 4085 },
		{ 4095, "gen_trashers", "gen_trashers", 150, 4401 },
		{ 4098, "LOD_cli_ap", "grnd", 1500, 4097 },
		{ 4125, "LOD_zzavodbl1", "lozvvd", 1500, 4119 },
		{ 4126, "LOD_zzavodbl2", "lozvvd", 1500, 4122 },
		{ 4127, "LOD_zzavodbl3", "LOZVVD", 1500, 4123 },
		{ 4128, "LOD_zzavodbl4", "LOZVVD", 1500, 4124 },
		{ 4135, "LOD_treepack", "LOD_treepack", 800, 4134 },
		{ 4141, "LOD_MSTAL01", "LOD_CPS", 1500, 4136 },
		{ 4142, "LOD_MSTAL02", "LOD_CPS", 1500, 4137 },
		{ 4143, "LOD_MSTAL03", "LOD_CPS", 1500, 4138 },
		{ 4144, "LOD_MSTAL04", "LOD_CPS", 1500, 4139 },
		{ 4150, "LOD_newmost", "LOD_newmost", 1500, 4148 },
		{ 4152, "LOD_stsud", "LOD_CPS", 1500, 4151 },
		{ 4154, "LOD_stsuU", "LOD_CPS", 1500, 4153 },
		{ 4158, "LOD_TOVARISH", "LOD_CPS", 1500, 4155 },
		{ 4159, "LOD_TOVARISHD", "LOD_CPS", 1500, 4157 },
		{ 4162, "LOD_THRA", "LOD_CPS", 1500, 4160 },
		{ 4164, "LOD_THRB", "LOD_CPS", 1500, 4161 },
		{ 4167, "LOD_LENIN", "LOD_CPS", 1500, 4166 },
		{ 4177, "LOD_SQRA", "LOD_CPS", 1500, 4169 },
		{ 4178, "LOD_SQRB", "LOD_CPS", 1500, 4176 },
		{ 4235, "LOD_9FLE1_01", "LOD_HRHN", 1500, 4208 },
		{ 4236, "LOD_9FLM_01", "LOD_HRHN", 1500, 4210 },
		{ 4237, "LOD_9FLE2_01", "LOD_HRHN", 1500, 4209 },
		{ 4238, "LOD_9FLE1_02", "LOD_HRHN", 1500, 4224 },
		{ 4239, "LOD_9FLM_02", "LOD_HRHN", 1500, 4223 },
		{ 4347, "LOD_9FLE2_02", "LOD_HRHN", 1500, 4211 },
		{ 4375, "LOD_9FLE1_03", "LOD_HRHN", 1500, 4228 },
		{ 4376, "LOD_9FLM_03", "LOD_HRHN", 1500, 4226 },
		{ 4377, "LOD_9FLE2_03", "LOD_HRHN", 1500, 4225 },
		{ 4378, "LOD_9FLE1_04", "LOD_HRHN", 1500, 4234 },
		{ 4379, "LOD_9FLM_04", "LOD_HRHN", 1500, 4232 },
		{ 4380, "LOD_9FLE2_04", "LOD_HRHN", 1500, 4229 },
		{ 4385, "LOD_5FLN02", "LOD_HRHN", 1500, 4381 },
		{ 4386, "LOD_5FLN03", "LOD_HRHN", 1500, 4382 },
		{ 4387, "LOD_5FLN04", "LOD_HRHN", 1500, 4383 },
		{ 4388, "LOD_5FLN01", "LOD_HRHN", 1500, 4384 },
		{ 4393, "LOD_ADMBLD02", "LOD_HRHN", 1500, 4389 },
		{ 4394, "LOD_ADMBLD03", "LOD_HRHN", 1500, 4390 },
		{ 4395, "LOD_ADMBLD04", "LOD_HRHN", 1500, 4391 },
		{ 4396, "LOD_ADMBLD01", "LOD_HRHN", 1500, 4392 },
		{ 4411, "LOD_BFN02", "LOD_ATPCS", 1500, 4398 },
		{ 4412, "LOD_BFN03", "LOD_ATPCS", 1500, 4399 },
		{ 4413, "LOD_BFN04", "LOD_ATPCS", 1500, 4400 },
		{ 4414, "LOD_BFN01", "LOD_ATPCS", 1500, 4397 },
		{ 4415, "LOD_KPP02", "LOD_ATPCS", 1500, 4402 },
		{ 4416, "LOD_KPP01", "LOD_ATPCS", 1500, 4401 },
		{ 4417, "LOD_ARPG02", "LOD_ATPCS", 1500, 4408 },
		{ 4418, "LOD_ARPG03", "LOD_ATPCS", 1500, 4409 },
		{ 4419, "LOD_ARPG01", "LOD_ATPCS", 1500, 4410 },
		{ 4421, "LOD_BIG_FUCKLND", "LOGRD", 1500, 4420 },
		{ 4439, "LOD_GRP03", "LOD_ATPCS", 1500, 4437 },
		{ 4440, "LOD_ATBLD01", "LOD_ATPCS", 1500, 4435 },
		{ 4441, "LOD_ATBLD02", "LOD_ATPCS", 1500, 4433 },
		{ 4442, "LOD_ATBLD03", "LOD_ATPCS", 1500, 4434 },
		{ 4443, "LOD_GRP01", "LOD_ATPCS", 1500, 4438 },
		{ 4444, "LOD_GRP02", "LOD_ATPCS", 1500, 4436 },
		{ 4453, "LOD_HLEKOM", "LOD_HRHN", 1500, 4452 },
		{ 4458, "LOD_FBARN03", "LOD_ATPCS", 1500, 4455 },
		{ 4460, "LOD_FBARN01", "LOD_ATPCS", 1500, 4457 },
		{ 4461, "LOD_FBARN02", "LOD_ATPCS", 1500, 4454 },
		{ 4462, "rus_mntibu", "rus_cps", 150, 5251 },
		{ 4465, "rus_vatnik", "RUS_HRHN", 150, 4420 },
		{ 4471, "LOD_BE_CR01", "LOwbea", 1500, 4468 },
		{ 4472, "LOD_BE_CR02", "LOwbea", 1500, 4469 },
		{ 4473, "LOD_BE_MID200", "LOwbea", 1500, 4470 },
		{ 4474, "LOD_BE_MID400", "LOwbea", 1500, 4467 },
		{ 4492, "LOD_SUBMAR", "LOD_SUBMAR", 1500, 4491 },
		{ 4500, "LOD_ETAGE", "LOD_ETAGE", 1500, 4497 },
		{ 4501, "LOD_ETAGEM", "LOD_ETAGE", 1500, 4498 },
		{ 4502, "LOD_ETAGET", "LOD_CPS", 1500, 4499 },
		{ 4504, "LOD_FLOOR", "LOD_FLOOR", 1500, 4503 },
		{ 4507, "LOD_DMSV", "LOD_ETAGE", 1500, 4505 },
		{ 4509, "LOD_LENINS", "LOD_LENINS", 1500, 4508 },
		{ 4513, "LOD_ZAMOKG", "LOD_CPS", 1500, 4512 },
		{ 4520, "LOD_NHR5F02", "LOD_NHR", 1500, 4514 },
		{ 4521, "LOD_NHR5F03", "LOD_NHR", 1500, 4515 },
		{ 4522, "LOD_NHR5F04", "LOD_NHR", 1500, 4516 },
		{ 4523, "LOD_NHR5F05", "LOD_NHR", 1500, 4517 },
		{ 4524, "LOD_NHR5F06", "LOD_NHR", 1500, 4518 },
		{ 4525, "LOD_NHR5F01", "LOD_NHR", 1500, 4519 },
		{ 4534, "LOD_NHR8F02", "LOD_NHR", 1500, 4526 },
		{ 4537, "LOD_NHR8F04", "LOD_NHR", 1500, 4528 },
		{ 4539, "LOD_NHR8F05", "LOD_NHR", 1500, 4529 },
		{ 4551, "LOD_NHR8F07", "LOD_NHR", 1500, 4531 },
		{ 4552, "LOD_NHR8F01", "LOD_NHR", 1500, 4532 },
		{ 4557, "LOD_DERHOU01", "LOD_DERV", 1500, 4553 },
		{ 4558, "LOD_DERHOU02", "LOD_DERV", 1500, 4554 },
		{ 4559, "LOD_DERHOU03", "LOD_DERV", 1500, 4555 },
		{ 4560, "LOD_DERHOU04", "LOD_DERV", 1500, 4556 },
		{ 4564, "LOD_shment", "LOD_CLCS", 1500, 4562 },
		{ 4566, "LOD_RYNOK", "LOD_NHR", 1500, 4565 },
		{ 4570, "LOD_BHOU01", "LOD_NHR", 1500, 4567 },
		{ 4571, "LOD_BHOU02", "LOD_NHR", 1500, 4568 },
		{ 4572, "LOD_BHOU03", "LOD_NHR", 1500, 4569 },
		{ 4578, "LOD_TPMS", "LOD_SHP0", 1500, 4577 },
		{ 4584, "LOD_ZN1", "LOD_NHR", 1500, 4579 },
		{ 4586, "LOD_ZN2", "LOD_NHR", 1500, 4580 },
		{ 4587, "LOD_ZN3", "LOD_NHR", 150, 4581 },
		{ 4588, "LOD_ZN4", "LOD_NHR", 1500, 4582 },
		{ 4589, "LOD_ZN5", "LOD_NHR", 1500, 4583 },
		{ 4591, "LOD_SEWERT", "LOD_NHR", 1500, 4590 },
		{ 4593, "LOD_SEWER", "LOWBEA", 1500, 4592 },
		{ 4617, "LOD_dom001", "LOD_gavno", 2990, 4603 },
		{ 4618, "LOD_dom002", "LOD_gavno", 2990, 4604 },
		{ 4628, "LOD_club", "LOD_gavno", 2990, 4612 },
		{ 4661, "LOD_skola1922", "LOpckz", 3000, 4660 },
		{ 4663, "LODsdosa", "LODosaol", 3000, 4662 },
		{ 4668, "LODs_A3C", "LOzavody", 3000, 4667 },
		{ 4675, "LODs_ibutskcity", "LOibutskcity", 3000, 4674 },
		{ 4683, "LODs_port", "LOruss_port", 3000, 4680 },
		{ 4685, "LODs_morvok", "LOmorgorod_1", 3000, 4684 },
		{ 4687, "LODs_munibld01", "LOmusob", 3000, 4686 },
		{ 4690, "LOD_grz_skola", "LOrus_grz_skola", 2990, 4689 },
		{ 4693, "LODs_hrushHD", "LOruss_hrushHD", 3000, 4692 },
		{ 4700, "LOD_mys_md", "lorus_mys_md", 3000, 4699 },
		{ 4718, "LOD_miniair", "LOD_air", 2990, 4710 },
		{ 4719, "LOD_aira", "LOD_air", 2990, 4712 },
		{ 4720, "LOD_airb", "LOD_air", 2990, 4713 },
		{ 4722, "LOD_ment_selo", "lorus_ment_selo", 2990, 4721 },
		{ 4726, "LOD_ebatusy", "LOrus_ebatusy", 2990, 4724 },
		{ 4729, "LOD_FSB", "LOrus_FSB", 2990, 4728 },
		{ 4731, "LOD_caribstad", "LOrus_caribstad", 2990, 4730 },
		{ 4733, "LOD_baza_otd", "LORUS_baza_otd", 2990, 4732 },
		{ 4736, "LOD_DK_Sanek", "LORUS_DK_Sanek", 2990, 4734 },
		{ 4754, "LOD_NII_MAK", "LOrus_NII_MAK", 2990, 4753 },
		{ 4756, "LOD_minecraft", "LOrus_minecraft", 2990, 4755 },
		{ 4758, "LOD_squadTEP", "LOrus_squadTEP", 2990, 4757 },
		{ 4760, "LOD_mem_1", "LOrus_squadTEP", 2990, 4759 },
		{ 4806, "LOD_tep_klin", "LOrus_tep_klin", 2990, 4761 },
		{ 4812, "LOD_univer_tep", "LOrus_univer_tep", 2990, 4811 },
		{ 4819, "LOD_r_wall_m01", "grnd", 2990, 4814 },
		{ 4821, "LOD_r_wall_m02", "grnd", 2990, 4815 },
		{ 4823, "LOD_r_wall_m03", "grnd", 2990, 4816 },
		{ 4824, "LOD_r_wall_cr01", "grnd", 2990, 4817 },
		{ 4825, "LOD_r_wall_cr02", "grnd", 2990, 4818 },
		{ 4830, "LODovokzal", "superLOD", 3000, 4826 },
		{ 4837, "LODeldorado_dosa", "LOD_pack", 3000, 4836 },
		{ 4857, "LODkavkaz_hostel", "LOD_pack", 3000, 4853 },
		{ 4873, "LODsberbank", "LOD_pack", 3000, 4871 },
		{ 4889, "LODstalinka_cl01", "LOD_pack", 3000, 4878 },
		{ 4891, "LODstalinka_cl02", "LOD_pack", 3000, 4880 },
		{ 4892, "LODstalinka_cl03", "LOD_pack", 3000, 4886 },
		{ 4896, "LODmed", "LOD_pack", 3000, 4895 },
		{ 4902, "LODsh1-4-5", "LOD_pack", 3000, 4901 },
		{ 4905, "LODmentovka", "LOD_pack", 3000, 4904 },
		{ 4914, "LODstalin_brAB", "LOD_pack", 3000, 4909 },
		{ 4915, "LODstalin_brCD", "LOD_pack", 3000, 4911 },
		{ 4916, "LODstalin_brEF", "LOD_pack", 3000, 4912 },
		{ 4925, "LODar_hrush01", "LOD_pack", 3000, 4924 },
		{ 4926, "LODmain", "LOD_pack", 3000, 4858 },
		{ 4927, "LODwalls", "LOD_pack", 3000, 4859 },
		{ 4928, "LODtower", "LOD_pack", 3000, 4861 },
		{ 4929, "LODpromo", "LOD_pack", 3000, 4864 },
		{ 4933, "LODar_ten_01", "LOD_pack", 3000, 4930 },
		{ 4934, "LODar_ten_02", "LOD_pack", 3000, 4931 },
		{ 4935, "LODar_ten_03", "LOD_pack", 3000, 4932 },
		{ 4937, "LODwc", "LOD_pack", 3000, 4936 },
		{ 4940, "LODhrush_345", "LOD_pack", 3000, 4939 },
		{ 4941, "LODbaza", "LObaza_vlazer", 2990, 4877 },
		{ 4943, "LODsh1-8", "LODosa_4flr", 2990, 4903 },
		{ 4944, "LODgaragepack", "LOgen_sht", 2990, 4876 },
		{ 4945, "LODskola", "LOskola", 2990, 4918 },
		{ 4948, "LOD_river_cr2", "LOwbea", 3000, 5054 },
		{ 4949, "LOD_river_end", "LOwbea", 3000, 5055 },
		{ 4950, "LOD_river_mid", "LOwbea", 3000, 5051 },
		{ 5063, "LODflat", "LOD_grnd", 2990, 5060 },
		{ 5113, "LOD_cli_MID", "LOD_GRND", 2990, 5068 },
		{ 5114, "LOD_cli_end01", "LOD_GRND", 2990, 5073 },
		{ 5116, "LOD_cli_end02", "LOD_GRND", 2990, 5110 },
		{ 5121, "LOD_cli_end03", "LOD_GRND", 2990, 5111 },
		{ 5122, "LOD_cli_CRN01", "LOD_GRND", 2990, 5071 },
		{ 5124, "LOD_cli_CRN02", "LOD_GRND", 2990, 5072 },
		{ 5180, "LODoika_001", "rusgen", 2990, 5142 },
		{ 5229, "LOD_supa_1", "LOsupa_f", 2990, 5228 },
		{ 5235, "LOD_bang_bld", "LODbs", 2990, 5230 },
		{ 5236, "rus_fnc", "gen_russia", 150, 5536 },
		{ 5238, "LOD_azs-fuck", "LOazs", 2990, 5237 },
		{ 5251, "was_parkFNC", "azs", 150, 5251 },
		{ 5252, "LOD_parkFNC", "LOazs", 2990, 5251 },
		{ 5285, "LODshop_vl", "LOmagi", 2990, 5284 },
		{ 5287, "LODshop_f", "LOmagi", 2998, 5282 },
		{ 5289, "LOD_sta_20d", "LOrus_staw_", 2990, 5288 },
		{ 5301, "LOD_sta_20e1", "LOrus_staw_", 2990, 5299 },
		{ 5303, "LOD_sta_20e2", "LOrus_staw_", 2990, 5300 },
		{ 5309, "LOD_STA_end01", "LOrus_STA_", 3000, 5304 },
		{ 5310, "LOD_STA_END02", "LOrus_STA_", 3000, 5307 },
		{ 5311, "LOD_STA_MID", "LOrus_STA_", 2990, 5305 },
		{ 5316, "LODIC_ROAD_BLEND", "LOGRD", 2990, 5315 },
		{ 5318, "LODIC_ROAD_L", "LOWRD", 2990, 5317 },
		{ 5320, "LODIC_ROAD_L100", "LOWRD", 3000, 5319 },
		{ 5331, "LODIC_ROAD_L50", "LOWRD", 2990, 5321 },
		{ 5336, "LODIC_ROAD_LCR", "LOWRD", 2990, 5332 },
		{ 5341, "LODIC_ROAD_L50C", "LOWRD", 2990, 5334 },
		{ 5342, "LODIC_ROAD_L100C", "LOWRD", 2990, 5335 },
		{ 5346, "LODIC_ROAD_LBL", "LOWRD", 2990, 5343 },
		{ 5348, "LODIC_ROAD_L100B", "LOWRD", 2990, 5344 },
		{ 5349, "LODIC_ROAD_L50B", "LOWRD", 2990, 5345 },
		{ 5352, "LODIC_ROAD_ROCK", "LOWRD", 2990, 5350 },
		{ 5359, "LODIC_ROAD_PL", "LOGRD", 2990, 5354 },
		{ 5360, "LODIC_ROAD_PL50", "LOGRD", 2990, 5356 },
		{ 5361, "LODIC_ROAD_PL100", "LOGRD", 2990, 5357 },
		{ 5394, "LODIC_ROAD_PLBL", "LOGRD", 2990, 5362 },
		{ 5395, "LODIC_ROAD_PL50B", "LOGRD", 2990, 5365 },
		{ 5396, "LODIC_ROAD_PL100B", "LOGRD", 2990, 5390 },
		{ 5397, "LODIC_ROAD_PL50C", "LOGRD", 2990, 5392 },
		{ 5398, "LODIC_ROAD_PL100C", "LOGRD", 2990, 5393 },
		{ 5399, "LODIC_ROAD_PLCR", "LOGRD", 2990, 5391 },
		{ 5407, "LODIC_ROAD_L50C01", "LOWRD", 3000, 5400 },
		{ 5408, "LODIC_ROAD_PL100C01", "LOGRD", 3000, 5401 },
		{ 5409, "LODIC_ROAD_PL50C01", "LOGRD", 3000, 5402 },
		{ 5410, "LODIC_ROAD_L100C01", "LOWRD", 3000, 5403 },
		{ 5411, "LODIC_ROAD_LCR01", "LOWRD", 3000, 5404 },
		{ 5412, "LODIC_ROAD_PLCR01", "LOGRD", 3000, 5406 },
		{ 5421, "LODsh5", "LOpck_hr", 3000, 5418 },
		{ 5423, "LODsh6", "LOpck_hr", 3000, 5419 },
		{ 5432, "LODlo_6", "LOteplo_", 1500, 5429 },
		{ 5433, "LODlo_7", "LOteplo_", 1500, 5430 },
		{ 5435, "LOD_ind_crane", "LOind_crane", 1500, 5434 },
		{ 5458, "LOD_rock_grp", "LOwrd", 3000, 5457 },
		{ 5486, "LODplates", "LOgrd", 3000, 5485 },
		{ 5500, "LODfuck_lnd", "LOgrd", 3000, 5499 },
		{ 5531, "LODcity_tree", "LOvgs", 500, 5530 },
		{ 5535, "LODezka_grp", "LOvgs", 500, 5534 },
		{ 5536, "berezka_line", "vgs", 60, 5536 },
		{ 5537, "LODezka_line", "LOvgs", 500, 5536 },
		{ 5572, "LODtsk", "gavnomod_mg", 3000, 5571 },
		{ 5575, "LODgavno", "gavnomod_blds", 3000, 5574 },
		{ 5582, "LOD_sobor", "LOD_pack", 3000, 5581 },
		{ 5583, "LODor_kupola", "LOD_pack", 3000, 5580 },
		{ 5589, "LODno_nw", "LOD_pack", 3000, 5588 },
		{ 5591, "LODe_tree_grp", "LODGRAZ", 500, 5590 },
		{ 5598, "LODtek_autos", "LOD_pack", 3000, 4839 },
		{ 5601, "LOD_shop", "LOD_pack", 3000, 5599 },
		{ 5604, "LODoshop", "LOD_pack", 3000, 5603 },
		{ 5606, "LODlr_tile", "LOD_pack", 3000, 5605 },
		{ 5608, "LOD_9flrbw", "LOD_pack", 3000, 5607 },
		{ 5610, "LOD_gavnomag", "LOD_pack", 3000, 5609 },
		{ 5612, "LODpanel9flr", "LOD_pack", 3000, 5611 },
		{ 5614, "LODtile9flr", "LOD_pack", 3000, 5613 },
		{ 5619, "LODoshka_frnd", "LOD_pack", 3000, 5615 },
		{ 5621, "LOD_9flruk1", "LOD_pack", 3000, 5620 },
		{ 5623, "LOD_9flruk2", "LOD_pack", 3000, 5622 }
	};

	for m,n in ipairs(pTable) do
		pModels[n[1]] = {
			id = n[1],
			name = n[2],
			txd = requestTexture(false, "textures/"..n[3]..".txd"),
			numStream = 0,
			lod = n[4] / 5,
			super = n[5]
		};
		pModelEntry = pModels[n[1]];
		engineImportTXD(pModelEntry.txd, n[1]);
		pModelEntry.model = engineLoadDFF("models/"..n[2]..".dff", n[1]);
		engineReplaceModel(pModelEntry.model, n[1]);
		if ( #n == 6 ) then
			pModelEntry.col = engineLoadCOL("coll/"..n[6]..".col");
			engineReplaceCOL(pModelEntry.col, n[1]);
		end
		engineSetModelLODDistance(n[1], n[4] / 5);
	end

	pTable={
		{ model=4467, model_file="RUS_BE_MID400", txd_file="wbea", coll_file="RUS_BE_MID400", lod=150, lodID=4474 },
		{ model=4469, model_file="RUS_BE_CR02", txd_file="wbea", coll_file="RUS_BE_CR02", lod=150, lodID=4472 },
		{ model=4817, model_file="was_r_wall_CR01", txd_file="grnd", coll_file="was_r_wall_CR01", lod=50, lodID=4824 },
		{ model=5051, model_file="was_river_mid", txd_file="wbea", coll_file="was_river_mid", lod=299, lodID=4950 },
		{ model=5054, model_file="was_river_cr2", txd_file="wbea", coll_file="was_river_cr2", lod=299, lodID=4948 },
		{ model=4816, model_file="was_r_wall_m03", txd_file="grnd", coll_file="was_r_wall_m03", lod=50, lodID=4823 },
		{ model=4814, model_file="was_r_wall_m01", txd_file="grnd", coll_file="was_r_wall_m01", lod=50, lodID=4819 },
		{ model=4818, model_file="was_r_wall_cr02", txd_file="grnd", coll_file="was_r_wall_cr02", lod=50, lodID=4825 },
		{ model=5457, model_file="was_rock_grp", txd_file="wrd", coll_file="was_rock_grp", lod=150, lodID=5458 },
		{ model=4097, model_file="was_cli_ap", txd_file="grnd", coll_file="was_cli_ap", lod=50, lodID=4098 },
		{ model=5060, model_file="ws_flat", txd_file="grnd", coll_file="ws_flat", lod=299, lodID=5063 },
		{ model=5071, model_file="was_cli_crn01", txd_file="GRND", coll_file="was_cli_crn01", lod=150, lodID=5122 },
		{ model=5068, model_file="was_cli_mid", txd_file="GRND", coll_file="was_cli_mid", lod=150, lodID=5113 },
		{ model=5073, model_file="was_cli_end01", txd_file="GRND", coll_file="was_cli_end01", lod=150, lodID=5114 },
		{ model=5110, model_file="was_cli_end02", txd_file="GRND", coll_file="was_cli_end02", lod=150, lodID=5116 },
		{ model=5350, model_file="RTAIC_ROAD_ROCK", txd_file="WRD", coll_file="RTAIC_ROAD_ROCK", lod=150, lodID=5352 },
		{ model=5111, model_file="was_cli_end03", txd_file="GRND", coll_file="was_cli_end03", lod=150, lodID=5121 },
		{ model=5317, model_file="RTAIC_ROAD_L", txd_file="WRD", coll_file="RTAIC_ROAD_L", lod=150, lodID=5318 },
		{ model=5332, model_file="RTAIC_ROAD_LCR", txd_file="WRD", coll_file="RTAIC_ROAD_LCR", lod=150, lodID=5336 },
		{ model=5404, model_file="RTAIC_ROAD_LCR01", txd_file="WRD", coll_file="RTAIC_ROAD_LCR01", lod=150, lodID=5411 },
		{ model=5343, model_file="RTAIC_ROAD_LBL", txd_file="WRD", coll_file="RTAIC_ROAD_LBL", lod=150, lodID=5346 },
		{ model=5403, model_file="RTAIC_ROAD_L100C01", txd_file="WRD", coll_file="RTAIC_ROAD_L100C01", lod=150, lodID=5410 },
		{ model=5344, model_file="RTAIC_ROAD_L100B", txd_file="WRD", coll_file="RTAIC_ROAD_L100B", lod=150, lodID=5348 },
		{ model=4093, model_file="c_sign06", txd_file="rus_neft", coll_file="c_sign06", lod=299 },
		{ model=5334, model_file="RTAIC_ROAD_L50C", txd_file="WRD", coll_file="RTAIC_ROAD_L50C", lod=150, lodID=5341 },
		{ model=5321, model_file="RTAIC_ROAD_L50", txd_file="WRD", coll_file="RTAIC_ROAD_L50", lod=150, lodID=5331 },
		{ model=4024, model_file="RUS_counthou01", txd_file="RUS_counthou0", coll_file="RUS_counthou01", lod=150, lodID=4028 },
		{ model=4555, model_file="RUS_DERHOU03", txd_file="RUS_DERV", coll_file="RUS_DERHOU03", lod=150, lodID=4559 },
		{ model=4026, model_file="RUS_counthou03", txd_file="RUS_counthou0", coll_file="RUS_counthou03", lod=150, lodID=4030 },
		{ model=4055, model_file="rus_selomag02", txd_file="rus_selomag0", coll_file="rus_selomag02", lod=150, lodID=4059 },
		{ model=4101, model_file="rock_form", txd_file="rock_form", coll_file="rock_form", lod=150 },
		{ model=4037, model_file="RUS_shinmon03", txd_file="RUS_shinmon0", coll_file="RUS_shinmon03", lod=150, lodID=4041 },
		{ model=4901, model_file="hrush1-4", txd_file="dosa_3flr", coll_file="hrush1-4", lod=150, lodID=4902 },
		{ model=4027, model_file="RUS_counthou04", txd_file="RUS_counthou0", coll_file="RUS_counthou04", lod=150, lodID=4031 },
		{ model=4554, model_file="RUS_DERHOU02", txd_file="RUS_DERV", coll_file="RUS_DERHOU02", lod=150, lodID=4558 },
		{ model=5590, model_file="pine_tree_grp", txd_file="GRAZ", coll_file="pine_tree_grp", lod=20, lodID=5591 },
		{ model=4438, model_file="RUS_GRP01", txd_file="RUS_ATPCS", coll_file="RUS_GRP01", lod=150, lodID=4443 },
		{ model=4436, model_file="RUS_GRP02", txd_file="RUS_ATPCS", coll_file="RUS_GRP02", lod=150, lodID=4444 },
		{ model=4437, model_file="RUS_GRP03", txd_file="RUS_ATPCS", coll_file="RUS_GRP03", lod=150, lodID=4439 },
		{ model=5605, model_file="10flr_tile", txd_file="gavnomod_blds", coll_file="10flr_tile", lod=150, lodID=5606 },
		{ model=5345, model_file="RTAIC_ROAD_L50B", txd_file="WRD", coll_file="RTAIC_ROAD_L50B", lod=150, lodID=5349 },
		{ model=5613, model_file="ig_tile9flr", txd_file="gavnomod_blds2", coll_file="ig_tile9flr", lod=150, lodID=5614 },
		{ model=4010, model_file="dom_5floor_1", txd_file="hipoly_hrush", coll_file="dom_5floor_1", lod=150, lodID=4011 },
		{ model=5576, model_file="garaj_a", txd_file="gavnomod_gen1", coll_file="garaj_a", lod=150 },
		{ model=5577, model_file="garaj_b", txd_file="gavnomod_gen1", coll_file="garaj_b", lod=150 },
		{ model=5578, model_file="garaj_c", txd_file="gavnomod_gen1", coll_file="garaj_c", lod=150 },
		{ model=4012, model_file="dom_5floor_2", txd_file="hipoly_hrush", coll_file="dom_5floor_2", lod=150, lodID=4013 },
		{ model=4179, model_file="rud_pgpack", txd_file="rud_pgpack", coll_file="rud_pgpack", lod=150 },
		{ model=5552, model_file="hood_stuff01", txd_file="gen_sht", coll_file="hood_stuff01", lod=150 },
		{ model=5548, model_file="kotelnya_1", txd_file="kotelnya", coll_file="kotelnya_1", lod=150 },
		{ model=5538, model_file="derevo_a", txd_file="graz", coll_file="derevo_a", lod=80 },
		{ model=5584, model_file="derevo2", txd_file="graz", coll_file="derevo2", lod=150 },
		{ model=5585, model_file="derevo", txd_file="graz", coll_file="derevo", lod=150 },
		{ model=4134, model_file="rus_treepack", txd_file="rus_treepack", coll_file="rus_treepack", lod=50, lodID=4135 },
		{ model=5335, model_file="RTAIC_ROAD_L100C", txd_file="WRD", coll_file="RTAIC_ROAD_L100C", lod=150, lodID=5342 },
		{ model=4384, model_file="RUS_5FLN01", txd_file="RUS_HRHN", coll_file="RUS_5FLN01", lod=150, lodID=4388 },
		{ model=4518, model_file="RUS_NHR5F06", txd_file="RUS_NHR", coll_file="RUS_NHR5F06", lod=150, lodID=4524 },
		{ model=4692, model_file="russ_hrushHD", txd_file="russ_hrushHD", coll_file="russ_hrushHD", lod=150, lodID=4693 },
		{ model=5282, model_file="ru_shop_f", txd_file="magi", coll_file="ru_shop_f", lod=150, lodID=5287 },
		{ model=4503, model_file="RUS_FLOOR", txd_file="RUS_FLOOR", coll_file="RUS_FLOOR", lod=150, lodID=4504 },
		{ model=4397, model_file="RUS_BFN01", txd_file="RUS_ATPCS", coll_file="RUS_BFN01", lod=150, lodID=4414 },
		{ model=5592, model_file="parking", txd_file="gavnomod_blds", coll_file="parking", lod=150 },
		{ model=4420, model_file="RUS_BIG_FUCKLND", txd_file="GRD", coll_file="RUS_BIG_FUCKLND", lod=299, lodID=4465 },
		{ model=5603, model_file="avtoshop", txd_file="gavnomod_blds", coll_file="avtoshop", lod=150, lodID=5604 },
		{ model=4448, model_file="RUS_DCAR06", txd_file="RUS_DCAR0", coll_file="RUS_DCAR06", lod=150 },
		{ model=4451, model_file="RUS_DCAR02", txd_file="RUS_DCAR0", coll_file="RUS_DCAR02", lod=150 },
		{ model=4445, model_file="RUS_DCAR03", txd_file="RUS_DCAR0", coll_file="RUS_DCAR03", lod=150 },
		{ model=4450, model_file="RUS_DCAR01", txd_file="RUS_DCAR0", coll_file="RUS_DCAR01", lod=150 },
		{ model=4447, model_file="RUS_DCAR05", txd_file="RUS_DCAR0", coll_file="RUS_DCAR05", lod=150 },
		{ model=4446, model_file="RUS_DCAR04", txd_file="RUS_DCAR0", coll_file="RUS_DCAR04", lod=150 },
		{ model=4449, model_file="RUS_DCAR07", txd_file="RUS_DCAR0", coll_file="RUS_DCAR07", lod=150 },
		{ model=4514, model_file="RUS_NHR5F02", txd_file="RUS_NHR", coll_file="RUS_NHR5F02", lod=150, lodID=4520 },
		{ model=5430, model_file="teplo_7", txd_file="teplo_", coll_file="teplo_7", lod=80, lodID=5433 },
		{ model=4399, model_file="RUS_BFN03", txd_file="RUS_ATPCS", coll_file="RUS_BFN03", lod=150, lodID=4412 },
		{ model=3996, model_file="ig_unimag_dosa", txd_file="unimag_dosa", coll_file="ig_unimag_dosa", lod=150, lodID=3997 },
		{ model=4836, model_file="ig_eldorado_dosa", txd_file="eldorado_dosa", coll_file="ig_eldorado_dosa", lod=150, lodID=4837 },
		{ model=5499, model_file="ru_fuck_lnd", txd_file="grd", coll_file="ru_fuck_lnd", lod=150, lodID=5500 },
		{ model=5586, model_file="kust", txd_file="graz", coll_file="kust", lod=50 },
		{ model=4561, model_file="rus_bnksr", txd_file="RUS_NHR", coll_file="rus_bnksr", lod=150 },
		{ model=4553, model_file="RUS_DERHOU01", txd_file="RUS_DERV", coll_file="RUS_DERHOU01", lod=150, lodID=4557 },
		{ model=4025, model_file="RUS_counthou02", txd_file="RUS_counthou0", coll_file="RUS_counthou02", lod=150, lodID=4029 },
		{ model=4556, model_file="RUS_DERHOU04", txd_file="RUS_DERV", coll_file="RUS_DERHOU04", lod=150, lodID=4560 },
		{ model=5534, model_file="berezka_grp", txd_file="vgs", coll_file="berezka_grp", lod=150, lodID=5535 },
		{ model=4186, model_file="lamps_200", txd_file="gavnomod_gen1", coll_file="lamps_200", lod=299 },
		{ model=4182, model_file="lamps_100", txd_file="gavnomod_gen1", coll_file="lamps_100", lod=299 },
		{ model=4400, model_file="RUS_BFN04", txd_file="RUS_ATPCS", coll_file="RUS_BFN04", lod=150, lodID=4413 },
		{ model=5542, model_file="zil_st", txd_file="car_park01", coll_file="zil_st", lod=150 },
		{ model=5539, model_file="gaz_st", txd_file="car_park02", coll_file="gaz_st", lod=150 },
		{ model=4562, model_file="rus_shment", txd_file="RUS_CLCS", coll_file="rus_shment", lod=150, lodID=4564 },
		{ model=4401, model_file="RUS_KPP01", txd_file="RUS_ATPCS", coll_file="RUS_KPP01", lod=150, lodID=4416 },
		{ model=4405, model_file="RUS_GATE02", txd_file="RUS_ATPCS", coll_file="RUS_GATE02", lod=150 },
		{ model=5456, model_file="was_fnc01", txd_file="was_fnc", coll_file="was_fnc01", lod=150 },
		{ model=4508, model_file="RUS_LENINS", txd_file="RUS_LENINS", coll_file="RUS_LENINS", lod=150, lodID=4509 },
		{ model=4510, model_file="RUS_LENINB", txd_file="RUS_LENINS", coll_file="RUS_LENINB", lod=150 },
		{ model=4699, model_file="rus_mys_md", txd_file="rus_mys_md", coll_file="rus_mys_md", lod=120, lodID=4700 },
		{ model=4936, model_file="domWC", txd_file="domwc", coll_file="domWC", lod=150, lodID=4937 },
		{ model=4665, model_file="russs_city_bush", txd_file="bushrus", coll_file="russs_city_bush", lod=120 },
		{ model=4671, model_file="palatka03", txd_file="ibutskcity", coll_file="palatka03", lod=80 },
		{ model=4085, model_file="rus_neft", txd_file="rus_neft", coll_file="rus_neft", lod=150, lodID=4087 },
		{ model=4086, model_file="rus_neftpl", txd_file="rus_neft", coll_file="rus_neftpl", lod=150 },
		{ model=4398, model_file="RUS_BFN02", txd_file="RUS_ATPCS", coll_file="RUS_BFN02", lod=150, lodID=4411 },
		{ model=4092, model_file="c_sign05", txd_file="rus_neft", coll_file="c_sign05", lod=299 },
		{ model=4565, model_file="RUS_RYNOK", txd_file="RUS_NHR", coll_file="RUS_RYNOK", lod=150, lodID=4566 },
		{ model=4392, model_file="RUS_ADMBLD01", txd_file="RUS_HRHN", coll_file="RUS_ADMBLD01", lod=150, lodID=4396 },
		{ model=4567, model_file="RUS_BHOU01", txd_file="RUS_NHR", coll_file="RUS_BHOU01", lod=150, lodID=4570 },
		{ model=4568, model_file="RUS_BHOU02", txd_file="RUS_NHR", coll_file="RUS_BHOU02", lod=150, lodID=4571 },
		{ model=5440, model_file="grass_waste", txd_file="graz", coll_file="grass_waste", lod=150 },
		{ model=5434, model_file="was_ind_crane", txd_file="ind_crane", coll_file="was_ind_crane", lod=150, lodID=5435 },
		{ model=5568, model_file="bulldozer", txd_file="car_park02", coll_file="bulldozer", lod=150 },
		{ model=5569, model_file="crusher", txd_file="car_park02", coll_file="crusher", lod=150 },
		{ model=4710, model_file="rus_miniair", txd_file="rus_air", coll_file="rus_miniair", lod=90, lodID=4718 },
		{ model=4712, model_file="rus_aira", txd_file="rus_air", coll_file="rus_aira", lod=90, lodID=4719 },
		{ model=4713, model_file="rus_airb", txd_file="rus_air", coll_file="rus_airb", lod=90, lodID=4720 },
		{ model=4409, model_file="RUS_ARPG03", txd_file="RUS_ATPCS", coll_file="RUS_ARPG03", lod=150, lodID=4418 },
		{ model=4389, model_file="RUS_ADMBLD02", txd_file="RUS_HRHN", coll_file="RUS_ADMBLD02", lod=150, lodID=4393 },
		{ model=4149, model_file="rus_newmostA", txd_file="rus_newmost", coll_file="rus_newmostA", lod=150 },
		{ model=4148, model_file="rus_newmost", txd_file="rus_newmost", coll_file="rus_newmost", lod=150, lodID=4150 },
		{ model=4091, model_file="c_sign04", txd_file="rus_neft", coll_file="c_sign04", lod=299 },
		{ model=4721, model_file="rus_ment_selo", txd_file="rus_ment_selo", coll_file="rus_ment_selo", lod=150, lodID=4722 },
		{ model=5567, model_file="podstat_91", txd_file="pod_sta91", coll_file="podstat_91", lod=150 },
		{ model=4569, model_file="RUS_BHOU03", txd_file="RUS_NHR", coll_file="RUS_BHOU03", lod=150, lodID=4572 },
		{ model=4383, model_file="RUS_5FLN04", txd_file="RUS_HRHN", coll_file="RUS_5FLN04", lod=150, lodID=4387 },
		{ model=5429, model_file="teplo_6", txd_file="teplo_", coll_file="teplo_6", lod=80, lodID=5432 },
		{ model=4381, model_file="RUS_5FLN02", txd_file="RUS_HRHN", coll_file="RUS_5FLN02", lod=150, lodID=4385 },
		{ model=5545, model_file="ostanovka2", txd_file="ostanovki", coll_file="ostanovka2", lod=150 },
		{ model=4669, model_file="palatka01", txd_file="ibutskcity", coll_file="palatka01", lod=80 },
		{ model=4670, model_file="palatka02", txd_file="ibutskcity", coll_file="palatka02", lod=80 },
		{ model=4672, model_file="palatka04", txd_file="ibutskcity", coll_file="palatka04", lod=90 },
		{ model=5526, model_file="bb_6", txd_file="gen_sht", coll_file="bb_6", lod=150 },
		{ model=5523, model_file="bb_3", txd_file="gen_sht", coll_file="bb_3", lod=150 },
		{ model=5524, model_file="bb_4", txd_file="gen_sht", coll_file="bb_4", lod=150 },
		{ model=5525, model_file="bb_5", txd_file="gen_sht", coll_file="bb_5", lod=150 },
		{ model=5527, model_file="bb_7", txd_file="gen_sht", coll_file="bb_7", lod=150 },
		{ model=5521, model_file="bb_2", txd_file="gen_sht", coll_file="bb_2", lod=150 },
		{ model=5588, model_file="gavno_nw", txd_file="gavnomod_blds", coll_file="gavno_nw", lod=150, lodID=5589 },
		{ model=5142, model_file="stroika_001", txd_file="rusgen", coll_file="stroika_001", lod=299, lodID=5180 },
		{ model=4946, model_file="parkbench1", txd_file="benches_cj", coll_file="parkbench1", lod=50 },
		{ model=5528, model_file="bb_8", txd_file="gen_sht", coll_file="bb_8", lod=150 },
		{ model=5571, model_file="ibutsk", txd_file="gavnomod_mg", coll_file="ibutsk", lod=150, lodID=5572 },
		{ model=5319, model_file="RTAIC_ROAD_L100", txd_file="WRD", coll_file="RTAIC_ROAD_L100", lod=150, lodID=5320 },
		{ model=5307, model_file="rus_STA_end02", txd_file="rus_STA_", coll_file="rus_STA_end02", lod=150, lodID=5310 },
		{ model=5305, model_file="rus_STA_mid", txd_file="rus_STA_", coll_file="rus_STA_mid", lod=150, lodID=5311 },
		{ model=5304, model_file="rus_STA_end01", txd_file="rus_STA_", coll_file="rus_STA_end01", lod=150, lodID=5309 },
		{ model=4918, model_file="ig_skola", txd_file="skola", coll_file="ig_skola", lod=150, lodID=4945 },
		{ model=4228, model_file="RUS_9FLE1_03", txd_file="RUS_HRHN", coll_file="RUS_9FLE1_03", lod=150, lodID=4375 },
		{ model=4226, model_file="RUS_9FLM_03", txd_file="RUS_HRHN", coll_file="RUS_9FLM_03", lod=150, lodID=4376 },
		{ model=4225, model_file="RUS_9FLE2_03", txd_file="RUS_HRHN", coll_file="RUS_9FLE2_03", lod=150, lodID=4377 },
		{ model=4667, model_file="russ_A3C", txd_file="zavody", coll_file="russ_A3C", lod=90, lodID=4668 },
		{ model=4408, model_file="RUS_ARPG02", txd_file="RUS_ATPCS", coll_file="RUS_ARPG02", lod=150, lodID=4417 },
		{ model=4434, model_file="RUS_ATBLD03", txd_file="RUS_ATPCS", coll_file="RUS_ATBLD03", lod=150, lodID=4442 },
		{ model=4433, model_file="RUS_ATBLD02", txd_file="RUS_ATPCS", coll_file="RUS_ATBLD02", lod=150, lodID=4441 },
		{ model=4435, model_file="RUS_ATBLD01", txd_file="RUS_ATPCS", coll_file="RUS_ATBLD01", lod=150, lodID=4440 },
		{ model=4390, model_file="RUS_ADMBLD03", txd_file="RUS_HRHN", coll_file="RUS_ADMBLD03", lod=150, lodID=4394 },
		{ model=4404, model_file="RUS_GATE01", txd_file="RUS_ATPCS", coll_file="RUS_GATE01", lod=150 },
		{ model=4402, model_file="RUS_KPP02", txd_file="RUS_ATPCS", coll_file="RUS_KPP02", lod=150, lodID=4415 },
		{ model=4602, model_file="petrolpumpnew", txd_file="gen_petrol", coll_file="petrolpumpnew", lod=100 },
		{ model=4452, model_file="RUS_HLEKOM", txd_file="RUS_HRHN", coll_file="RUS_HLEKOM", lod=150, lodID=4453 },
		{ model=4406, model_file="RUS_GATE03", txd_file="RUS_ATPCS", coll_file="RUS_GATE03", lod=150 },
		{ model=4457, model_file="RUS_FBARN01", txd_file="RUS_ATPCS", coll_file="RUS_FBARN01", lod=150, lodID=4460 },
		{ model=4454, model_file="RUS_FBARN02", txd_file="RUS_ATPCS", coll_file="RUS_FBARN02", lod=150, lodID=4461 },
		{ model=4455, model_file="RUS_FBARN03", txd_file="RUS_ATPCS", coll_file="RUS_FBARN03", lod=150, lodID=4458 },
		{ model=4407, model_file="RUS_GATE04", txd_file="RUS_ATPCS", coll_file="RUS_GATE04", lod=150 },
		{ model=5230, model_file="mrg_bang_bld", txd_file="dbs", coll_file="mrg_bang_bld", lod=150, lodID=5235 },
		{ model=4017, model_file="rus_cerkovs", txd_file="rus_cerkovs", coll_file="rus_cerkovs", lod=150, lodID=4018 },
		{ model=5615, model_file="kinoshka_frnd", txd_file="gavnomod_kf", coll_file="kinoshka_frnd", lod=150, lodID=5619 },
		{ model=5485, model_file="ru_plates", txd_file="grd", coll_file="ru_plates", lod=150, lodID=5486 },
		{ model=4096, model_file="antena", txd_file="gen_trashers", coll_file="antena", lod=150 },
		{ model=4463, model_file="rus_mntibud", txd_file="rus_cps", coll_file="rus_mntibud", lod=90 },
		{ model=4464, model_file="LOD_mntibu", txd_file="LOD_CPS", coll_file="LOD_mntibu", lod=1500 },
		{ model=4466, model_file="LOD_vatnik", txd_file="LOD_HRHN", coll_file="LOD_vatnik", lod=1500 },
		{ model=5549, model_file="trash_gen01", txd_file="gen_sht", coll_file="trash_gen01", lod=150 },
		{ model=5616, model_file="kinoshka_decals", txd_file="gavnomod_kf", coll_file="kinoshka_decals", lod=150 },
		{ model=5617, model_file="kino_door_left", txd_file="gavnomod_kf", coll_file="kino_door_left", lod=150 },
		{ model=5618, model_file="kino_door_right", txd_file="gavnomod_kf", coll_file="kino_door_right", lod=150 },
		{ model=5544, model_file="ostanovka0-1", txd_file="ostanovki", coll_file="ostanovka0-1", lod=150 },
		{ model=4850, model_file="IG_depoBUS", txd_file="kavkaz", coll_file="IG_depoBUS", lod=150 },
		{ model=5284, model_file="ru_shop_vl", txd_file="magi", coll_file="ru_shop_vl", lod=150, lodID=5285 },
		{ model=5607, model_file="ign_9flrbw", txd_file="gavnomod_3", coll_file="ign_9flrbw", lod=150, lodID=5608 },
		{ model=4876, model_file="ig_garagepack", txd_file="gen_sht", coll_file="ig_garagepack", lod=150, lodID=4944 },
		{ model=5563, model_file="besedka_1-2", txd_file="props_txd_set01", coll_file="besedka_1-2", lod=150 },
		{ model=5609, model_file="ign_gavnomag", txd_file="gavnomod_3", coll_file="ign_gavnomag", lod=150, lodID=5610 },
		{ model=4035, model_file="RUS_shinmon01", txd_file="RUS_shinmon0", coll_file="RUS_shinmon01", lod=150, lodID=4039 },
		{ model=3980, model_file="hrush1-1", txd_file="dosa_hrush", coll_file="hrush1-1", lod=150, lodID=3981 },
		{ model=3982, model_file="hrush1-2", txd_file="dosa_hrush", coll_file="hrush1-2", lod=150, lodID=3983 },
		{ model=5228, model_file="bld_supa_1", txd_file="supa_f", coll_file="bld_supa_1", lod=150, lodID=5229 },
		{ model=4853, model_file="ig_kavkaz_hostel", txd_file="kavkaz", coll_file="ig_kavkaz_hostel", lod=150, lodID=4857 },
		{ model=4924, model_file="habar_hrush01", txd_file="habar_sht", coll_file="habar_hrush01", lod=150, lodID=4925 },
		{ model=4006, model_file="hrush1-6", txd_file="dosa_hrush", coll_file="hrush1-6", lod=150, lodID=4008 },
		{ model=4000, model_file="dom_5floor_3", txd_file="r_shit", coll_file="dom_5floor_3", lod=150, lodID=4001 },
		{ model=4056, model_file="rus_selomag03", txd_file="rus_selomag0", coll_file="rus_selomag03", lod=150, lodID=4060 },
		{ model=4724, model_file="rus_ebatusy", txd_file="rus_ebatusy", coll_file="rus_ebatusy", lod=150, lodID=4726 },
		{ model=4826, model_file="avtovokzal", txd_file="avtovokzal_txd", coll_file="avtovokzal", lod=150, lodID=4830 },
		{ model=5611, model_file="ig_panel9flr", txd_file="gavnomod_blds2", coll_file="ig_panel9flr", lod=150, lodID=5612 },
		{ model=5072, model_file="was_cli_crn02", txd_file="GRND", coll_file="was_cli_crn02", lod=299, lodID=5124 },
		{ model=5315, model_file="RTAIC_ROAD_BLEND", txd_file="grd", coll_file="RTAIC_ROAD_BLEND", lod=150, lodID=5316 },
		{ model=5354, model_file="RTAIC_ROAD_PL", txd_file="GRD", coll_file="RTAIC_ROAD_PL", lod=150, lodID=5359 },
		{ model=3988, model_file="hrush_1dlc", txd_file="dosa_hrush", coll_file="hrush_1dlc", lod=150 },
		{ model=3989, model_file="hrush1-2dlc", txd_file="dosa_hrush", coll_file="hrush1-2dlc", lod=150 },
		{ model=5556, model_file="build_gen01", txd_file="gen_sht", coll_file="build_gen01", lod=150 },
		{ model=5562, model_file="besedka_1-1", txd_file="props_txd_set01", coll_file="besedka_1-1", lod=150 },
		{ model=5560, model_file="pg_parahod", txd_file="props_txd_set01", coll_file="pg_parahod", lod=150 },
		{ model=5564, model_file="pesok_a", txd_file="props_ig", coll_file="pesok_a", lod=150 },
		{ model=5573, model_file="panel_zabor_grp1", txd_file="gavnomod_gen1", coll_file="panel_zabor_grp1", lod=150 },
		{ model=5580, model_file="sobor_kupola", txd_file="sobor", coll_file="sobor_kupola", lod=150, lodID=5583 },
		{ model=5581, model_file="ing_sobor", txd_file="sobor", coll_file="ing_sobor", lod=150, lodID=5582 },
		{ model=4122, model_file="rus_zzavodbl2", txd_file="ZVD", coll_file="rus_zzavodbl2", lod=150, lodID=4126 },
		{ model=4119, model_file="rus_zzavodbl1", txd_file="ZVD", coll_file="rus_zzavodbl1", lod=150, lodID=4125 },
		{ model=4124, model_file="rus_zzavodbl4", txd_file="ZVD", coll_file="rus_zzavodbl4", lod=150, lodID=4128 },
		{ model=4123, model_file="rus_zzavodbl3", txd_file="ZVD", coll_file="rus_zzavodbl3", lod=150, lodID=4127 },
		{ model=4133, model_file="ru_zfloor", txd_file="ZVD", coll_file="ru_zfloor", lod=150 },
		{ model=4130, model_file="rus_zzabor", txd_file="ZVD", coll_file="rus_zzabor", lod=150 },
		{ model=4132, model_file="rus_zvrata", txd_file="ZVD", coll_file="rus_zvrata", lod=150 },
		{ model=4815, model_file="was_r_wall_m02", txd_file="grnd", coll_file="was_r_wall_m02", lod=50, lodID=4821 },
		{ model=4019, model_file="rus_resto", txd_file="rusrus", coll_file="rus_resto", lod=150, lodID=4021 },
		{ model=5237, model_file="rus_azs-fuck", txd_file="azs", coll_file="rus_azs-fuck", lod=150, lodID=5238 },
		{ model=4070, model_file="rus_kolhoz", txd_file="rus_kolhoz", coll_file="rus_kolhoz", lod=299, lodID=4071 },
		{ model=4062, model_file="rus_2flrbld01", txd_file="rus_2flrbld0", coll_file="rus_2flrbld01", lod=299, lodID=4065 },
		{ model=4063, model_file="rus_2flrbld02", txd_file="rus_2flrbld0", coll_file="rus_2flrbld02", lod=299, lodID=4066 },
		{ model=4895, model_file="ig_med", txd_file="med", coll_file="ig_med", lod=150, lodID=4896 },
		{ model=4603, model_file="rus_dom001", txd_file="gavno1", coll_file="rus_dom001", lod=90, lodID=4617 },
		{ model=5419, model_file="hrush6", txd_file="pck_hr", coll_file="hrush6", lod=299, lodID=5423 },
		{ model=5393, model_file="RTAIC_ROAD_PL100C", txd_file="GRD", coll_file="RTAIC_ROAD_PL100C", lod=150, lodID=5398 },
		{ model=5357, model_file="RTAIC_ROAD_PL100", txd_file="GRD", coll_file="RTAIC_ROAD_PL100", lod=150, lodID=5361 },
		{ model=5391, model_file="RTAIC_ROAD_PLCR", txd_file="GRD", coll_file="RTAIC_ROAD_PLCR", lod=150, lodID=5399 },
		{ model=5390, model_file="RTAIC_ROAD_PL100B", txd_file="GRD", coll_file="RTAIC_ROAD_PL100B", lod=150, lodID=5396 },
		{ model=5406, model_file="RTAIC_ROAD_PLCR01", txd_file="GRD", coll_file="RTAIC_ROAD_PLCR01", lod=150, lodID=5412 },
		{ model=5365, model_file="RTAIC_ROAD_PL50B", txd_file="GRD", coll_file="RTAIC_ROAD_PL50B", lod=150, lodID=5395 },
		{ model=5362, model_file="RTAIC_ROAD_PLBL", txd_file="GRD", coll_file="RTAIC_ROAD_PLBL", lod=150, lodID=5394 },
		{ model=4871, model_file="ig_sberbank", txd_file="stalinki", coll_file="ig_sberbank", lod=150, lodID=4873 },
		{ model=5356, model_file="RTAIC_ROAD_PL50", txd_file="GRD", coll_file="RTAIC_ROAD_PL50", lod=150, lodID=5360 },
		{ model=4153, model_file="rus_stsuu", txd_file="RUS_CPS", coll_file="rus_stsuu", lod=150, lodID=4154 },
		{ model=4151, model_file="rus_stsud", txd_file="RUS_CPS", coll_file="rus_stsud", lod=150, lodID=4152 },
		{ model=4138, model_file="RUS_MSTAL03", txd_file="RUS_CPS", coll_file="RUS_MSTAL03", lod=150, lodID=4143 },
		{ model=5401, model_file="RTAIC_ROAD_PL100C01", txd_file="GRD", coll_file="RTAIC_ROAD_PL100C01", lod=150, lodID=5408 },
		{ model=4155, model_file="RUS_TOVARISH", txd_file="RUS_CPS", coll_file="RUS_TOVARISH", lod=150, lodID=4158 },
		{ model=4157, model_file="RUS_TOVARISHD", txd_file="RUS_CPS", coll_file="RUS_TOVARISHD", lod=150, lodID=4159 },
		{ model=4160, model_file="RUS_THRA", txd_file="RUS_CPS", coll_file="RUS_THRA", lod=200, lodID=4162 },
		{ model=4161, model_file="RUS_THRB", txd_file="RUS_CPS", coll_file="RUS_THRB", lod=200, lodID=4164 },
		{ model=4139, model_file="RUS_MSTAL04", txd_file="RUS_CPS", coll_file="RUS_MSTAL04", lod=150, lodID=4144 },
		{ model=4137, model_file="RUS_MSTAL02", txd_file="RUS_CPS", coll_file="RUS_MSTAL02", lod=150, lodID=4142 },
		{ model=4146, model_file="rus_sidewalk", txd_file="RUS_CPS", coll_file="rus_sidewalk", lod=150 },
		{ model=4147, model_file="rus_sidewalkcr", txd_file="RUS_CPS", coll_file="rus_sidewalkcr", lod=150 },
		{ model=4864, model_file="SP_promo", txd_file="habar_sp", coll_file="SP_promo", lod=150, lodID=4929 },
		{ model=4858, model_file="sp_main", txd_file="habar_sp", coll_file="sp_main", lod=150, lodID=4926 },
		{ model=4859, model_file="SP_walls", txd_file="habar_sp", coll_file="SP_walls", lod=150, lodID=4927 },
		{ model=4861, model_file="SP_tower", txd_file="habar_sp", coll_file="SP_tower", lod=150, lodID=4928 },
		{ model=4169, model_file="RUS_SQRA", txd_file="RUS_CPS", coll_file="RUS_SQRA", lod=150, lodID=4177 },
		{ model=4176, model_file="RUS_SQRB", txd_file="RUS_CPS", coll_file="RUS_SQRB", lod=150, lodID=4178 },
		{ model=4166, model_file="RUS_LENIN", txd_file="RUS_CPS", coll_file="RUS_LENIN", lod=150, lodID=4167 },
		{ model=5546, model_file="busstop_ru_1-1", txd_file="ostanovki", coll_file="busstop_ru_1-1", lod=150 },
		{ model=5547, model_file="busstop_ru_1-1a", txd_file="ostanovki", coll_file="busstop_ru_1-1a", lod=150 },
		{ model=3994, model_file="ign_gavnobuild1", txd_file="gavnomod_3", coll_file="ign_gavnobuild1", lod=150 },
		{ model=4136, model_file="RUS_MSTAL01", txd_file="RUS_CPS", coll_file="RUS_MSTAL01", lod=150, lodID=4141 },
		{ model=4181, model_file="lapms_50", txd_file="gavnomod_gen1", coll_file="lapms_50", lod=299 },
		{ model=5420, model_file="fuck_obch", txd_file="pck_hr", coll_file="fuck_obch", lod=299 },
		{ model=5400, model_file="RTAIC_ROAD_L50C01", txd_file="WRD", coll_file="RTAIC_ROAD_L50C01", lod=150, lodID=5407 },
		{ model=5600, model_file="uni_shop_glass", txd_file="gavnomod_blds2", coll_file="uni_shop_glass", lod=150 },
		{ model=5599, model_file="uni_shop", txd_file="gavnomod_blds2", coll_file="uni_shop", lod=150, lodID=5601 },
		{ model=4053, model_file="int_burg_light", txd_file="int_burg", coll_file="int_burg_light", lod=150 },
		{ model=4877, model_file="ig_baza", txd_file="baza_vlazer", coll_file="ig_baza", lod=150, lodID=4941 },
		{ model=3984, model_file="ign_9flruk3", txd_file="gavnomod_3", coll_file="ign_9flruk3", lod=150, lodID=3985 },
		{ model=5620, model_file="ign_9flruk1", txd_file="gavnomod_3", coll_file="ign_9flruk1", lod=150, lodID=5621 },
		{ model=4604, model_file="rus_dom002", txd_file="gavno1", coll_file="rus_dom002", lod=90, lodID=4618 },
		{ model=4903, model_file="hrush1-8", txd_file="dosa_4flr", coll_file="hrush1-8", lod=150, lodID=4943 },
		{ model=4904, model_file="ig_mentovka", txd_file="mentovka", coll_file="ig_mentovka", lod=150, lodID=4905 },
		{ model=4002, model_file="dom_674", txd_file="hrush647_784", coll_file="dom_674", lod=150, lodID=4004 },
		{ model=5418, model_file="hrush5", txd_file="pck_hr", coll_file="hrush5", lod=299, lodID=5421 },
		{ model=4208, model_file="RUS_9FLE1_01", txd_file="RUS_HRHN", coll_file="RUS_9FLE1_01", lod=150, lodID=4235 },
		{ model=4210, model_file="RUS_9FLM_01", txd_file="RUS_HRHN", coll_file="RUS_9FLM_01", lod=150, lodID=4236 },
		{ model=4209, model_file="RUS_9FLE2_01", txd_file="RUS_HRHN", coll_file="RUS_9FLE2_01", lod=150, lodID=4237 },
		{ model=4224, model_file="RUS_9FLE1_02", txd_file="RUS_HRHN", coll_file="RUS_9FLE1_02", lod=150, lodID=4238 },
		{ model=4223, model_file="RUS_9FLM_02", txd_file="RUS_HRHN", coll_file="RUS_9FLM_02", lod=150, lodID=4239 },
		{ model=4211, model_file="RUS_9FLE2_02", txd_file="RUS_HRHN", coll_file="RUS_9FLE2_02", lod=150, lodID=4347 },
		{ model=4939, model_file="ig_hrush_345", txd_file="hrush345", coll_file="ig_hrush_345", lod=150, lodID=4940 },
		{ model=4660, model_file="ign_skola1922", txd_file="pckz", coll_file="ign_skola1922", lod=150, lodID=4661 },
		{ model=4382, model_file="RUS_5FLN03", txd_file="RUS_HRHN", coll_file="RUS_5FLN03", lod=150, lodID=4386 },
		{ model=4674, model_file="russ_ibutskcity", txd_file="ibutskcity", coll_file="russ_ibutskcity", lod=150, lodID=4675 },
		{ model=5574, model_file="ne_gavno", txd_file="gavnomod_blds", coll_file="ne_gavno", lod=150, lodID=5575 },
		{ model=4662, model_file="russdosa", txd_file="dosaol", coll_file="russdosa", lod=150, lodID=4663 },
		{ model=4022, model_file="rus_medkol", txd_file="RUSRUS", coll_file="rus_medkol", lod=150, lodID=4023 },
		{ model=4410, model_file="RUS_ARPG01", txd_file="RUS_ATPCS", coll_file="RUS_ARPG01", lod=150, lodID=4419 },
		{ model=4403, model_file="RUS_ATPSIGN", txd_file="RUS_ATPCS", coll_file="RUS_ATPSIGN", lod=150 },
		{ model=4391, model_file="RUS_ADMBLD04", txd_file="RUS_HRHN", coll_file="RUS_ADMBLD04", lod=150, lodID=4395 },
		{ model=4688, model_file="avto_vokzal_builds", txd_file="avtovokzal_txd", coll_file="avto_vokzal_builds", lod=150 },
		{ model=4839, model_file="hertek_autos", txd_file="hertek", coll_file="hertek_autos", lod=150, lodID=5598 },
		{ model=5626, model_file="garage_door_work", txd_file="hertek", coll_file="garage_door_work", lod=299 },
		{ model=4090, model_file="c_sign03", txd_file="rus_neft", coll_file="c_sign03", lod=299 },
		{ model=4681, model_file="russ_port_dlc", txd_file="russ_port", coll_file="russ_port_dlc", lod=150 },
		{ model=4468, model_file="RUS_BE_CR01", txd_file="wbea", coll_file="RUS_BE_CR01", lod=150, lodID=4471 },
		{ model=4680, model_file="russ_port", txd_file="russ_port", coll_file="russ_port", lod=290, lodID=4683 },
		{ model=4682, model_file="russ_port_ladder", txd_file="russ_port", coll_file="russ_port_ladder", lod=150 },
		{ model=4684, model_file="russ_morvok", txd_file="morgorod_1", coll_file="russ_morvok", lod=150, lodID=4685 },
		{ model=4470, model_file="RUS_BE_MID200", txd_file="wbea", coll_file="RUS_BE_MID200", lod=150, lodID=4473 },
		{ model=4730, model_file="rus_caribstad", txd_file="rus_caribstad", coll_file="rus_caribstad", lod=150, lodID=4731 },
		{ model=4732, model_file="RUS_baza_otd", txd_file="RUS_baza_otd", coll_file="RUS_baza_otd", lod=90, lodID=4733 },
		{ model=3998, model_file="ig_16flr", txd_file="gavnomod_blds2", coll_file="ig_16flr", lod=150, lodID=3999 },
		{ model=4229, model_file="RUS_9FLE2_04", txd_file="RUS_HRHN", coll_file="RUS_9FLE2_04", lod=150, lodID=4380 },
		{ model=4232, model_file="RUS_9FLM_04", txd_file="RUS_HRHN", coll_file="RUS_9FLM_04", lod=150, lodID=4379 },
		{ model=4234, model_file="RUS_9FLE1_04", txd_file="RUS_HRHN", coll_file="RUS_9FLE1_04", lod=150, lodID=4378 },
		{ model=4755, model_file="rus_minecraft", txd_file="rus_minecraft", coll_file="rus_minecraft", lod=90, lodID=4756 },
		{ model=4686, model_file="russ_munibld01", txd_file="musob", coll_file="russ_munibld01", lod=150, lodID=4687 },
		{ model=5402, model_file="RTAIC_ROAD_PL50C01", txd_file="GRD", coll_file="RTAIC_ROAD_PL50C01", lod=150, lodID=5409 },
		{ model=5392, model_file="RTAIC_ROAD_PL50C", txd_file="GRD", coll_file="RTAIC_ROAD_PL50C", lod=150, lodID=5397 },
		{ model=5288, model_file="rus_sta_20d", txd_file="rus_staw_", coll_file="rus_sta_20d", lod=150, lodID=5289 },
		{ model=5299, model_file="rus_sta_20e1", txd_file="rus_staw_", coll_file="rus_sta_20e1", lod=150, lodID=5301 },
		{ model=5300, model_file="rus_sta_20e2", txd_file="rus_staw_", coll_file="rus_sta_20e2", lod=150, lodID=5303 },
		{ model=5520, model_file="bb_1", txd_file="gen_sht", coll_file="bb_1", lod=150 },
		{ model=4014, model_file="shop001", txd_file="shops", coll_file="shop001", lod=150 },
		{ model=4491, model_file="RUS_SUBMAR", txd_file="RUS_SUBMAR", coll_file="RUS_SUBMAR", lod=150, lodID=4492 },
		{ model=4077, model_file="rus_barge", txd_file="rus_barge", coll_file="rus_barge", lod=299, lodID=4078 },
		{ model=4076, model_file="rus_transskladLI", txd_file="INT_BURG", coll_file="rus_transskladLI", lod=150 },
		{ model=4073, model_file="rus_transsklad", txd_file="rus_transsklad", coll_file="rus_transsklad", lod=150, lodID=4075 },
		{ model=4074, model_file="rus_transskladA", txd_file="rus_transsklad", coll_file="rus_transskladA", lod=150 },
		{ model=4498, model_file="RUS_ETAGEM", txd_file="RUS_ETAGE", coll_file="RUS_ETAGEM", lod=150, lodID=4501 },
		{ model=4499, model_file="RUS_ETAGET", txd_file="RUS_CPS", coll_file="RUS_ETAGET", lod=150, lodID=4502 },
		{ model=4497, model_file="RUS_ETAGE", txd_file="RUS_ETAGE", coll_file="RUS_ETAGE", lod=150, lodID=4500 },
		{ model=4506, model_file="RUS_DMSVD", txd_file="RUS_ETAGE", coll_file="RUS_DMSVD", lod=150 },
		{ model=4505, model_file="RUS_DMSV", txd_file="RUS_ETAGE", coll_file="RUS_DMSV", lod=150, lodID=4507 },
		{ model=5622, model_file="ign_9flruk2", txd_file="gavnomod_3", coll_file="ign_9flruk2", lod=150, lodID=5623 },
		{ model=3990, model_file="gavnomag", txd_file="gavnomod_blds", coll_file="gavnomag", lod=150, lodID=3993 },
		{ model=3986, model_file="9flr_whtile", txd_file="gavnomod_blds", coll_file="9flr_whtile", lod=150, lodID=3987 },
		{ model=4512, model_file="RUS_ZAMOKG", txd_file="RUS_CPS", coll_file="RUS_ZAMOKG", lod=150, lodID=4513 },
		{ model=4519, model_file="RUS_NHR5F01", txd_file="RUS_NHR", coll_file="RUS_NHR5F01", lod=150, lodID=4525 },
		{ model=4529, model_file="RUS_NHR8F05", txd_file="RUS_NHR", coll_file="RUS_NHR8F05", lod=150, lodID=4539 },
		{ model=4531, model_file="RUS_NHR8F07", txd_file="RUS_NHR", coll_file="RUS_NHR8F07", lod=150, lodID=4551 },
		{ model=4517, model_file="RUS_NHR5F05", txd_file="RUS_NHR", coll_file="RUS_NHR5F05", lod=150, lodID=4523 },
		{ model=4532, model_file="RUS_NHR8F01", txd_file="RUS_NHR", coll_file="RUS_NHR8F01", lod=150, lodID=4552 },
		{ model=4516, model_file="RUS_NHR5F04", txd_file="RUS_NHR", coll_file="RUS_NHR5F04", lod=150, lodID=4522 },
		{ model=5283, model_file="ru_shop_g", txd_file="magi", coll_file="ru_shop_g", lod=150 },
		{ model=4515, model_file="RUS_NHR5F03", txd_file="RUS_NHR", coll_file="RUS_NHR5F03", lod=150, lodID=4521 },
		{ model=4526, model_file="RUS_NHR8F02", txd_file="RUS_NHR", coll_file="RUS_NHR8F02", lod=150, lodID=4534 },
		{ model=4689, model_file="rus_grz_skola", txd_file="rus_grz_skola", coll_file="rus_grz_skola", lod=150, lodID=4690 },
		{ model=4590, model_file="RUS_SEWERT", txd_file="RUS_NHR", coll_file="RUS_SEWERT", lod=150, lodID=4591 },
		{ model=5055, model_file="was_river_end", txd_file="wbea", coll_file="was_river_end", lod=150, lodID=4949 },
		{ model=4753, model_file="rus_NII_MAK", txd_file="rus_NII_MAK", coll_file="rus_NII_MAK", lod=90, lodID=4754 },
		{ model=4728, model_file="rus_FSB", txd_file="rus_FSB", coll_file="rus_FSB", lod=150, lodID=4729 },
		{ model=4757, model_file="rus_squadTEP", txd_file="rus_squadTEP", coll_file="rus_squadTEP", lod=90, lodID=4758 },
		{ model=4811, model_file="rus_univer_tep", txd_file="rus_univer_tep", coll_file="rus_univer_tep", lod=90, lodID=4812 },
		{ model=4761, model_file="rus_tep_klin", txd_file="rus_tep_klin", coll_file="rus_tep_klin", lod=90, lodID=4806 },
		{ model=4909, model_file="ig_stalin_brb", txd_file="stalinki", coll_file="ig_stalin_brb", lod=150, lodID=4914 },
		{ model=4912, model_file="ig_stalin_bre", txd_file="stalinki", coll_file="ig_stalin_bre", lod=150, lodID=4916 },
		{ model=4911, model_file="ig_stalin_brd", txd_file="stalinki", coll_file="ig_stalin_brd", lod=150, lodID=4915 },
		{ model=4886, model_file="ig_stalinka_cl03", txd_file="stalinki", coll_file="ig_stalinka_cl03", lod=150, lodID=4892 },
		{ model=4878, model_file="ig_stalinka_cl01", txd_file="stalinki", coll_file="ig_stalinka_cl01", lod=150, lodID=4889 },
		{ model=4880, model_file="ig_stalinka_cl02", txd_file="stalinki", coll_file="ig_stalinka_cl02", lod=150, lodID=4891 },
		{ model=4734, model_file="RUS_DK_Sanek", txd_file="RUS_DK_Sanek", coll_file="RUS_DK_Sanek", lod=150, lodID=4736 },
		{ model=4511, model_file="RUS_STALINB", txd_file="RUS_LENINS", coll_file="RUS_STALINB", lod=150 },
		{ model=4032, model_file="rus_tep_stella", txd_file="rusrus", coll_file="rus_tep_stella", lod=150, lodID=4033 },
		{ model=4759, model_file="rus_mem_1", txd_file="rus_squadTEP", coll_file="rus_mem_1", lod=90, lodID=4760 },
		{ model=4930, model_file="habar_ten_01", txd_file="habar_ten", coll_file="habar_ten_01", lod=150, lodID=4933 },
		{ model=4931, model_file="habar_ten_02", txd_file="habar_ten", coll_file="habar_ten_02", lod=150, lodID=4934 },
		{ model=4932, model_file="habar_ten_03", txd_file="habar_ten", coll_file="habar_ten_03", lod=150, lodID=4935 },
		{ model=4528, model_file="RUS_NHR8F04", txd_file="RUS_NHR", coll_file="RUS_NHR8F04", lod=150, lodID=4537 },
		{ model=4592, model_file="RUS_SEWER", txd_file="WBEA", coll_file="RUS_SEWER", lod=150, lodID=4593 },
		{ model=4577, model_file="RUS_TPMS", txd_file="RUS_SHP0", coll_file="RUS_TPMS", lod=150, lodID=4578 },
		{ model=5530, model_file="ig_city_tree", txd_file="vgs", coll_file="ig_city_tree", lod=60, lodID=5531 },
		{ model=4573, model_file="RUS_SHP01", txd_file="RUS_SHP0", coll_file="RUS_SHP01", lod=150 },
		{ model=4576, model_file="RUS_SHP03", txd_file="RUS_SHP0", coll_file="RUS_SHP03", lod=150 },
		{ model=4612, model_file="rus_club", txd_file="gavno1", coll_file="rus_club", lod=90, lodID=4628 },
		{ model=4574, model_file="RUS_SHP02", txd_file="RUS_SHP0", coll_file="RUS_SHP02", lod=150 },
		{ model=5540, model_file="bus_st", txd_file="car_park01", coll_file="bus_st", lod=150 },
		{ model=4580, model_file="RUS_ZN2", txd_file="RUS_NHR", coll_file="RUS_ZN2", lod=150, lodID=4586 },
		{ model=4581, model_file="RUS_ZN3", txd_file="RUS_NHR", coll_file="RUS_ZN3", lod=150, lodID=4587 },
		{ model=4579, model_file="RUS_ZN1", txd_file="RUS_NHR", coll_file="RUS_ZN1", lod=150, lodID=4584 },
		{ model=4583, model_file="RUS_ZN5", txd_file="RUS_NHR", coll_file="RUS_ZN5", lod=150, lodID=4589 },
		{ model=4582, model_file="RUS_ZN4", txd_file="RUS_NHR", coll_file="RUS_ZN4", lod=150, lodID=4588 }
	};

	local n,m;

	for n,m in ipairs(pTable) do
		pModels[m.model] = {
			id = m.model,
			name = m.model_file,
			txd = requestTexture(false, "textures/"..m.txd_file..".txd"),
			numStream = 0,
			lod = m.lod,
			lodID = m.lodID
		};
		pModelEntry = pModels[m.model];
       if (pModelEntry.txd) then
		    engineImportTXD(pModelEntry.txd, m.model);
       end
		pModelEntry.model=engineLoadDFF("models/"..m.model_file..".dff", m.model);
		pModelEntry.col=engineLoadCOL("coll/"..m.coll_file..".col");
		engineSetModelLODDistance(m.model, 10000);

		if (m.lodID) then
			for j,k in ipairs(getElementsByType("object", resourceRoot)) do
				if (getElementModel(k) == m.model) then
					local x, y, z = getElementPosition(k);
					local rx, ry, rz = getElementRotation(k);
					setLowLODElement(k, createObject(m.lodID, x, y, z, rx, ry, rz, true));
				end
			end
		end
	end

	for m,n in pairs(pModels) do
		if (n.super) and not (n.col) then
           local superModel = pModels[n.super];
           if (superModel) then
			    n.col = superModel.col;
           end
		end
	end
  
  for j,k in ipairs(getElementsByType("object", resourceRoot)) do
    local x, y, z = getElementPosition(k);
    x = x - 6000
    y = y - 6000
    z = z - 125
    setElementPosition(k,x,y,z)
  end
end
loadModels();

for m,n in ipairs(getElementsByType("object", resourceRoot)) do
	if (isElementStreamedIn(n)) then
		source = n;
		modelStreamIn();
	end
end

addEventHandler("onClientElementStreamIn", resourceRoot, function()
		modelStreamIn();
	end
);
addEventHandler("onClientElementStreamOut", resourceRoot, function()
		modelStreamOut();
	end
);

addEventHandler("onClientResourceStop", resourceRoot, function()
		for m,n in pairs(pModels) do
			if (isElement(n.col)) then destroyElement(n.col); end
			if (isElement(n.model)) then destroyElement(n.model); end
			engineRestoreCOL(m);
			engineRestoreModel(m);
		end
       for m,n in pairs(textureCache) do
           destroyElement(n);
       end
	end
);
collectgarbage("collect");
