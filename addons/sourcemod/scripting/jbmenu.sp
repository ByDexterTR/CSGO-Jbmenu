#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <clientprefs>
#include <fpvm_interface>

Cookie Cookie_Kredi = null;

ConVar g_kanbagis = null, 
g_baslangickredi = null, 
g_kredishowtype = null, 
g_kanbagisi = null, 
g_hizlikosmasure = null, 
g_kasakrediucret = null, 
g_kasaminhediye = null, 
g_kasamaxhediye = null, 
g_avcikelleodulu = null, 
g_hirsizdakika = null, 
g_hirsizodulu = null, 
g_terminatorcan = null, 
g_terminatorarmor = null, 
g_sanskasasican = null, 
g_hucrekapiacmaucret = null, 
g_whbombaucret = null, 
g_canlanmaucret = null, 
g_teleportgrenadeucret = null, 
g_saglikasisiucret = null, 
g_zehirlismokeucret = null, 
g_zehirlismokehasar = null, 
g_gardiyandondurmasure = null, 
g_gardiyandondurucret = null, 
g_gorunmezliksure = null, 
g_gorunmezlikucret = null, 
g_hizlikosmasureis = null, 
g_hizlikosmaucret = null, 
g_deagleucret = null, 
g_deaglemermi = null, 
g_depremsure = null, 
g_depremucret = null, 
g_autostrafeucret = null, 
g_autostrafeaktif = null, 
g_hucrekapisiozelligi = null, 
g_canlanmaozelligi = null, 
g_isinlanmabombaozelligi = null, 
g_zehirligazbombasiozelligi = null, 
g_gorunmezlikozelligi = null, 
g_hizlikosmaozelligi = null, 
g_kanbagislamaozelligi = null, 
g_gardiyandondurmaozelligi = null, 
g_saglikasisiozelligi = null, 
g_whbombasiozelligi = null, 
g_deagleozelligi = null, 
g_depremozelligi = null, 
g_meslekavci = null, 
g_meslekhirsiz = null, 
g_meslekbombaci = null, 
g_meslekterminator = null, 
g_aktifoynamasure = null, 
g_aktifoynamaodul = null, 
g_ctoldurmaodul = null, 
g_hayattkalmaodul = null, 
g_levyehasar = null, 
g_levyeucret = null, 
g_levyeaktif = null, 
g_cekichasar = null, 
g_cekicucret = null, 
g_cekicaktif = null, 
g_suikasthasar = null, 
g_suikastucret = null, 
g_suikastaktif = null, 
g_kutsalbuzhasar = null, 
g_kutsalbuzucret = null, 
g_kutsalbuzaktif = null, 
g_kutsallavhasar = null, 
g_kutsallavucret = null, 
g_kutsallavaktif = null;

bool Kullanildi[MAXPLAYERS] =  { false, ... }, 
AutoStrafer[MAXPLAYERS] =  { false, ... }, 
KasaActimi[MAXPLAYERS] =  { false, ... }, 
MeslekKullandimi[MAXPLAYERS] =  { false, ... }, 
Teleportlayicibomba[MAXPLAYERS] =  { false, ... }, 
zehirlismokeasahip[MAXPLAYERS] =  { false, ... }, 
Avci[MAXPLAYERS] =  { false, ... };

float g_LastGain[MAXPLAYERS];

Handle h_timer[MAXPLAYERS] = null, 
h_hirsiztimer[MAXPLAYERS] = null;

int Meslegi[MAXPLAYERS] =  { 0, ... }, 
Customknife[MAXPLAYERS] =  { 0, ... }, 
Dakika[MAXPLAYERS] =  { 0, ... }, 
g_sprite = -1, 
g_HaloSprite = -1;

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Jbmenü", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	LoadTranslations("common.phrases");
	HookEvent("round_start", RoundStart, EventHookMode_PostNoCopy);
	HookEvent("round_end", HayattaKalanlar, EventHookMode_PostNoCopy);
	HookEvent("player_death", OnClientDead, EventHookMode_PostNoCopy);
	HookEvent("player_spawn", OnClientSpawn, EventHookMode_PostNoCopy);
	HookEvent("smokegrenade_detonate", SmokeGrenade_Detonate, EventHookMode_Post);
	
	RegConsoleCmd("sm_jbmenu", Command_JBMenu);
	RegConsoleCmd("sm_jb", Command_JB);
	RegAdminCmd("sm_jbver", Command_JBVer, ADMFLAG_ROOT);
	RegAdminCmd("sm_jbal", Command_JBAl, ADMFLAG_ROOT);
	RegAdminCmd("sm_jbduzelt", Command_JBDuzelt, ADMFLAG_ROOT);
	RegConsoleCmd("sm_jbhediye", Command_JBHediye);
	
	Cookie_Kredi = new Cookie("Dexter-JBKredi", "Sahip oldugunuz jb kredisi", CookieAccess_Protected);
	
	g_kutsallavaktif = CreateConVar("sm_jbmenu_kutsallav_aktif", "1", "Bıçak menü kutsal ateş bıçağı olsun mu?", 0, true, 0.0, true, 1.0);
	g_kutsalbuzaktif = CreateConVar("sm_jbmenu_kutsalbuz_aktif", "1", "Bıçak menü kutsal buz bıçağı olsun mu?", 0, true, 0.0, true, 1.0);
	g_suikastaktif = CreateConVar("sm_jbmenu_suikast_aktif", "1", "Bıçak menü suikastçı bıçağı olsun mu?", 0, true, 0.0, true, 1.0);
	g_cekicaktif = CreateConVar("sm_jbmenu_cekic_aktif", "1", "Bıçak menü çekiç olsun mu ?", 0, true, 0.0, true, 1.0);
	g_levyeaktif = CreateConVar("sm_jbmenu_levye_aktif", "1", "Bıçak menü levye olsun mu ?", 0, true, 0.0, true, 1.0);
	
	g_kutsallavucret = CreateConVar("sm_jbmenu_kutsalates_ucret", "85", "Bıçak menü kutsal ateş bıçağı ücret", 0, true, 1.0);
	g_kutsalbuzucret = CreateConVar("sm_jbmenu_kutsalbuz_ucret", "85", "Bıçak menü kutsal buz bıçağı ücret", 0, true, 1.0);
	g_suikastucret = CreateConVar("sm_jbmenu_suikast_ucret", "50", "Bıçak menü suikast bıçağı ücret", 0, true, 1.0);
	g_cekicucret = CreateConVar("sm_jbmenu_cekic_ucret", "10", "Bıçak menü çekiç kullanana verilecek ücret", 0, true, 1.0);
	g_levyeucret = CreateConVar("sm_jbmenu_levye_ucret", "5", "Bıçak menü levye kullanana verilecek ücret", 0, true, 1.0);
	
	g_kutsallavhasar = CreateConVar("sm_jbmenu_kutsalates_hasar", "65", "Bıçak menü kutsal ateş bıçağı hasarı", 0, true, 1.0);
	g_kutsalbuzhasar = CreateConVar("sm_jbmenu_kutsalbuz_hasar", "65", "Bıçak menü kutsal buz bıçağı hasarı", 0, true, 1.0);
	g_suikasthasar = CreateConVar("sm_jbmenu_suikast_hasar", "80", "Bıçak menü suikastçı bıçağı hasarı", 0, true, 1.0);
	g_cekichasar = CreateConVar("sm_jbmenu_cekic_hasar", "40", "Bıçak menü çekiç hasarı", 0, true, 1.0);
	g_levyehasar = CreateConVar("sm_jbmenu_levye_hasar", "35", "Bıçak menü levye hasarı", 0, true, 1.0);
	
	g_hayattkalmaodul = CreateConVar("sm_jbmenu_gorev_hayattakalma_odul", "3", "Hayatta kalma görevinin ödülü", 0, true, 1.0);
	g_ctoldurmaodul = CreateConVar("sm_jbmenu_gorev_ctoldurme_odul", "3", "CT öldürme görevinin ödülü", 0, true, 1.0);
	g_aktifoynamaodul = CreateConVar("sm_jbmenu_gorev_oynama_odul", "20", "Oynama görevinin ödülü", 0, true, 1.0);
	g_aktifoynamasure = CreateConVar("sm_jbmenu_gorev_oynama_sure", "10", "Görevin yapılması için kaç dakika oynanması gerekir?", 0, true, 1.0);
	
	g_meslekterminator = CreateConVar("sm_jbmenu_meslek_terminator", "1", "Meslek menüde terminatör mesleği olsun mu?", 0, true, 0.0, true, 1.0);
	g_meslekterminator.AddChangeHook(ConVarChanged);
	g_meslekbombaci = CreateConVar("sm_jbmenu_meslek_bombaci", "1", "Meslek menüde bombacı mesleği olsun mu?", 0, true, 0.0, true, 1.0);
	g_meslekbombaci.AddChangeHook(ConVarChanged);
	g_meslekhirsiz = CreateConVar("sm_jbmenu_meslek_hirsiz", "1", "Meslek menüde hırsız mesleği olsun mu?", 0, true, 0.0, true, 1.0);
	g_meslekhirsiz.AddChangeHook(ConVarChanged);
	g_meslekavci = CreateConVar("sm_jbmenu_meslek_avci", "1", "Meslek menüde avcı mesleği olsun mu?", 0, true, 0.0, true, 1.0);
	g_meslekavci.AddChangeHook(ConVarChanged);
	
	g_autostrafeaktif = CreateConVar("sm_jbmenu_autostrafe_ozelligi", "1", "İsyan menü auto strafe olsun mu ?", 0, true, 0.0, true, 1.0);
	g_depremozelligi = CreateConVar("sm_jbmenu_deprem_ozelligi", "1", "İsyan menü deprem olsun mu ?", 0, true, 0.0, true, 1.0);
	g_deagleozelligi = CreateConVar("sm_jbmenu_deagle_ozelligi", "1", "İsyan menü X mermili deagle olsun mu ?", 0, true, 0.0, true, 1.0);
	g_whbombasiozelligi = CreateConVar("sm_jbmenu_whbombasi_ozelligi", "1", "İsyan menü sağlık aşısı olsun mu ?", 0, true, 0.0, true, 1.0);
	g_saglikasisiozelligi = CreateConVar("sm_jbmenu_saglikasisi_ozelligi", "1", "İsyan menü sağlık aşısı olsun mu ?", 0, true, 0.0, true, 1.0);
	g_gardiyandondurmaozelligi = CreateConVar("sm_jbmenu_gardiyandondurma_ozelligi", "1", "İsyan menüde gardiyanları dondurma olsun mu ?", 0, true, 0.0, true, 1.0);
	g_hizlikosmaozelligi = CreateConVar("sm_jbmenu_hizlikosma_ozelligi", "1", "İsyan menüde hızlı koşma olsun mu ?", 0, true, 0.0, true, 1.0);
	g_gorunmezlikozelligi = CreateConVar("sm_jbmenu_gorunumezlik_ozelligi", "1", "İsyan menüde görünmezlik olsun mu ?", 0, true, 0.0, true, 1.0);
	g_zehirligazbombasiozelligi = CreateConVar("sm_jbmenu_zehirlismoke_ozelligi", "1", "İsyan menüde zehirli smoke olsun mu ?", 0, true, 0.0, true, 1.0);
	g_isinlanmabombaozelligi = CreateConVar("sm_jbmenu_isinlanmabomba_ozelligi", "1", "İsyan menüde ışınlanma bombası olsun mu ?", 0, true, 0.0, true, 1.0);
	g_canlanmaozelligi = CreateConVar("sm_jbmenu_canlanma_ozelligi", "1", "İsyan menüde yeniden canlanma olsun mu ?", 0, true, 0.0, true, 1.0);
	g_hucrekapisiozelligi = CreateConVar("sm_jbmenu_hucrekapi_ozelligi", "1", "İsyan menüde Hücre kapısını bozma olsun mu ?", 0, true, 0.0, true, 1.0);
	
	g_autostrafeucret = CreateConVar("sm_jbmenu_deprem_ucret", "800", "İsyan menü auto strafe ücreti", 0, true, 1.0);
	g_depremucret = CreateConVar("sm_jbmenu_deprem_ucret", "300", "İsyan menü X saniye deprem ücreti", 0, true, 1.0);
	g_deagleucret = CreateConVar("sm_jbmenu_deagle_ucret", "400", "İsyan menü X mermili deagle bombası ücreti", 0, true, 1.0);
	g_whbombaucret = CreateConVar("sm_jbmenu_whbombasi_ucret", "300", "İsyan menü wall hack bombası ücreti", 0, true, 1.0);
	g_saglikasisiucret = CreateConVar("sm_jbmenu_saglikasisi_ucret", "300", "İsyan menü sağlık aşısı ücreti", 0, true, 1.0);
	g_gardiyandondurucret = CreateConVar("sm_jbmenu_gardiyandondurma_ucret", "300", "İsyan menü gardiyan dondurma ücreti", 0, true, 1.0);
	g_hizlikosmaucret = CreateConVar("sm_jbmenu_hizli_kosma_ucret", "250", "İsyan menü hızlı koşma ücreti", 0, true, 1.0);
	g_gorunmezlikucret = CreateConVar("sm_jbmenu_gorunumezlik_ucret", "250", "İsyan menü görünmezlik ücreti", 0, true, 1.0);
	g_zehirlismokeucret = CreateConVar("sm_jbmenu_zehirlismoke_ucret", "200", "İsyan menü zehirli smoke ücreti", 0, true, 1.0);
	g_canlanmaucret = CreateConVar("sm_jbmenu_canlanma_ucret", "150", "İsyan menü canlanma ücreti", 0, true, 1.0);
	g_teleportgrenadeucret = CreateConVar("sm_jbmenu_teleportbomba_ucret", "200", "İsyan menü ışınlanma bombasının ücreti", 0, true, 1.0);
	g_hucrekapiacmaucret = CreateConVar("sm_jbmenu_hucreacma_ucret", "500", "İsyan menü hücre kapısı açma ücreti", 0, true, 1.0);
	
	g_depremsure = CreateConVar("sm_jbmenu_deprem_sure", "5", "İsyan menü deprem süresi", 0, true, 1.0);
	g_deaglemermi = CreateConVar("sm_jbmenu_deagle_mermi", "8", "İsyan menü deagle mermi", 0, true, 1.0);
	g_gardiyandondurmasure = CreateConVar("sm_jbmenu_gardidyandondurma_sure", "5", "İsyan menü gardiyan dondurma süresi", 0, true, 1.0);
	g_hizlikosmasureis = CreateConVar("sm_jbmenu_hizlikosma_sure", "10", "İsyan menü hızlı koşma süresi", 0, true, 1.0);
	g_gorunmezliksure = CreateConVar("sm_jbmenu_gorunumezlik_sure", "5", "İsyan menü görünmezlik süresi", 0, true, 1.0);
	g_zehirlismokehasar = CreateConVar("sm_jbmenu_zehirlismoke_hasar", "25", "İsyan menü zehirli smoke hasarı", 0, true, 1.0);
	
	g_baslangickredi = CreateConVar("sm_jbmenu_baslangic_kredi", "10", "İlk defa giren oyuncular kaç krediyle başlasın", 0, true, 0.0);
	
	g_sanskasasican = CreateConVar("sm_jbmenu_kasa_hp", "50", "Şans kasasından çıkacak can değeri", 0, true, 1.0);
	g_kasakrediucret = CreateConVar("sm_jbmenu_kasa_ucret", "20", "Şans kutusu ücreti", 0, true, 1.0);
	g_kasaminhediye = CreateConVar("sm_jbmenu_kasa_minhediye", "5", "Şans kutusundan çıkıcak en az kredi", 0, true, 0.0);
	g_kasamaxhediye = CreateConVar("sm_jbmenu_kasa_maxhediye", "40", "Şans kutusundan çıkıcak en fazla kredi", 0, true, 1.0);
	g_hizlikosmasure = CreateConVar("sm_jbmenu_kasa_hizlikosma_sure", "8", "Şans kutusundan çıkan hızlı koşma özelliği kaç saniye", 0, true, 1.0);
	
	g_terminatorcan = CreateConVar("sm_jbmenu_terminator_hp", "150", "Terminatör mesleği can değeri", 0, true, 1.0);
	g_terminatorarmor = CreateConVar("sm_jbmenu_terminator_armor", "50", "Terminatör mesleği armor", 0, true, 1.0);
	g_hirsizdakika = CreateConVar("sm_jbmenu_hirsiz_dakika", "2", "Hırsız mesleği tur boyunca kaç dakika arayla kredi kazansın", 0, true, 1.0);
	g_hirsizodulu = CreateConVar("sm_jbmenu_hirsiz_odul", "5", "Hırsız mesleği kaç kredi kazansın", 0, true, 1.0);
	g_avcikelleodulu = CreateConVar("sm_jbmenu_avci_odul", "5", "Avcı mesleği ct öldürmesi üstüne kaç kredi kazansın", 0, true, 1.0);
	
	g_kanbagisi = CreateConVar("sm_jbmenu_kanbagis_can", "99", "Kaç can bağışlansın?", 0, true, 1.0);
	g_kanbagislamaozelligi = CreateConVar("sm_jbmenu_kanbagis", "1", "Kan bağışlama olsun mu?", 0, true, 0.0, true, 1.0);
	g_kanbagis = CreateConVar("sm_jbmenu_kanbagis_kredi", "10", "Kan bağışlayan oyuncuya kaç kredi verilsin?", 0, true, 1.0);
	
	g_kredishowtype = CreateConVar("sm_jbmenu_kredi_gosteris", "0", "!jb Yazılınca oyuncunun kredisini? 0 = Sadece Kendi | 1 = Herkes", 0, true, 0.0, true, 1.0);
	
	AutoExecConfig(true, "Jbmenu");
	
	for (int i = 1; i <= MaxClients; i++)if (IsValidClient(i))
		OnClientCookiesCached(i);
}

public void OnMapStart()
{
	g_sprite = PrecacheModel("materials/sprites/laserbeam.vmt", true);
	g_HaloSprite = PrecacheModel("materials/sprites/halo.vmt", true);
	
	PrecacheAndMaterialDownloader("models/weapons/V_crowbar/crowbar_cyl");
	AddFileToDownloadsTable("materials/models/weapons/V_crowbar/head_uvw.vmt");
	AddFileToDownloadsTable("materials/models/weapons/V_crowbar/head_normal.vtf");
	AddFileToDownloadsTable("materials/models/weapons/V_crowbar/head.vtf");
	AddFileToDownloadsTable("materials/models/weapons/V_crowbar/crowbar_normal.vtf");
	PrecacheAndModelDownloader2("weapons/Dzucht/crowbar/crowbar");
	PrecacheAndModelDownloader("weapons/Dzucht/crowbar/w_crowbar");
	
	PrecacheAndMaterialDownloader("models/weapons/eminem/hammer/sandvik");
	AddFileToDownloadsTable("materials/models/weapons/eminem/hammer/sandvik_normal.vtf");
	PrecacheAndModelDownloader2("weapons/eminem/hammer/v_hammer");
	PrecacheAndModelDownloader("weapons/eminem/hammer/w_hammer");
	
	PrecacheAndMaterialDownloader("models/weapons/kolka/None_Base_Color");
	AddFileToDownloadsTable("materials/models/weapons/kolka/None_Normal_DirectX.vtf");
	PrecacheAndModelDownloader2("weapons/kolka/v_cyberknife");
	PrecacheAndModelDownloader("weapons/kolka/w_cyberknife");
	
	PrecacheAndMaterialDownloader("models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/fire");
	PrecacheAndMaterialDownloader("models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/frost");
	AddFileToDownloadsTable("materials/models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/normal.vtf");
	PrecacheAndModelDownloader2("weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/v_goteor_frost");
	PrecacheAndModelDownloader2("weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/w_goteor_frost");
	PrecacheAndModelDownloader2("weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/v_goteor_fire");
	PrecacheAndModelDownloader2("weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/w_goteor_fire");
}

public void OnClientCookiesCached(int client)
{
	if (IsValidClient(client))
	{
		SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
		CreateTimer(60.0, DakikaHesapla, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
		AutoStrafer[client] = false;
		Kullanildi[client] = false;
		KasaActimi[client] = false;
		MeslekKullandimi[client] = false;
		Teleportlayicibomba[client] = false;
		Avci[client] = false;
		zehirlismokeasahip[client] = false;
		Meslegi[client] = 0;
		Dakika[client] = 0;
		Customknife[client] = 0;
		char sBuffer[512];
		Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
		if (strcmp(sBuffer, "", false) == 0)
		{
			FormatEx(sBuffer, sizeof(sBuffer), "%d", g_baslangickredi.IntValue);
			Cookie_Kredi.Set(client, sBuffer);
		}
	}
}

public Action Command_JB(int client, int args)
{
	char sBuffer[512];
	Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
	if (!g_kredishowtype.BoolValue)
		PrintToChat(client, "[SM] Mevcut TL: \x04%d", StringToInt(sBuffer));
	else
		PrintToChatAll("[SM] \x10%N \x01Mevcut TL: \x04%d", client, StringToInt(sBuffer));
	
	return Plugin_Handled;
}

public Action Command_JBDuzelt(int client, int args)
{
	if (args != 2)
	{
		ReplyToCommand(client, "[SM] Kullanım: sm_jbduzelt <Hedef> <Miktar>");
		return Plugin_Handled;
	}
	else
	{
		char arg1[192];
		GetCmdArg(1, arg1, sizeof(arg1));
		int target = FindTarget(client, arg1, true, true);
		if (target == COMMAND_TARGET_NONE || target == COMMAND_TARGET_AMBIGUOUS || target == COMMAND_TARGET_IMMUNE)
		{
			ReplyToTargetError(client, target);
			return Plugin_Handled;
		}
		else
		{
			char arg2[192];
			GetCmdArg(2, arg2, sizeof(arg2));
			if (StringToInt(arg2) <= 0)
			{
				ReplyToCommand(client, "[SM] 0'dan büyük bir değer girmelisin!");
				return Plugin_Handled;
			}
			else
			{
				if (!IsValidClient(target))
				{
					ReplyToCommand(client, "[SM] Hedeflediğiniz oyuncu geçersiz!");
					return Plugin_Handled;
				}
				else
				{
					char sBuffer[512];
					FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(arg2));
					Cookie_Kredi.Set(client, sBuffer);
					PrintToChatAll("[SM] \x10%N \x01admin \x10%N \x01kişisinin TLsini \x04%d \x01olarak düzeltti!", client, target, StringToInt(arg2));
					return Plugin_Handled;
				}
			}
		}
	}
}


public Action Command_JBAl(int client, int args)
{
	if (args != 2)
	{
		ReplyToCommand(client, "[SM] Kullanım: sm_jbal <Hedef> <Miktar>");
		return Plugin_Handled;
	}
	else
	{
		char arg1[192];
		GetCmdArg(1, arg1, sizeof(arg1));
		int target = FindTarget(client, arg1, true, true);
		if (target == COMMAND_TARGET_NONE || target == COMMAND_TARGET_AMBIGUOUS || target == COMMAND_TARGET_IMMUNE)
		{
			ReplyToTargetError(client, target);
			return Plugin_Handled;
		}
		else
		{
			char arg2[192];
			GetCmdArg(2, arg2, sizeof(arg2));
			if (StringToInt(arg2) <= 0)
			{
				ReplyToCommand(client, "[SM] 0'dan büyük bir değer girmelisin!");
				return Plugin_Handled;
			}
			else
			{
				if (!IsValidClient(target))
				{
					ReplyToCommand(client, "[SM] Hedeflediğiniz oyuncu geçersiz!");
					return Plugin_Handled;
				}
				else
				{
					char sBuffer[512];
					Cookie_Kredi.Get(target, sBuffer, sizeof(sBuffer));
					FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - StringToInt(arg2));
					Cookie_Kredi.Set(target, sBuffer);
					PrintToChatAll("[SM] \x10%N \x01admin \x10%N \x01kişisinden \x04%d \x01TL aldı!", client, target, StringToInt(arg2));
					return Plugin_Handled;
				}
			}
		}
	}
}

public Action Command_JBVer(int client, int args)
{
	if (args != 2)
	{
		ReplyToCommand(client, "[SM] Kullanım: sm_jbver <Hedef> <Miktar>");
		return Plugin_Handled;
	}
	else
	{
		char arg1[192];
		GetCmdArg(1, arg1, sizeof(arg1));
		int target = FindTarget(client, arg1, true, true);
		if (target == COMMAND_TARGET_NONE || target == COMMAND_TARGET_AMBIGUOUS || target == COMMAND_TARGET_IMMUNE)
		{
			ReplyToTargetError(client, target);
			return Plugin_Handled;
		}
		else
		{
			char arg2[192];
			GetCmdArg(2, arg2, sizeof(arg2));
			if (StringToInt(arg2) <= 0)
			{
				ReplyToCommand(client, "[SM] 0'dan büyük bir değer girmelisin!");
				return Plugin_Handled;
			}
			else
			{
				if (!IsValidClient(target))
				{
					ReplyToCommand(client, "[SM] Hedeflediğiniz oyuncu geçersiz!");
					return Plugin_Handled;
				}
				else
				{
					char sBuffer[512];
					Cookie_Kredi.Get(target, sBuffer, sizeof(sBuffer));
					FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + StringToInt(arg2));
					Cookie_Kredi.Set(target, sBuffer);
					PrintToChatAll("[SM] \x10%N \x01admin \x10%N \x01kişisine \x04%d \x01TL verdi!", client, target, StringToInt(arg2));
					return Plugin_Handled;
				}
			}
		}
	}
}

public Action Command_JBHediye(int client, int args)
{
	if (args != 2)
	{
		ReplyToCommand(client, "[SM] Kullanım: sm_jbhediye <Hedef> <Miktar>");
		return Plugin_Handled;
	}
	else
	{
		char arg1[192];
		GetCmdArg(1, arg1, sizeof(arg1));
		int target = FindTarget(client, arg1, true, false);
		if (target == COMMAND_TARGET_NONE || target == COMMAND_TARGET_AMBIGUOUS)
		{
			ReplyToTargetError(client, target);
			return Plugin_Handled;
		}
		else
		{
			char arg2[192];
			GetCmdArg(2, arg2, sizeof(arg2));
			if (StringToInt(arg2) <= 0)
			{
				ReplyToCommand(client, "[SM] 0'dan büyük bir değer girmelisin!");
				return Plugin_Handled;
			}
			else
			{
				if (!IsValidClient(target))
				{
					ReplyToCommand(client, "[SM] Hedeflediğiniz oyuncu geçersiz!");
					return Plugin_Handled;
				}
				else
				{
					char sBuffer[512];
					Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
					if (StringToInt(sBuffer) >= StringToInt(arg2))
					{
						FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - StringToInt(arg2));
						Cookie_Kredi.Set(client, sBuffer);
						Cookie_Kredi.Get(target, sBuffer, sizeof(sBuffer));
						FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + StringToInt(arg2));
						Cookie_Kredi.Set(target, sBuffer);
						PrintToChatAll("[SM] \x10%N\x01, \x10%N \x01kişisine \x04%d \x01TL hediye etti!", client, target, StringToInt(arg2));
						return Plugin_Handled;
					}
					else
					{
						ReplyToCommand(client, "[SM] O kadar TLen yok, Mevcut TL: %d", StringToInt(sBuffer));
						return Plugin_Handled;
					}
				}
			}
		}
	}
}

public Action Command_JBMenu(int client, int args)
{
	if (GetClientTeam(client) != CS_TEAM_T)
	{
		ReplyToCommand(client, "[SM] Bu menüye erişiminiz yok.");
		return Plugin_Handled;
	}
	else
	{
		if (args != 0)
		{
			ReplyToCommand(client, "[SM] Kullanım: sm_jbmenu");
			return Plugin_Handled;
		}
		else
		{
			Jbmenu(client).Display(client, MENU_TIME_FOREVER);
			return Plugin_Handled;
		}
	}
}

Menu Jbmenu(int client)
{
	char sBuffer[512], MenuFormat[256];
	Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
	Menu menu = new Menu(Menu_CallBack);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n        ★ Jail Menü ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬");
	menu.AddItem("0", "Bıçak Menü");
	menu.AddItem("1", "İsyan Menü");
	menu.AddItem("2", "Meslek Menü");
	menu.AddItem("3", "Görev Menü");
	menu.AddItem("4", "Şans Kasası");
	
	Format(MenuFormat, sizeof(MenuFormat), "%d Kan Bağışla +%d TL\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nMevcut TL: %d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬", g_kanbagisi.IntValue, g_kanbagis.IntValue, StringToInt(sBuffer));
	if (g_kanbagislamaozelligi.BoolValue && !Kullanildi[client] && GetClientHealth(client) > 99)
		menu.AddItem("5", MenuFormat);
	else
		menu.AddItem("5", MenuFormat, ITEMDRAW_DISABLED);
	
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	return menu;
}

public int Menu_CallBack(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select)
	{
		if (GetClientTeam(client) != CS_TEAM_T)
		{
			PrintToChat(client, "[SM] Bu menüye erişiminiz yok.");
		}
		else
		{
			char Item[4];
			menu.GetItem(position, Item, sizeof(Item));
			if (strcmp(Item, "0", false) == 0)
			{
				Bicakmenu(client).Display(client, MENU_TIME_FOREVER);
			}
			else if (strcmp(Item, "1", false) == 0)
			{
				Isyanmenu(client).Display(client, MENU_TIME_FOREVER);
			}
			else if (strcmp(Item, "2", false) == 0)
			{
				Meslekmenu(client).Display(client, MENU_TIME_FOREVER);
			}
			else if (strcmp(Item, "3", false) == 0)
			{
				Gorevmenu().Display(client, MENU_TIME_FOREVER);
			}
			else if (strcmp(Item, "4", false) == 0)
			{
				Sansmenu(client).Display(client, MENU_TIME_FOREVER);
			}
			else if (strcmp(Item, "5", false) == 0)
			{
				if (g_kanbagislamaozelligi.BoolValue && !Kullanildi[client])
				{
					if (GetClientHealth(client) > g_kanbagisi.IntValue)
					{
						SetEntityHealth(client, GetClientHealth(client) - g_kanbagisi.IntValue);
						char sBuffer[512];
						Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
						FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_kanbagis.IntValue);
						Cookie_Kredi.Set(client, sBuffer);
						Kullanildi[client] = true;
						PrintToChat(client, "[SM] Kızılaya kan bağışladığın için +%d TL kazandın", g_kanbagis.IntValue);
						Jbmenu(client).Display(client, MENU_TIME_FOREVER);
					}
					else
					{
						PrintToChat(client, "[SM] Yeterli Can miktarın yok!");
					}
				}
				else
				{
					PrintToChat(client, "[SM] Hata algılandı!");
					Jbmenu(client).Display(client, MENU_TIME_FOREVER);
				}
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

Menu Bicakmenu(int client)
{
	char Secenek[128], sBuffer[512];
	Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
	Menu menu = new Menu(Menu6_Callback);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n        ★ Bıçak Menü ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬");
	if (g_levyeaktif.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Levye ( +%d TL [ %d Hasar ] )", g_levyeucret.IntValue, g_levyehasar.IntValue);
		if (IsPlayerAlive(client) && Customknife[client] == 0)
			menu.AddItem("0", Secenek);
		else
			menu.AddItem("0", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("0", "Levye [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_cekicaktif.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Çekiç ( +%d TL [ %d Hasar ] )", g_cekicucret.IntValue, g_cekichasar.IntValue);
		if (IsPlayerAlive(client) && Customknife[client] == 0)
			menu.AddItem("1", Secenek);
		else
			menu.AddItem("1", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("1", "Çekiç [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_suikastaktif.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Suikastçı Bıçağı ( %d TL [ %d Hasar ] )", g_suikastucret.IntValue, g_suikasthasar.IntValue);
		if (StringToInt(sBuffer) >= g_suikastucret.IntValue && IsPlayerAlive(client) && Customknife[client] == 0)
			menu.AddItem("2", Secenek);
		else
			menu.AddItem("2", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("2", "Suikastçı Bıçağı [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_kutsalbuzaktif.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Kutsal Buz Bıçağı ( %d TL [ %d Hasar + Yavaşlaştır ] )", g_kutsalbuzucret.IntValue, g_kutsalbuzhasar.IntValue);
		if (StringToInt(sBuffer) >= g_kutsalbuzucret.IntValue && IsPlayerAlive(client) && Customknife[client] == 0)
			menu.AddItem("3", Secenek);
		else
			menu.AddItem("3", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("3", "Kutsal Buz Bıçağı [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_kutsallavaktif.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Kutsal Ateş Bıçağı ( %d TL [ %d Hasar + Yakar ] )", g_kutsallavucret.IntValue, g_kutsallavhasar.IntValue);
		if (StringToInt(sBuffer) >= g_kutsallavucret.IntValue && IsPlayerAlive(client) && Customknife[client] == 0)
			menu.AddItem("4", Secenek);
		else
			menu.AddItem("4", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("4", "Kutsal Ateş Bıçağı [ KAPALI ]", ITEMDRAW_DISABLED);
	menu.ExitBackButton = false;
	menu.ExitButton = true;
	return menu;
}

public int Menu6_Callback(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select)
	{
		char Item[4], sBuffer[512];
		menu.GetItem(position, Item, sizeof(Item));
		Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
		if (strcmp(Item, "0", false) == 0)
		{
			if (g_levyeaktif.BoolValue && IsPlayerAlive(client) && Customknife[client] == 0)
			{
				FPVMI_RemoveViewModelToClient(client, "weapon_knife");
				FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
				int NayfV = PrecacheModel("models/weapons/Dzucht/crowbar/crowbar.mdl");
				int NayfW = PrecacheModel("models/weapons/Dzucht/crowbar/w_crowbar.mdl");
				FPVMI_AddViewModelToClient(client, "weapon_knife", NayfV);
				FPVMI_AddWorldModelToClient(client, "weapon_knife", NayfW);
				PrintToChat(client, "[SM] Levye satın aldın.");
				Customknife[client] = 1;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_levyeucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "1", false) == 0)
		{
			if (g_cekicaktif.BoolValue && IsPlayerAlive(client) && Customknife[client] == 0)
			{
				FPVMI_RemoveViewModelToClient(client, "weapon_knife");
				FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
				int NayfV = PrecacheModel("models/weapons/eminem/hammer/v_hammer.mdl");
				int NayfW = PrecacheModel("models/weapons/eminem/hammer/w_hammer.mdl");
				FPVMI_AddViewModelToClient(client, "weapon_knife", NayfV);
				FPVMI_AddWorldModelToClient(client, "weapon_knife", NayfW);
				PrintToChat(client, "[SM] Çekiç satın aldın.");
				Customknife[client] = 2;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_cekicucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "2", false) == 0)
		{
			if (g_suikastaktif.BoolValue && StringToInt(sBuffer) >= g_suikastucret.IntValue && IsPlayerAlive(client) && Customknife[client] == 0)
			{
				FPVMI_RemoveViewModelToClient(client, "weapon_knife");
				FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
				int NayfV = PrecacheModel("models/weapons/kolka/v_cyberknife.mdl");
				int NayfW = PrecacheModel("models/weapons/kolka/w_cyberknife.mdl");
				FPVMI_AddViewModelToClient(client, "weapon_knife", NayfV);
				FPVMI_AddWorldModelToClient(client, "weapon_knife", NayfW);
				PrintToChat(client, "[SM] Suikastçı bıçağı satın aldın.");
				Customknife[client] = 3;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_suikastucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "3", false) == 0)
		{
			if (g_kutsalbuzaktif.BoolValue && StringToInt(sBuffer) >= g_kutsalbuzucret.IntValue && IsPlayerAlive(client) && Customknife[client] == 0)
			{
				FPVMI_RemoveViewModelToClient(client, "weapon_knife");
				FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
				int NayfV = PrecacheModel("models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/v_goteor_frost.mdl");
				int NayfW = PrecacheModel("models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/w_goteor_frost.mdl");
				FPVMI_AddViewModelToClient(client, "weapon_knife", NayfV);
				FPVMI_AddWorldModelToClient(client, "weapon_knife", NayfW);
				PrintToChat(client, "[SM] Kutsal buz bıçağı satın aldın.");
				Customknife[client] = 4;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_kutsalbuzucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "4", false) == 0)
		{
			if (g_kutsallavaktif.BoolValue && StringToInt(sBuffer) >= g_kutsallavucret.IntValue && IsPlayerAlive(client) && Customknife[client] == 0)
			{
				FPVMI_RemoveViewModelToClient(client, "weapon_knife");
				FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
				int NayfV = PrecacheModel("models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/v_goteor_fire.mdl");
				int NayfW = PrecacheModel("models/weapons/eminem/dota2/knife/grace_of_the_eminence_of_ristul/w_goteor_fire.mdl");
				FPVMI_AddViewModelToClient(client, "weapon_knife", NayfV);
				FPVMI_AddWorldModelToClient(client, "weapon_knife", NayfW);
				PrintToChat(client, "[SM] Kutsal ateş bıçağı satın aldın.");
				Customknife[client] = 5;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_kutsallavucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (position == MenuCancel_Exit)
			Jbmenu(client).Display(client, MENU_TIME_FOREVER);
	}
}

Menu Gorevmenu()
{
	char Secenek[128];
	Menu menu = new Menu(Menu5_CallBack);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n        ★ Görev Menü ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬");
	Format(Secenek, sizeof(Secenek), "%d Dakika Oyna: %d Kredi", g_aktifoynamasure.IntValue, g_aktifoynamaodul.IntValue);
	menu.AddItem("X", Secenek, ITEMDRAW_DISABLED);
	Format(Secenek, sizeof(Secenek), "CT Kellesi: %d Kredi", g_ctoldurmaodul.IntValue);
	menu.AddItem("X", Secenek, ITEMDRAW_DISABLED);
	Format(Secenek, sizeof(Secenek), "Tur Sonuna Kadar Hayatta Kal: %d Kredi", g_hayattkalmaodul.IntValue);
	menu.AddItem("X", Secenek, ITEMDRAW_DISABLED);
	menu.ExitBackButton = false;
	menu.ExitButton = true;
	return menu;
}

public int Menu5_CallBack(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (position == MenuCancel_Exit)
			Jbmenu(client).Display(client, MENU_TIME_FOREVER);
	}
}

public Action Hizduzelt(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client))
	{
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
	}
}

public Action DakikaHesapla(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client))
	{
		Dakika[client]++;
		if (Dakika[client] >= g_aktifoynamasure.IntValue)
		{
			Dakika[client] = 0;
			char sBuffer[512];
			Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
			FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_aktifoynamaodul.IntValue);
			Cookie_Kredi.Set(client, sBuffer);
		}
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

Menu Isyanmenu(int client)
{
	char Secenek[128], sBuffer[512];
	Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
	Menu menu = new Menu(Menu4_CallBack);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n        ★ Isyan Menü ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬");
	if (g_hucrekapisiozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Hücre Kapısını Aç [ %d TL ]", g_hucrekapiacmaucret.IntValue);
		if (StringToInt(sBuffer) >= g_hucrekapiacmaucret.IntValue)
			menu.AddItem("0", Secenek);
		else
			menu.AddItem("0", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("0", "Hücre Kapısını Aç [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_autostrafeaktif.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Otomatik Bunny Yapma [ %d TL ]", g_autostrafeucret.IntValue);
		if (StringToInt(sBuffer) >= g_autostrafeucret.IntValue && IsPlayerAlive(client) && !AutoStrafer[client])
			menu.AddItem("1", Secenek);
		else
			menu.AddItem("1", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("1", "Otomatik Bunny Yapma [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_canlanmaozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Kendini Canlandır [ %d TL ]", g_canlanmaucret.IntValue);
		if (StringToInt(sBuffer) >= g_canlanmaucret.IntValue && !IsPlayerAlive(client))
			menu.AddItem("2", Secenek);
		else
			menu.AddItem("2", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("2", "Kendini Canlandır [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_isinlanmabombaozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Işınlanma Bombası [ %d TL ]", g_teleportgrenadeucret.IntValue);
		if (StringToInt(sBuffer) >= g_teleportgrenadeucret.IntValue && !zehirlismokeasahip[client] && !Teleportlayicibomba[client] && IsPlayerAlive(client))
			menu.AddItem("3", Secenek);
		else
			menu.AddItem("3", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("3", "Işınlanma Bombası [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_zehirligazbombasiozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Zehirli Smoke [ %d TL ]", g_zehirlismokeucret.IntValue);
		if (StringToInt(sBuffer) >= g_zehirlismokeucret.IntValue && !zehirlismokeasahip[client] && !Teleportlayicibomba[client] && IsPlayerAlive(client))
			menu.AddItem("4", Secenek);
		else
			menu.AddItem("4", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("4", "Zehirli Smoke [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_gorunmezlikozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "%d Saniye Görünmezlik [ %d TL ]", g_gorunmezliksure.IntValue, g_gorunmezlikucret.IntValue);
		if (StringToInt(sBuffer) >= g_gorunmezlikucret.IntValue && IsPlayerAlive(client))
			menu.AddItem("5", Secenek);
		else
			menu.AddItem("5", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("5", "Görünmezlik [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_hizlikosmaozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "%d Saniye Hızlı Koşma [ %d TL ]", g_hizlikosmasureis.IntValue, g_hizlikosmaucret.IntValue);
		if (StringToInt(sBuffer) >= g_hizlikosmaucret.IntValue && IsPlayerAlive(client))
			menu.AddItem("6", Secenek);
		else
			menu.AddItem("6", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("6", "Hızlı Koşma [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_gardiyandondurmaozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "%d Saniye Gardiyanları Dondur [ %d TL ]", g_gardiyandondurmasure.IntValue, g_gardiyandondurucret.IntValue);
		if (StringToInt(sBuffer) >= g_gardiyandondurucret.IntValue)
			menu.AddItem("7", Secenek);
		else
			menu.AddItem("7", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("7", "Gardiyanları Dondur [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_saglikasisiozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Sağlık Aşısı [ %d TL ]", g_saglikasisiucret.IntValue);
		if (StringToInt(sBuffer) >= g_saglikasisiucret.IntValue && IsPlayerAlive(client))
			menu.AddItem("8", Secenek);
		else
			menu.AddItem("8", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("8", "Sağlık Aşısı [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_whbombasiozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "Wall Hack Bombası [ %d TL ]", g_whbombaucret.IntValue);
		if (StringToInt(sBuffer) >= g_whbombaucret.IntValue && IsPlayerAlive(client))
			menu.AddItem("9", Secenek);
		else
			menu.AddItem("9", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("9", "Wall Hack Bombası [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_deagleozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "%d Mermili Deagle [ %d TL ]", g_deaglemermi.IntValue, g_deagleucret.IntValue);
		if (StringToInt(sBuffer) >= g_deagleucret.IntValue && IsPlayerAlive(client))
			menu.AddItem("10", Secenek);
		else
			menu.AddItem("10", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("10", "Deagle [ KAPALI ]", ITEMDRAW_DISABLED);
	if (g_depremozelligi.BoolValue)
	{
		Format(Secenek, sizeof(Secenek), "%d Saniye Deprem [ %d TL ]", g_depremsure.IntValue, g_depremucret.IntValue);
		if (StringToInt(sBuffer) >= g_depremucret.IntValue)
			menu.AddItem("11", Secenek);
		else
			menu.AddItem("11", Secenek, ITEMDRAW_DISABLED);
	}
	else
		menu.AddItem("11", "Deprem [ KAPALI ]", ITEMDRAW_DISABLED);
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	return menu;
}

public int Menu4_CallBack(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select)
	{
		char Item[4], sBuffer[512];
		menu.GetItem(position, Item, sizeof(Item));
		Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
		if (strcmp(Item, "0", false) == 0)
		{
			if (g_hucrekapisiozelligi.BoolValue && StringToInt(sBuffer) >= g_hucrekapiacmaucret.IntValue)
			{
				char classname[32];
				for (int j = MaxClients + 1; j <= 2048; j++)
				{
					if (!IsValidEntity(j))
						continue;
					GetEntityClassname(j, classname, 32);
					if (strcmp(classname, "func_door", false) == 0 || strcmp(classname, "func_movelinear", false) == 0 || strcmp(classname, "func_door_rotating", false) == 0 || strcmp(classname, "prop_door_rotating", false) == 0)
						AcceptEntityInput(j, "Open");
					if (strcmp(classname, "func_wall_toggle", false) == 0 || strcmp(classname, "func_breakable", false) == 0)
						RemoveEntity(j);
				}
				PrintToChatAll("[SM] \x10%N \x01adlı isyancı kapıları bozdu!", client);
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_hucrekapiacmaucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "1", false) == 0)
		{
			if (g_autostrafeaktif.BoolValue && StringToInt(sBuffer) >= g_autostrafeucret.IntValue && !AutoStrafer[client])
			{
				AutoStrafer[client] = true;
				PrintToChat(client, "[SM] \x01Otomatik bunny yapma satın aldın.");
				PrintToChat(client, "[SM] \x01Sadece zıplayıp gideceğin yere bakman yeterli.");
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_autostrafeucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "2", false) == 0)
		{
			if (g_canlanmaozelligi.BoolValue && StringToInt(sBuffer) >= g_canlanmaucret.IntValue && !IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] Yeniden canlandın!");
				CS_RespawnPlayer(client);
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_canlanmaucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "3", false) == 0)
		{
			if (g_isinlanmabombaozelligi.BoolValue && StringToInt(sBuffer) >= g_teleportgrenadeucret.IntValue && !zehirlismokeasahip[client] && !Teleportlayicibomba[client] && IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] Işınlanma smoke bombası aldın!");
				GivePlayerItem(client, "weapon_smokegrenade");
				Teleportlayicibomba[client] = true;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_teleportgrenadeucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "4", false) == 0)
		{
			if (g_zehirligazbombasiozelligi.BoolValue && StringToInt(sBuffer) >= g_zehirlismokeucret.IntValue && !zehirlismokeasahip[client] && !Teleportlayicibomba[client] && IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] Zehirli smoke bombası aldın!");
				GivePlayerItem(client, "weapon_smokegrenade");
				zehirlismokeasahip[client] = true;
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_zehirlismokeucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "5", false) == 0)
		{
			if (g_gorunmezlikozelligi.BoolValue && StringToInt(sBuffer) >= g_gorunmezlikucret.IntValue && IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] %d saniye kimse göremez seni!", g_gorunmezliksure.IntValue);
				SDKHook(client, SDKHook_SetTransmit, SetTransmit);
				CreateTimer(g_gorunmezliksure.FloatValue, gorunmezlikal, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_gorunmezlikucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "6", false) == 0)
		{
			if (g_hizlikosmaozelligi.BoolValue && StringToInt(sBuffer) >= g_hizlikosmaucret.IntValue && IsPlayerAlive(client))
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.5);
				PrintToChat(client, "[SM] %d saniye boyunca hızlı koşacaksın!", g_hizlikosmasureis.IntValue);
				CreateTimer(g_hizlikosmasureis.FloatValue, speedal, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_hizlikosmaucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "7", false) == 0)
		{
			if (g_gardiyandondurmaozelligi.BoolValue && StringToInt(sBuffer) >= g_gardiyandondurucret.IntValue)
			{
				ServerCommand("sm_freeze @ct %d", g_gardiyandondurmasure.IntValue);
				PrintToChatAll("[SM] \x10%N \x01tarafından \x04%d saniye \x01gardiyanlar donduruldu!", client, g_gardiyandondurmasure.IntValue);
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_gardiyandondurucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "8", false) == 0)
		{
			if (g_saglikasisiozelligi.BoolValue && StringToInt(sBuffer) >= g_saglikasisiucret.IntValue && IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] Sağlık aşısı satın aldın!");
				GivePlayerItem(client, "weapon_healthshot");
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_saglikasisiucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "9", false) == 0)
		{
			if (g_whbombasiozelligi.BoolValue && StringToInt(sBuffer) >= g_whbombaucret.IntValue && IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] Wall hack bombası satın aldın!");
				GivePlayerItem(client, "weapon_tagrenade");
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_whbombaucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "10", false) == 0)
		{
			if (g_deagleozelligi.BoolValue && StringToInt(sBuffer) >= g_deagleucret.IntValue && IsPlayerAlive(client))
			{
				PrintToChat(client, "[SM] %d Mermili deagle satın aldın!", g_deaglemermi.IntValue);
				int Silahi = GivePlayerItem(client, "weapon_deagle");
				SetEntProp(Silahi, Prop_Data, "m_iClip1", g_deaglemermi.IntValue);
				SetEntProp(Silahi, Prop_Send, "m_iPrimaryReserveAmmoCount", 0);
				SetEntProp(Silahi, Prop_Send, "m_iSecondaryReserveAmmoCount", 0);
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_deagleucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
		else if (strcmp(Item, "11", false) == 0)
		{
			if (g_depremozelligi.BoolValue && StringToInt(sBuffer) >= g_depremucret.IntValue)
			{
				PrintToChat(client, "[SM] \x10%N \x01%d saniye deprem yaptı.", client, g_depremsure.IntValue);
				for (int i = 1; i <= MaxClients; i++)if (IsValidClient(i) && IsPlayerAlive(i))
				{
					EkranTitreme(i, 10.0, 10000.0, g_depremsure.FloatValue + 1.0, 80.0);
				}
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_depremucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
			}
			else
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (position == MenuCancel_Exit)
			Jbmenu(client).Display(client, MENU_TIME_FOREVER);
	}
}

public Action speedal(Handle timer, int userid)
{
	int yilanyapkendini = GetClientOfUserId(userid);
	if (IsValidClient(yilanyapkendini))
	{
		SetEntPropFloat(yilanyapkendini, Prop_Data, "m_flLaggedMovementValue", 1.0);
		PrintToChat(yilanyapkendini, "[SM] Bir anda yavaşladın tıssssss.");
	}
}

public Action gorunmezlikal(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client))
	{
		SDKUnhook(client, SDKHook_SetTransmit, SetTransmit);
		PrintToChat(client, "[SM] Görünmezliğin sona erdi.");
	}
}

public Action SetTransmit(int entity, int client)
{
	if (entity != client)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if (IsValidClient(attacker) && IsValidClient(victim) && GetClientTeam(attacker) != GetClientTeam(victim) && Customknife[attacker] > 0 && damagetype & DMG_SLASH)
	{
		char WeaponName[32];
		GetClientWeapon(attacker, WeaponName, sizeof(WeaponName));
		if (StrContains(WeaponName, "weapon_knife", false) != -1)
		{
			if (Customknife[attacker] == 1)
				damage = g_levyehasar.FloatValue;
			else if (Customknife[attacker] == 2)
				damage = g_cekichasar.FloatValue;
			else if (Customknife[attacker] == 3)
				damage = g_suikasthasar.FloatValue;
			else if (Customknife[attacker] == 4)
			{
				damage = g_kutsalbuzhasar.FloatValue;
				SetEntPropFloat(victim, Prop_Data, "m_flLaggedMovementValue", 0.68);
				CreateTimer(3.0, Hizduzelt, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
			}
			else if (Customknife[attacker] == 5)
			{
				damage = g_kutsallavhasar.FloatValue;
				IgniteEntity(victim, 3.0);
			}
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

Menu Meslekmenu(int client)
{
	Menu menu = new Menu(Menu3_CallBack);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n        ★ Meslek Menü ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬");
	char Secenek[128];
	if (!MeslekKullandimi[client])
	{
		if (g_meslekavci.BoolValue)
		{
			if (Meslegi[client] != 1)
			{
				Format(Secenek, sizeof(Secenek), "Avcı [ Ekstra CT Kellesi Başına %d TL ]", g_avcikelleodulu.IntValue);
				menu.AddItem("0", Secenek);
			}
			else
				menu.AddItem("0", "Avcı [ KULLANIMDA ]", ITEMDRAW_DISABLED);
		}
		else
		{
			menu.AddItem("0", "Avcı [ KAPALI ]", ITEMDRAW_DISABLED);
		}
		
		if (g_meslekhirsiz.BoolValue)
		{
			if (Meslegi[client] != 2)
			{
				Format(Secenek, sizeof(Secenek), "Hırsız [ %d Dakikada %d TL ]", g_hirsizdakika.IntValue, g_hirsizodulu.IntValue);
				menu.AddItem("1", Secenek);
			}
			else
				menu.AddItem("1", "Hırsız [ KULLANIMDA ]", ITEMDRAW_DISABLED);
		}
		else
			menu.AddItem("1", "Hırsız [ KAPALI ]", ITEMDRAW_DISABLED);
		
		if (g_meslekbombaci.BoolValue)
		{
			if (Meslegi[client] != 3)
				menu.AddItem("2", "Bombacı [ Molotof ve Flaş ]");
			else
				menu.AddItem("2", "Bombacı [ KULLANIMDA ]", ITEMDRAW_DISABLED);
		}
		else
			menu.AddItem("2", "Bombacı [ KAPALI ]", ITEMDRAW_DISABLED);
		
		if (g_meslekterminator.BoolValue)
		{
			if (Meslegi[client] != 4)
			{
				Format(Secenek, sizeof(Secenek), "Terminatör [ %d Can + %d Armor ]", g_terminatorcan.IntValue, g_terminatorarmor.IntValue);
				menu.AddItem("3", Secenek);
			}
			else
				menu.AddItem("3", "Terminatör [ KULLANIMDA ]", ITEMDRAW_DISABLED);
		}
		else
			menu.AddItem("3", "Terminatör [ KAPALI ]", ITEMDRAW_DISABLED);
	}
	else
	{
		Format(Secenek, sizeof(Secenek), "Avcı [ CT Kellesi Başına %d TL ]", g_avcikelleodulu.IntValue);
		menu.AddItem("0", Secenek, ITEMDRAW_DISABLED);
		Format(Secenek, sizeof(Secenek), "Hırsız [ %d Dakikada %d TL ]", g_hirsizdakika.IntValue, g_hirsizodulu.IntValue);
		menu.AddItem("1", Secenek, ITEMDRAW_DISABLED);
		menu.AddItem("2", "Bombacı [ Molotof ve Flaş ]", ITEMDRAW_DISABLED);
		Format(Secenek, sizeof(Secenek), "Terminatör [ %d Can + %d Armor ]", g_terminatorcan.IntValue, g_terminatorarmor.IntValue);
		menu.AddItem("3", Secenek, ITEMDRAW_DISABLED);
	}
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	return menu;
}

public int Menu3_CallBack(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select)
	{
		char Item[4];
		menu.GetItem(position, Item, sizeof(Item));
		MeslekKullandimi[client] = true;
		if (Meslegi[client] != 0)
		{
			if (Meslegi[client] == 1)
			{
				Avci[client] = false;
			}
			else if (Meslegi[client] == 2)
			{
				if (h_hirsiztimer[client] != null)
				{
					delete h_hirsiztimer[client];
					h_hirsiztimer[client] = null;
				}
			}
		}
		if (strcmp(Item, "0", false) == 0)
		{
			if (g_meslekavci.BoolValue)
			{
				Avci[client] = true;
				Meslegi[client] = 1;
				PrintToChat(client, "[SM] Mesleğin değiştirildi: Avcı");
			}
			else
				PrintToChat(client, "[SM] Bu meslek kapalı: Avcı");
		}
		else if (strcmp(Item, "1", false) == 0)
		{
			if (g_meslekhirsiz.BoolValue)
			{
				Meslegi[client] = 2;
				if (h_hirsiztimer[client] != null)
					delete h_hirsiztimer[client];
				h_hirsiztimer[client] = CreateTimer(g_hirsizdakika.FloatValue * 60.0, Krediver, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
				PrintToChat(client, "[SM] Mesleğin değiştirildi: Hırsız");
			}
			else
				PrintToChat(client, "[SM] Bu meslek kapalı: Hırsız");
		}
		else if (strcmp(Item, "2", false) == 0)
		{
			if (g_meslekbombaci.BoolValue)
			{
				Meslegi[client] = 3;
				GivePlayerItem(client, "weapon_molotov");
				GivePlayerItem(client, "weapon_flashbang");
				PrintToChat(client, "[SM] Mesleğin değiştirildi: Bombacı");
			}
			else
				PrintToChat(client, "[SM] Bu meslek kapalı: Bombacı");
		}
		else if (strcmp(Item, "3", false) == 0)
		{
			if (g_meslekterminator.BoolValue)
			{
				Meslegi[client] = 4;
				SetEntityHealth(client, g_terminatorcan.IntValue);
				SetEntProp(client, Prop_Data, "m_ArmorValue", g_terminatorarmor.IntValue, 4);
				PrintToChat(client, "[SM] Mesleğin değiştirildi: Terminatör");
			}
			else
				PrintToChat(client, "[SM] Bu meslek kapalı: Terminatör");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (position == MenuCancel_Exit)
			Jbmenu(client).Display(client, MENU_TIME_FOREVER);
	}
}

public Action Krediver(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client))
	{
		char sBuffer[512];
		Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
		FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_hirsizodulu.IntValue);
		Cookie_Kredi.Set(client, sBuffer);
		PrintToChat(client, "[SM] Hırsız ödülü kazandın +%d TL", g_hirsizodulu.IntValue);
	}
}

public void ConVarChanged(ConVar cvar, const char[] oldVal, const char[] newVal)
{
	if (cvar == g_meslekterminator)
	{
		if (!g_meslekterminator.BoolValue)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && Meslegi[i] == 4)
				{
					Meslegi[i] = 0;
					PrintToChat(i, "[SM] Kullandığın meslek devre dışı bırakıldı, yeni meslek seç.");
					MeslekKullandimi[i] = false;
				}
			}
		}
	}
	if (cvar == g_meslekbombaci)
	{
		if (!g_meslekbombaci.BoolValue)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && Meslegi[i] == 3)
				{
					Meslegi[i] = 0;
					PrintToChat(i, "[SM] Kullandığın meslek devre dışı bırakıldı, yeni meslek seç.");
					MeslekKullandimi[i] = false;
				}
			}
		}
	}
	if (cvar == g_meslekhirsiz)
	{
		if (!g_meslekhirsiz.BoolValue)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && Meslegi[i] == 2)
				{
					Meslegi[i] = 0;
					PrintToChat(i, "[SM] Kullandığın meslek devre dışı bırakıldı, yeni meslek seç.");
					MeslekKullandimi[i] = false;
				}
			}
		}
	}
	if (cvar == g_meslekavci)
	{
		if (!g_meslekavci.BoolValue)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && Meslegi[i] == 1)
				{
					Meslegi[i] = 0;
					PrintToChat(i, "[SM] Kullandığın meslek devre dışı bırakıldı, yeni meslek seç.");
					MeslekKullandimi[i] = false;
				}
			}
		}
	}
}

Menu Sansmenu(int client)
{
	Menu menu = new Menu(Menu2_CallBack);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n        ★ Şans Menü ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n★ İçinden Çıkanlar:\n \n→ Glock\n→ +%d Can\n→ Hızlı Koşma ( %d Saniye )\n→ İnfaz\n→ %d - %d Arası TL\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬", g_sanskasasican.IntValue, g_hizlikosmasure.IntValue, g_kasaminhediye.IntValue, g_kasamaxhediye.IntValue);
	char Secenek[128], sBuffer[512];
	Format(Secenek, sizeof(Secenek), "Kasayı Aç [ %d TL ]", g_kasakrediucret.IntValue);
	Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
	if (StringToInt(sBuffer) >= g_kasakrediucret.IntValue && IsPlayerAlive(client) && !KasaActimi[client])
	{
		menu.AddItem("0", Secenek);
	}
	else
		menu.AddItem("0", Secenek, ITEMDRAW_DISABLED);
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	return menu;
}

public int Menu2_CallBack(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select)
	{
		char Item[4];
		menu.GetItem(position, Item, sizeof(Item));
		if (strcmp(Item, "0", false) == 0)
		{
			char sBuffer[512];
			Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
			if (StringToInt(sBuffer) >= g_kasakrediucret.IntValue && IsPlayerAlive(client) && !KasaActimi[client])
			{
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) - g_kasakrediucret.IntValue);
				Cookie_Kredi.Set(client, sBuffer);
				KasaActimi[client] = true;
				int Cikan = GetRandomInt(0, 10);
				if (Cikan == 0)
				{
					GivePlayerItem(client, "weapon_glock");
					PrintHintText(client, "Şans kasasından çıkan: GLOCK");
					PrintToChat(client, "[SM] Şans kasasından çıkan: GLOCK");
				}
				else if (Cikan >= 1 && Cikan <= 3)
				{
					SetEntityHealth(client, GetClientHealth(client) + g_sanskasasican.IntValue);
					PrintHintText(client, "Şans kasasından çıkan: +%d Hp", g_sanskasasican.IntValue);
					PrintToChat(client, "[SM] Şans kasasından çıkan: +%d Hp", g_sanskasasican.IntValue);
				}
				else if (Cikan == 4 || Cikan == 5)
				{
					if (h_timer[client] != null)
						delete h_timer[client];
					h_timer[client] = CreateTimer(g_hizlikosmasure.FloatValue, HizAl, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
					SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.5);
					PrintHintText(client, "Şans kasasından çıkan: Hızlı Koşma");
					PrintToChat(client, "[SM] Şans kasasından çıkan: Hızlı Koşma");
				}
				else if (Cikan >= 6 || Cikan <= 9)
				{
					ForcePlayerSuicide(client);
					PrintHintText(client, "Şans kasasından çıkan: İnfaz");
					PrintToChat(client, "[SM] Şans kasasından çıkan: İnfaz");
				}
				else if (Cikan == 10)
				{
					int CikanKredi = GetRandomInt(g_kasaminhediye.IntValue, g_kasamaxhediye.IntValue);
					Cookie_Kredi.Get(client, sBuffer, sizeof(sBuffer));
					FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + CikanKredi);
					Cookie_Kredi.Set(client, sBuffer);
					PrintHintText(client, "Şans kasasından çıkan: %d TL", CikanKredi);
					PrintToChat(client, "[SM] Şans kasasından çıkan: %d TL", CikanKredi);
				}
			}
			else
			{
				PrintToChat(client, "[SM] Hata algılandı, tekrar deneyin.");
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (position == MenuCancel_Exit)
			Jbmenu(client).Display(client, MENU_TIME_FOREVER);
	}
}

public Action HizAl(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client))
	{
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
		h_timer[client] = null;
	}
	return Plugin_Stop;
}

public Action SmokeGrenade_Detonate(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		if (Teleportlayicibomba[client])
		{
			Teleportlayicibomba[client] = false;
			float origin[3];
			origin[0] = event.GetFloat("x");
			origin[1] = event.GetFloat("y");
			origin[2] = event.GetFloat("z");
			TeleportEntity(client, origin, NULL_VECTOR, NULL_VECTOR);
			SetClientViewEntity(client, client);
		}
		if (zehirlismokeasahip[client])
		{
			int iEntity = CreateEntityByName("light_dynamic");
			if (iEntity == -1)
			{
				return;
			}
			float DetonateOrigin[3];
			DetonateOrigin[0] = event.GetFloat("x");
			DetonateOrigin[1] = event.GetFloat("y");
			DetonateOrigin[2] = event.GetFloat("z");
			DispatchKeyValue(iEntity, "inner_cone", "0");
			DispatchKeyValue(iEntity, "cone", "80");
			DispatchKeyValue(iEntity, "brightness", "5");
			DispatchKeyValueFloat(iEntity, "spotlight_radius", 96.0);
			DispatchKeyValue(iEntity, "pitch", "90");
			DispatchKeyValue(iEntity, "style", "6");
			DispatchKeyValue(iEntity, "_light", "0 255 0");
			DispatchKeyValueFloat(iEntity, "distance", 256.0);
			SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);
			CreateTimer(20.0, Delete, iEntity, TIMER_FLAG_NO_MAPCHANGE);
			
			TE_SetupBeamRingPoint(DetonateOrigin, 99.0, 100.0, g_sprite, g_HaloSprite, 0, 15, 20.0, 10.0, 220.0, { 50, 255, 50, 255 }, 10, 0);
			TE_SendToAll();
			
			TE_SetupBeamRingPoint(DetonateOrigin, 99.0, 100.0, g_sprite, g_HaloSprite, 0, 15, 20.0, 10.0, 220.0, { 50, 50, 255, 255 }, 10, 0);
			TE_SendToAll();
			
			DispatchSpawn(iEntity);
			TeleportEntity(iEntity, DetonateOrigin, NULL_VECTOR, NULL_VECTOR);
			AcceptEntityInput(iEntity, "TurnOn");
			
			CreateTimer(1.0, Timer_CheckDamage, iEntity, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
			
			zehirlismokeasahip[client] = false;
		}
	}
}

public Action Delete(Handle timer, any entity)
{
	if (IsValidEntity(entity))
		RemoveEntity(entity);
}

public void OnEntityCreated(int iEntity, const char[] classname)
{
	if (StrEqual(classname, "smokegrenade_projectile"))
		SDKHook(iEntity, SDKHook_SpawnPost, OnEntitySpawned);
}

public void OnEntitySpawned(int iGrenade)
{
	int client = GetEntPropEnt(iGrenade, Prop_Send, "m_hOwnerEntity");
	if (Teleportlayicibomba[client] && IsValidClient(client))
	{
		SetClientViewEntity(client, iGrenade);
	}
}

public Action Timer_CheckDamage(Handle timer, any iEntity)
{
	if (!IsValidEntity(iEntity))
		return Plugin_Stop;
	
	int client = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
	
	if (!IsValidClient(client) || !IsPlayerAlive(client))
		return Plugin_Stop;
	
	
	float fSmokeOrigin[3], fOrigin[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fSmokeOrigin);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) != GetClientTeam(client))
		{
			GetClientAbsOrigin(i, fOrigin);
			if (GetVectorDistance(fSmokeOrigin, fOrigin) <= 220)
				DealDamage(i, g_zehirlismokehasar.FloatValue, client, DMG_POISON, "weapon_smokegrenade");
		}
	}
	return Plugin_Continue;
}

public Action RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i < MaxClients; i++)if (IsValidClient(i))
	{
		SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
		if (h_timer[i] != null)
		{
			delete h_timer[i];
			h_timer[i] = null;
		}
		AutoStrafer[i] = false;
		Kullanildi[i] = false;
		KasaActimi[i] = false;
		Teleportlayicibomba[i] = false;
		MeslekKullandimi[i] = false;
		if (Customknife[i] > 0)
		{
			FPVMI_RemoveViewModelToClient(i, "weapon_knife");
			FPVMI_RemoveWorldModelToClient(i, "weapon_knife");
			Customknife[i] = 0;
		}
		zehirlismokeasahip[i] = false;
	}
}

public Action OnClientDead(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if (IsValidClient(attacker) && GetClientTeam(attacker) == CS_TEAM_T)
	{
		int victim = GetClientOfUserId(event.GetInt("userid"));
		if (IsValidClient(victim))
		{
			Teleportlayicibomba[victim] = false;
			zehirlismokeasahip[victim] = false;
			if (Customknife[victim] > 0)
			{
				FPVMI_RemoveViewModelToClient(victim, "weapon_knife");
				FPVMI_RemoveWorldModelToClient(victim, "weapon_knife");
				Customknife[victim] = 0;
			}
			if (GetClientTeam(victim) == CS_TEAM_CT)
			{
				char sBuffer[512];
				Cookie_Kredi.Get(attacker, sBuffer, sizeof(sBuffer));
				FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_ctoldurmaodul.IntValue);
				Cookie_Kredi.Set(attacker, sBuffer);
				if (Avci[attacker])
				{
					Cookie_Kredi.Get(attacker, sBuffer, sizeof(sBuffer));
					FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_avcikelleodulu.IntValue);
					Cookie_Kredi.Set(attacker, sBuffer);
					PrintToChat(attacker, "[SM] Meslekten CT Kellesi için +%d TL kazandın", g_avcikelleodulu.IntValue);
				}
			}
		}
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3])
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || IsFakeClient(client))
		return Plugin_Continue;
	
	if (GetConVarInt(FindConVar("sv_autobunnyhopping")) == 1 && AutoStrafer[client])
	{
		ApplyAutoStrafe(client, buttons, vel, angles);
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

void ApplyAutoStrafe(int client, int &buttons, float vel[3], float angles[3])
{
	if (GetEntityFlags(client) & FL_WATERJUMP || GetEntityFlags(client) & FL_ONGROUND || GetEntityMoveType(client) & MOVETYPE_LADDER || buttons & IN_MOVELEFT || buttons & IN_MOVERIGHT || buttons & IN_FORWARD || buttons & IN_BACK)
		return;
	
	float flVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", flVelocity);
	float flYVel = RadToDeg(ArcTangent2(flVelocity[1], flVelocity[0]));
	float flDiffAngle = NormalizeAngle(angles[1] - flYVel);
	float g_flSidespeed = 450.0;
	vel[1] = g_flSidespeed;
	if (flDiffAngle > 0.0)
		vel[1] = -g_flSidespeed;
	
	float flLastGain = g_LastGain[client];
	float flAngleGain = RadToDeg(ArcTangent(vel[1] / vel[0]));
	if (!((flLastGain < 0.0 && flAngleGain < 0.0) || (flLastGain > 0.0 && flAngleGain > 0.0)))
		angles[1] -= flDiffAngle;
	
	g_LastGain[client] = flAngleGain;
}

public float NormalizeAngle(float angle)
{
	float temp = angle;
	while (temp <= -180.0)
	{
		temp += 360.0;
	}
	while (temp > 180.0)
	{
		temp -= 360.0;
	}
	return temp;
}

public Action HayattaKalanlar(Event event, const char[] name, bool dontBroadcast)
{
	char sBuffer[512];
	for (int i = 1; i <= MaxClients; i++)if (IsValidClient(i) && GetClientTeam(i) == CS_TEAM_T && IsPlayerAlive(i))
	{
		Cookie_Kredi.Get(i, sBuffer, sizeof(sBuffer));
		FormatEx(sBuffer, sizeof(sBuffer), "%d", StringToInt(sBuffer) + g_hayattkalmaodul.IntValue);
		Cookie_Kredi.Set(i, sBuffer);
	}
}

public Action OnClientSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client) && GetClientTeam(client) == CS_TEAM_T)
	{
		FPVMI_RemoveViewModelToClient(client, "weapon_knife");
		FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
		if (Meslegi[client] == 3)
		{
			GivePlayerItem(client, "weapon_molotov");
			GivePlayerItem(client, "weapon_flashbang");
		}
		else if (Meslegi[client] == 4)
		{
			SetEntityHealth(client, g_terminatorcan.IntValue);
			SetEntProp(client, Prop_Data, "m_ArmorValue", g_terminatorarmor.IntValue, 4);
		}
	}
}

stock void DealDamage(int nClientVictim, float nDamage, int nClientAttacker = 0, int nDamageType = DMG_GENERIC, char sWeapon[] = "")
{
	if (nClientVictim > 0 && 
		IsValidEdict(nClientVictim) && 
		IsValidClient(nClientVictim) && 
		IsPlayerAlive(nClientVictim) && 
		nDamage > 0)
	{
		int EntityPointHurt = CreateEntityByName("point_hurt");
		if (EntityPointHurt != 0)
		{
			char sDamage[16];
			FormatEx(sDamage, sizeof(sDamage), "%d", nDamage);
			
			char sDamageType[32];
			FormatEx(sDamageType, sizeof(sDamageType), "%d", nDamageType);
			
			DispatchKeyValue(nClientVictim, "targetname", "war3_hurtme");
			DispatchKeyValue(EntityPointHurt, "DamageTarget", "war3_hurtme");
			DispatchKeyValue(EntityPointHurt, "Damage", sDamage);
			DispatchKeyValue(EntityPointHurt, "DamageType", sDamageType);
			if (!StrEqual(sWeapon, ""))
				DispatchKeyValue(EntityPointHurt, "classname", sWeapon);
			DispatchSpawn(EntityPointHurt);
			AcceptEntityInput(EntityPointHurt, "Hurt", (nClientAttacker != 0) ? nClientAttacker : -1);
			DispatchKeyValue(EntityPointHurt, "classname", "point_hurt");
			DispatchKeyValue(nClientVictim, "targetname", "war3_donthurtme");
			RemoveEntity(EntityPointHurt);
		}
	}
}

stock void EkranTitreme(int client, float Amplitude, float Radius, float Duration, float Frequency)
{
	float ClientOrigin[3];
	int Ent = CreateEntityByName("env_shake");
	
	if (DispatchSpawn(Ent))
	{
		DispatchKeyValueFloat(Ent, "amplitude", Amplitude);
		DispatchKeyValueFloat(Ent, "radius", Radius);
		DispatchKeyValueFloat(Ent, "duration", Duration);
		DispatchKeyValueFloat(Ent, "frequency", Frequency);
		
		SetVariantString("spawnflags 8");
		AcceptEntityInput(Ent, "AddOutput");
		AcceptEntityInput(Ent, "StartShake", client);
		GetClientAbsOrigin(client, ClientOrigin);
		TeleportEntity(Ent, ClientOrigin, NULL_VECTOR, NULL_VECTOR);
	}
}

stock bool IsValidClient(int client, bool nobots = false)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

stock void PrecacheAndModelDownloader(char[] sModelname)
{
	char sBuffer[PLATFORM_MAX_PATH];
	Format(sBuffer, sizeof(sBuffer), "models/%s.dx90.vtx", sModelname);
	AddFileToDownloadsTable(sBuffer);
	Format(sBuffer, sizeof(sBuffer), "models/%s.mdl", sModelname);
	PrecacheModel(sBuffer);
	AddFileToDownloadsTable(sBuffer);
	Format(sBuffer, sizeof(sBuffer), "models/%s.phy", sModelname);
	AddFileToDownloadsTable(sBuffer);
	Format(sBuffer, sizeof(sBuffer), "models/%s.vvd", sModelname);
	AddFileToDownloadsTable(sBuffer);
}

stock void PrecacheAndModelDownloader2(char[] sModelname)
{
	char sBuffer[PLATFORM_MAX_PATH];
	Format(sBuffer, sizeof(sBuffer), "models/%s.dx90.vtx", sModelname);
	AddFileToDownloadsTable(sBuffer);
	Format(sBuffer, sizeof(sBuffer), "models/%s.mdl", sModelname);
	PrecacheModel(sBuffer);
	AddFileToDownloadsTable(sBuffer);
	Format(sBuffer, sizeof(sBuffer), "models/%s.vvd", sModelname);
	AddFileToDownloadsTable(sBuffer);
}

stock void PrecacheAndMaterialDownloader(char[] sMaterialname)
{
	char sBuffer[PLATFORM_MAX_PATH];
	Format(sBuffer, sizeof(sBuffer), "materials/%s.vmt", sMaterialname);
	AddFileToDownloadsTable(sBuffer);
	Format(sBuffer, sizeof(sBuffer), "materials/%s.vtf", sMaterialname);
	AddFileToDownloadsTable(sBuffer);
} 