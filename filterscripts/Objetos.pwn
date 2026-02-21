//============================================================================//
/*

		Sistema de Objetos para Jugadores (Huesos y Colores +150) by Straydet


		Idea Original (EdgarHN) - https://sampforum.blast.hk/showthread.php?tid=641006

		Desarrollador (Straydet) - Desarrollo de Funciones, Stocks, y demás.


	    Nota: Este sistema de Objetos para Jugadores, contiene varias funciones pensadas en el jugador.
		Por lo cual dentro del sistema encontrara instrucciones comentadas a lo largo del archivo.
	    En caso de encontrar un bug/error puede notificarlo asi también como sugerencias para el sistema.
	    Si quiere modificar/editar debe al menos conocer el lenguaje 'Pawn', ya que puede causar errores/bugs por no saber lo que hace.
	    
	    Tiempo estimado de compilación: 30 Segundos

*/
//============================================================================//
#include <a_samp>
#include <mSelection>
#include <zcmd>
#include <sscanf2>
//============================================================================//
new DB:DataBaseX;
#define foreachEx(%0:%1) for(new %0=0;%0<%1;%0++)
//============================================================================//
#define     COL_WHITE       "{FFFFFF}"
//============================================================================//
#define DIALOGO_MIS_JUGUETES    (198)
#define DIALOGO_EDITAR_JUGUETE  (199)
#define DIALOGO_PARTE_JUGUETE   (200)
#define DIALOGO_MODO_OPCION     (201)
#define DIALOGO_MODO_OPCION2    (202)

#define DIALOGO_COLOR1          (203)
#define DIALOGO_COLOR2          (204)

#define DIALOGO_COLOR1_UPDATE   (205)
#define DIALOGO_COLOR2_UPDATE   (206)
//============================================================================//
#define JUGUETES_MAXIMOS 10
enum date_Objetos{
    j@modelid,
    j@bone,
    Float:j@usado,
    Float:j@OffsetX,
    Float:j@OffsetY,
    Float:j@OffsetZ,
    Float:j@RotX,
    Float:j@RotY,
    Float:j@RotZ,
    Float:j@ScaleX,
    Float:j@ScaleY,
    Float:j@ScaleZ,
    j@Color1,
    j@Color2
};
new Juguetes[MAX_PLAYERS][JUGUETES_MAXIMOS][date_Objetos];

new menu@Juguetes = mS_INVALID_LISTID;

enum _JuguetesParte{
jp@parte,
jp@nombre[40]
};
new JugueteParte[18][_JuguetesParte] = {
{1,"Espalda/Espina"},
{2,"Cabeza"},
{3,"Brazo izq superior"},
{4,"Brazo derecho superior"},
{5,"Mano izquierda"},
{6,"Mano derecha"},
{7,"Muslo izquierdo"},
{8,"Muslo derecho"},
{9,"Pie izquierdo"},
{10,"Pie derecho"},
{11,"Pantorrilla derecha"},
{12,"Pantorrilla izquierda"},
{13,"Antebrazo izquierdo"},
{14,"Antebrazo derecho"},
{15,"Clavícula izquierda (hombro)"},
{16,"Clavícula derecha (hombro)"},
{17,"Cuello"},
{18,"Boca/Mandíbula"}
};

new SeleccionoObjetoID[MAX_PLAYERS];
new SeleccionoObjetoModel[MAX_PLAYERS];
new SeleccionoObjetoParte[MAX_PLAYERS];

new ColorsObject[] =
{
    0xFFFFFFFF, // COLOR 1
    0x000000FF, // COLOR 2
    0x99CC00FF, // COLOR 3
    0xFF9900FF, // COLOR 4
    0x6699CCFF, // COLOR 5
    0x0099FFFF, // COLOR 6
    0xCCCC99FF, // COLOR 7
    0xFF8C13FF, // COLOR 8
    0xC715FFFF, // COLOR 9
    0x20B2AAFF, // COLOR 10
    0xDC143CFF, // COLOR 11
    0x6495EDFF, // COLOR 12
    0xF0E68CFF, // COLOR 13
    0x778899FF, // COLOR 14
    0xFF1493FF, // COLOR 15
    0xF4A460FF, // COLOR 16
    0xEE82EEFF, // COLOR 17
    0xFFD720FF, // COLOR 18
    0x8B4513FF, // COLOR 19
    0x4949A0FF, // COLOR 20
    0x148B8BFF, // COLOR 21
    0x14FF7FFF, // COLOR 22
    0x556B2FFF, // COLOR 23
    0x0FD9FAFF, // COLOR 24
    0x10DC29FF, // COLOR 25
    0x534081FF, // COLOR 26
    0x0495CDFF, // COLOR 27
    0xEF6CE8FF, // COLOR 28
    0xBD34DAFF, // COLOR 29
    0x247C1BFF, // COLOR 30
    0x0C8E5DFF, // COLOR 31
    0x635B03FF, // COLOR 32
    0xCB7ED3FF, // COLOR 33
    0x65ADEBFF, // COLOR 34
    0x5C1ACCFF, // COLOR 35
    0xF2F853FF, // COLOR 36
    0x11F891FF, // COLOR 37
    0x7B39AAFF, // COLOR 38
    0x53EB10FF, // COLOR 39
    0x54137DFF, // COLOR 40
    0x275222FF, // COLOR 41
    0xF09F5BFF, // COLOR 42
    0x3D0A4FFF, // COLOR 43
    0x22F767FF, // COLOR 44
    0xD63034FF, // COLOR 45
    0x9A6980FF, // COLOR 46
    0xDFB935FF, // COLOR 47
    0x3793FAFF, // COLOR 48
    0x90239DFF, // COLOR 49
    0xE9AB2FFF, // COLOR 50
    0xAF2FF3FF, // COLOR 51
    0x057F94FF, // COLOR 52
    0xB98519FF, // COLOR 53
    0x388EEAFF, // COLOR 54
    0x028151FF, // COLOR 55
    0xA55043FF, // COLOR 56
    0x0DE018FF, // COLOR 57
    0x93AB1CFF, // COLOR 58
    0x95BAF0FF, // COLOR 59
    0x369976FF, // COLOR 60
    0x18F71FFF, // COLOR 61
    0x4B8987FF, // COLOR 62
    0x491B9EFF, // COLOR 63
    0x829DC7FF, // COLOR 64
    0xBCE635FF, // COLOR 65
    0xCEA6DFFF, // COLOR 66
    0x20D4ADFF, // COLOR 67
    0x2D74FDFF, // COLOR 68
    0x3C1C0DFF, // COLOR 69
    0x12D6D4FF, // COLOR 70
    0x48C000FF, // COLOR 71
    0x2A51E2FF, // COLOR 72
    0xE3AC12FF, // COLOR 73
    0xFC42A8FF, // COLOR 74
    0x2FC827FF, // COLOR 75
    0x1A30BFFF, // COLOR 76
    0xB740C2FF, // COLOR 77
    0x42ACF5FF, // COLOR 78
    0x2FD9DEFF, // COLOR 79
    0xFAFB71FF, // COLOR 80
    0x05D1CDFF, // COLOR 81
    0xC471BDFF, // COLOR 82
    0x94436EFF, // COLOR 83
    0xC1F7ECFF, // COLOR 84
    0xCE79EEFF, // COLOR 85
    0xBD1EF2FF, // COLOR 86
    0x93B7E4FF, // COLOR 87
    0x3214AAFF, // COLOR 88
    0x184D3BFF, // COLOR 89
    0xAE4B99FF, // COLOR 90
    0x7E49D7FF, // COLOR 91
    0x4C436EFF, // COLOR 92
    0xFA24CCFF, // COLOR 93
    0xCE76BEFF, // COLOR 94
    0xA04E0AFF, // COLOR 95
    0x9F945CFF, // COLOR 96
    0xDCDE3DFF, // COLOR 97
    0x10C9C5FF, // COLOR 98
    0x70524DFF, // COLOR 99
    0x0BE472FF, // COLOR 100
    0x8A2CD7FF, // COLOR 101
    0x6152C2FF, // COLOR 102
    0xCF72A9FF, // COLOR 103
    0xE59338FF, // COLOR 104
    0xEEDC2DFF, // COLOR 105
    0xD8C762FF, // COLOR 106
    0xD87462FF, // COLOR 107
    0xFF8C13FF, // COLOR 108
    0xC715FFFF, // COLOR 109
    0x20B2AAFF, // COLOR 110
    0xDC143CFF, // COLOR 111
    0x6495EDFF, // COLOR 112
    0xF0E68CFF, // COLOR 113
    0x778899FF, // COLOR 114
    0xFF1493FF, // COLOR 115
    0xF4A460FF, // COLOR 116
    0xEE82EEFF, // COLOR 117
    0xFFD720FF, // COLOR 118
    0x8B4513FF, // COLOR 119
    0x4949A0FF, // COLOR 120
    0x148B8BFF, // COLOR 121
    0x14FF7FFF, // COLOR 122
    0x556B2FFF, // COLOR 123
    0x0FD9FAFF, // COLOR 124
    0x10DC29FF, // COLOR 125
    0x534081FF, // COLOR 126
    0x0495CDFF, // COLOR 127
    0xEF6CE8FF, // COLOR 128
    0xBD34DAFF, // COLOR 129
    0x247C1BFF, // COLOR 130
    0x0C8E5DFF, // COLOR 131
    0x635B03FF, // COLOR 132
    0xCB7ED3FF, // COLOR 133
    0x65ADEBFF, // COLOR 134
    0x5C1ACCFF, // COLOR 135
    0xF2F853FF, // COLOR 136
    0x11F891FF, // COLOR 137
    0x7B39AAFF, // COLOR 138
    0x53EB10FF, // COLOR 139
    0x54137DFF, // COLOR 140
    0x275222FF, // COLOR 141
    0xF09F5BFF, // COLOR 142
    0x3D0A4FFF, // COLOR 143
    0x22F767FF, // COLOR 144
    0xD63034FF, // COLOR 145
    0x9A6980FF, // COLOR 146
    0xDFB935FF, // COLOR 147
    0x3793FAFF, // COLOR 148
    0x90239DFF, // COLOR 149
    0xE9AB2FFF, // COLOR 150
    0xAF2FF3FF, // COLOR 151
    0x057F94FF, // COLOR 152
    0xB98519FF, // COLOR 153
    0x388EEAFF, // COLOR 154
    0x028151FF, // COLOR 155
    0xA55043FF  // COLOR 156
};

new DIALOG_COLOR_String[4200];
// Variables para guardar la selección de cada jugador
new SeleccionoColor1[MAX_PLAYERS];
new SeleccionoColor2[MAX_PLAYERS];
//============================================================================//
public OnGameModeInit()
{
    // Cargar los objetos
    menu@Juguetes = LoadModelSelectionMenu("Objetos.txt");

    DataBaseX = db_open("Juguetes.db");
    if (DataBaseX)
    {
        print("\n");
	    print("+===========================================+");
		printf("... Cargando Sistema de Objetos para Jugadores...");
	    print("\n");
    
        // Crear tabla base
        db_free_result(db_query(DataBaseX,
            "CREATE TABLE IF NOT EXISTS Objetos (\
            ID INTEGER PRIMARY KEY AUTOINCREMENT,\
            Nombre TEXT)"
        ));

        // Añadir modelos
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model0 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model1 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model2 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model3 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model4 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model5 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model6 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model7 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model8 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN model9 NUMERIC"));

        // Añadir huesos
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone0 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone1 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone2 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone3 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone4 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone5 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone6 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone7 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone8 NUMERIC"));
        db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN bone9 NUMERIC"));
        
        
        // Offsets X
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetX9 FLOAT"));

		// Offsets Y
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetY9 FLOAT"));

		// Offsets Z
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fOffsetZ9 FLOAT"));

		// Rotaciones X
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotX9 FLOAT"));

		// Rotaciones Y
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotY9 FLOAT"));

		// Rotaciones Z
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fRotZ9 FLOAT"));

		// Escalas X
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleX9 FLOAT"));

		// Escalas Y
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleY9 FLOAT"));

		// Escalas Z
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ0 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ1 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ2 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ3 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ4 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ5 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ6 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ7 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ8 FLOAT"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN fScaleZ9 FLOAT"));

		// Colores 1
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_0 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_1 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_2 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_3 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_4 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_5 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_6 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_7 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_8 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color1_9 NUMERIC"));

		// Colores 2
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_0 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_1 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_2 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_3 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_4 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_5 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_6 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_7 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_8 NUMERIC"));
		db_free_result(db_query(DataBaseX,"ALTER TABLE Objetos ADD COLUMN color2_9 NUMERIC"));

        printf("[+] Sistema de Objetos para Jugadores cargado correctamente!");
	    print("+===========================================+");
    }
    FormatColoredDialog();

}
//============================================================================//
public OnGameModeExit()
{
    // Remueve todos los objetos de todos los jugadores conectados
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(IsPlayerConnected(playerid))
        {
            for(new i = 0; i < JUGUETES_MAXIMOS; i++)
            {
                if(Juguetes[playerid][i][j@usado] == 1)
                {
                    RemovePlayerAttachedObject(playerid, i);
                    Juguetes[playerid][i][j@usado] = 0; // limpiar memoria
                }
            }
        }
    }

    db_close(DataBaseX);// Cerrar la conexiòn con la base de datos.
}
//============================================================================//
public OnPlayerConnect(playerid)
{
    CargarJuguetes(playerid);// Cargar objetos
    return 1;
}
//============================================================================//
public OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < JUGUETES_MAXIMOS; i++)
    {
        if(Juguetes[playerid][i][j@usado] == 1)
        {
            RemovePlayerAttachedObject(playerid, i);//Remueve objetos
        }
    }
    return 1;
}
//============================================================================//
public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == menu@Juguetes)
    {
        if(response)
        {
            SeleccionoObjetoModel[playerid] = modelid;
            ShowPlayerDialog(playerid, DIALOGO_COLOR1, DIALOG_STYLE_LIST, "Selecciona color #1", DIALOG_COLOR_String, "Siguiente", "Salir");
        }
        return 1;
    }
    return 1;
}
//============================================================================//
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOGO_EDITAR_JUGUETE)
    {
        if(response)
        {
            new query[1026];
            switch(listitem)
            {
                case 0:
                {
                    EditAttachedObject(playerid, SeleccionoObjetoID[playerid]);
                }
				case 1:
				{
				    ShowPlayerDialog(playerid, DIALOGO_COLOR1_UPDATE, DIALOG_STYLE_LIST,
				        "Selecciona color #1", DIALOG_COLOR_String, "Siguiente", "Salir");
				}

                case 2:
                {
                    ShowPlayerDialog(playerid,DIALOGO_MODO_OPCION,DIALOG_STYLE_LIST,"| Menu de Objetos |","Menú de objetos\n Objeto Personalizado","Siguiente","Atrás");
                }
				case 3:
				{
				    new index = SeleccionoObjetoID[playerid];
				    db_query(DataBaseX,"BEGIN");
				    format(query,sizeof(query),
				        "UPDATE `Objetos` SET model%d=0, bone%d=0, fOffsetX%d=0, fOffsetY%d=0, fOffsetZ%d=0, \
				         fRotX%d=0, fRotY%d=0, fRotZ%d=0, fScaleX%d=0, fScaleY%d=0, fScaleZ%d=0, \
				         color1_%d=0, color2_%d=0 \
				         WHERE `Nombre` = '%s' COLLATE NOCASE",
				        index,index,index,index,index,
				        index,index,index,
				        index,index,index,
				        index,index,
				        DB_Escape(Nombre(playerid))
				    );
				    db_query(DataBaseX,query);
				    db_query(DataBaseX,"COMMIT");

				    RemovePlayerAttachedObject(playerid, index);

				    // Reset
				    Juguetes[playerid][index][j@modelid]   = 0;
				    Juguetes[playerid][index][j@bone]      = 0;
				    Juguetes[playerid][index][j@OffsetX]   = 0;
				    Juguetes[playerid][index][j@OffsetY]   = 0;
				    Juguetes[playerid][index][j@OffsetZ]   = 0;
				    Juguetes[playerid][index][j@RotX]      = 0;
				    Juguetes[playerid][index][j@RotY]      = 0;
				    Juguetes[playerid][index][j@RotZ]      = 0;
				    Juguetes[playerid][index][j@ScaleX]    = 0;
				    Juguetes[playerid][index][j@ScaleY]    = 0;
				    Juguetes[playerid][index][j@ScaleZ]    = 0;
				    Juguetes[playerid][index][j@Color1]    = 0; // Reset color1
				    Juguetes[playerid][index][j@Color2]    = 0; // Reset color2
				    Juguetes[playerid][index][j@usado]     = 0;

				    GameTextForPlayer(playerid, "~w~Objeto ~h~~r~Eliminado.", 5000, 4);
				}
            }
        }
    }
    //------------------------------------------------------------------------//
	if(dialogid == DIALOGO_PARTE_JUGUETE)
	{
	    if(response)
	    {
	        new i = listitem;
	        SeleccionoObjetoParte[playerid] = JugueteParte[i][jp@parte];

	        SetPlayerAttachedObject(playerid,
	            SeleccionoObjetoID[playerid],
	            SeleccionoObjetoModel[playerid],
	            SeleccionoObjetoParte[playerid],
	            0.0, 0.0, 0.0,   // Offsets iniciales
	            0.0, 0.0, 0.0,   // Rotaciones iniciales
	            1.0, 1.0, 1.0,   // Escala inicial
	            SeleccionoColor1[playerid], // Color primario
	            SeleccionoColor2[playerid]  // Color secundario
	        );

	        EditAttachedObject(playerid, SeleccionoObjetoID[playerid]);
	        SendClientMessage(playerid,0x00FF0000,"* Info: {FFFFFF}Mantén presionado la barra espaciadora y, moviendo el mouse, podrás ver el objeto desde diferentes ángulos.");
	    }
	}
    //------------------------------------------------------------------------//
    if(dialogid == DIALOGO_MIS_JUGUETES)
    {
        if(response)
        {
            new i = listitem;
            SeleccionoObjetoID[playerid] = i;
            if(Juguetes[playerid][i][j@usado] == 1)
            {
                ShowPlayerDialog(playerid,DIALOGO_EDITAR_JUGUETE,DIALOG_STYLE_LIST,"| Objetos Opciones |","Editar posición \nCambiar el color \nCambiar Objeto \n{FF0000}Borrar Objeto","Seleccionar","Salir");
            }
            else if(Juguetes[playerid][i][j@usado] == 0)
            {
                ShowPlayerDialog(playerid,DIALOGO_MODO_OPCION,DIALOG_STYLE_LIST,"| Menu de Objetos |","Menú de objetos\nObjeto Personalizado","Siguiente","Atrás");
            }
        }
    }
    //------------------------------------------------------------------------//
    if(dialogid == DIALOGO_MODO_OPCION)
	{
	    if(response)
	    {
	        if(listitem==0) ShowModelSelectionMenu(playerid, menu@Juguetes, "| Objetos |");
	        if(listitem==1)
	        {
	            ShowPlayerDialog(playerid,DIALOGO_MODO_OPCION2,DIALOG_STYLE_INPUT,"Jugador Objetos/Objeto: (Insert objectid)",""COL_WHITE"Objeto personalizado, para ver la lista de objetos ingresa a la pagina\n'https://dev.prineside.com/gtasa_samp_model_id/'.","Editar","Salir");
	            SendClientMessage(playerid, 0x82A7FFFF, "* Nota: {FFFFFF}Algunos objetos de SAMP pueden causar crash/lag al estar cerca de un jugador.");
	        }
	    }
	}
    //------------------------------------------------------------------------//
	if(dialogid == DIALOGO_MODO_OPCION2)
	{
	    if(response)
	    {
	        if(!strlen(inputtext))
	            return SendClientMessage(playerid,0xFF0000FF,"* {FFFFFF}No puedes dejar el campo vacío."),
	                   ShowPlayerDialog(playerid,DIALOGO_MODO_OPCION2,DIALOG_STYLE_INPUT,"Jugador Objetos/Objeto: (Insert objectid)",""COL_WHITE"Objeto personalizado, para ver la lista de objetos ingresa a la pagina\n'https://dev.prineside.com/gtasa_samp_model_id/'.","Editar","Cerrar");

	        if(!IsNumeric(inputtext))
	            return SendClientMessage(playerid,0xFF0000FF,"* {FFFFFF}Solo se permiten IDs numéricos."),
	                   ShowPlayerDialog(playerid,DIALOGO_MODO_OPCION2,DIALOG_STYLE_INPUT,"Jugador Objetos/Objeto: (Insert objectid)",""COL_WHITE"Objeto personalizado, para ver la lista de objetos ingresa a la pagina\n'https://dev.prineside.com/gtasa_samp_model_id/'.","Editar","Cerrar");

	        new obj;
	        if(!sscanf(inputtext, "i", obj))
	        {
	           	// Validar rango seguro
	            if(!IsObjectXValid(obj))
	            {
	                SendClientMessage(playerid, 0xFF0000FF,
	                    "* {FFFFFF}Ese ID de objeto no es válido. Usa un número entre 615 y 19999.");
	                return ShowPlayerDialog(playerid,DIALOGO_MODO_OPCION2,DIALOG_STYLE_INPUT,
	                    "Jugador Objetos/Objeto: (Insert objectid)",
	                    ""COL_WHITE"Objeto personalizado, para ver la lista de objetos ingresa a la pagina\n'https://dev.prineside.com/gtasa_samp_model_id/'.","Editar","Cerrar");
	            }
	        
	            SeleccionoObjetoModel[playerid] = obj;

	            ShowPlayerDialog(playerid, DIALOGO_COLOR1, DIALOG_STYLE_LIST,
	                "Selecciona color #1", DIALOG_COLOR_String, "Siguiente", "Salir");
	        }
	    }
	}
	//------------------------------------------------------------------------//
	if(dialogid == DIALOGO_COLOR1)
	{
	    if(response)
	    {
	        if(listitem == 0) // Blanco base
	            SeleccionoColor1[playerid] = 0;
	        else
	            SeleccionoColor1[playerid] = RGBAToARGB(ColorsObject[listitem]);

	        ShowPlayerDialog(playerid, DIALOGO_COLOR2, DIALOG_STYLE_LIST,
	            "Selecciona color #2", DIALOG_COLOR_String, "Siguiente", "Salir");

            SendClientMessage(playerid, 0xFFFF00FF,"* {FFFFFF}Color #1 del objeto seleccionado!");
	    }
	}
    //------------------------------------------------------------------------//
	if(dialogid == DIALOGO_COLOR2)
	{
	    if(response)
	    {
	        if(listitem == 0) // Blanco base
	            SeleccionoColor2[playerid] = 0;
	        else
	            SeleccionoColor2[playerid] = RGBAToARGB(ColorsObject[listitem]);

	        new lista[sizeof(JugueteParte)*(40)];
	        lista[0] = '\0';
	        foreachEx(j:sizeof(JugueteParte))
	        {
	            format(lista,sizeof(lista),"%s\n%s",lista,JugueteParte[j][jp@nombre]);
	        }
	        ShowPlayerDialog(playerid,DIALOGO_PARTE_JUGUETE,DIALOG_STYLE_LIST,
	            "{FFFFFF}Elija una opción",lista,"Siguiente","Salir");

            SendClientMessage(playerid, 0xFFFF00FF,"* {FFFFFF}Color #2 del objeto seleccionado!");
	    }
	}
	//------------------------------------------------------------------------//
	if(dialogid == DIALOGO_COLOR1_UPDATE)
	{
	    if(response)
	    {
	        if(listitem == 0) // Blanco base
	            SeleccionoColor1[playerid] = 0;
	        else
	            SeleccionoColor1[playerid] = RGBAToARGB(ColorsObject[listitem]);

	        ShowPlayerDialog(playerid, DIALOGO_COLOR2_UPDATE, DIALOG_STYLE_LIST,
	            "Selecciona color #2", DIALOG_COLOR_String, "Siguiente", "Salir");

            SendClientMessage(playerid, 0xFF0000FF,"* {FFFFFF}Color #1 del objeto actualizado (Selecciona el color 2)");
	    }
	}
	//------------------------------------------------------------------------//
	if(dialogid == DIALOGO_COLOR2_UPDATE)
	{
	    if(response)
	    {
	        if(listitem == 0) // Blanco base
	            SeleccionoColor2[playerid] = 0;
	        else
	            SeleccionoColor2[playerid] = RGBAToARGB(ColorsObject[listitem]);

	        GameTextForPlayer(playerid, "~w~Color ~y~~h~Actualizado.", 5000, 4);

	        new index = SeleccionoObjetoID[playerid];
	        Juguetes[playerid][index][j@Color1] = SeleccionoColor1[playerid];
	        Juguetes[playerid][index][j@Color2] = SeleccionoColor2[playerid];

	        // Guardar en DataBase
	        new query[512];
	        db_query(DataBaseX,"BEGIN");
	        format(query,sizeof(query),
	            "UPDATE `Objetos` SET color1_%d=%d, color2_%d=%d \
	             WHERE `Nombre` = '%s' COLLATE NOCASE",
	            index, SeleccionoColor1[playerid],
	            index, SeleccionoColor2[playerid],
	            DB_Escape(Nombre(playerid))
	        );
	        db_query(DataBaseX,query);
	        db_query(DataBaseX,"COMMIT");

	        // Reaplicar el objeto con los nuevos colores
	        SetPlayerAttachedObject(playerid,
	            index,
	            Juguetes[playerid][index][j@modelid],
	            Juguetes[playerid][index][j@bone],
	            Juguetes[playerid][index][j@OffsetX],
	            Juguetes[playerid][index][j@OffsetY],
	            Juguetes[playerid][index][j@OffsetZ],
	            Juguetes[playerid][index][j@RotX],
	            Juguetes[playerid][index][j@RotY],
	            Juguetes[playerid][index][j@RotZ],
	            Juguetes[playerid][index][j@ScaleX],
	            Juguetes[playerid][index][j@ScaleY],
	            Juguetes[playerid][index][j@ScaleZ],
	            Juguetes[playerid][index][j@Color1],
	            Juguetes[playerid][index][j@Color2]
	        );

            SendClientMessage(playerid, 0xFF0000FF,"* {FFFFFF}Color #2 del objeto actualizado.");
	    }
	}
	
    return 1;
}
//============================================================================//
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    new query[2048], DBResult:resultado;
    format(query,sizeof(query),"SELECT `ID` FROM `Objetos` WHERE `Nombre` = '%s' COLLATE NOCASE",DB_Escape(Nombre(playerid)));
    resultado = db_query(DataBaseX,query);

    if(!db_num_rows(resultado))
    {
        // Guardar en memoria
        Juguetes[playerid][index][j@usado]   = 1;
        Juguetes[playerid][index][j@modelid] = modelid;
        Juguetes[playerid][index][j@bone]    = boneid;
        Juguetes[playerid][index][j@OffsetX] = fOffsetX;
        Juguetes[playerid][index][j@OffsetY] = fOffsetY;
        Juguetes[playerid][index][j@OffsetZ] = fOffsetZ;
        Juguetes[playerid][index][j@RotX]    = fRotX;
        Juguetes[playerid][index][j@RotY]    = fRotY;
        Juguetes[playerid][index][j@RotZ]    = fRotZ;
        Juguetes[playerid][index][j@ScaleX]  = fScaleX;
        Juguetes[playerid][index][j@ScaleY]  = fScaleY;
        Juguetes[playerid][index][j@ScaleZ]  = fScaleZ;
        Juguetes[playerid][index][j@Color1]  = SeleccionoColor1[playerid];
        Juguetes[playerid][index][j@Color2]  = SeleccionoColor2[playerid];

        // Insertar en DB
        format(query,sizeof(query),
            "INSERT INTO `Objetos` (Nombre, model%d, bone%d, fOffsetX%d, fOffsetY%d, fOffsetZ%d, fRotX%d, fRotY%d, fRotZ%d, fScaleX%d, fScaleY%d, fScaleZ%d, color1_%d, color2_%d) \
             VALUES ('%s','%d','%d','%f','%f','%f','%f','%f','%f','%f','%f','%f','%d','%d')",
            index,index,index,index,index,index,index,index,index,index,index,
            index,index,
            Nombre(playerid),modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ,
            SeleccionoColor1[playerid],SeleccionoColor2[playerid]
        );
        db_query(DataBaseX,query);
    }
    else
    {
        // Guardar en memoria
        Juguetes[playerid][index][j@usado]   = 1;
        Juguetes[playerid][index][j@modelid] = modelid;
        Juguetes[playerid][index][j@bone]    = boneid;
        Juguetes[playerid][index][j@OffsetX] = fOffsetX;
        Juguetes[playerid][index][j@OffsetY] = fOffsetY;
        Juguetes[playerid][index][j@OffsetZ] = fOffsetZ;
        Juguetes[playerid][index][j@RotX]    = fRotX;
        Juguetes[playerid][index][j@RotY]    = fRotY;
        Juguetes[playerid][index][j@RotZ]    = fRotZ;
        Juguetes[playerid][index][j@ScaleX]  = fScaleX;
        Juguetes[playerid][index][j@ScaleY]  = fScaleY;
        Juguetes[playerid][index][j@ScaleZ]  = fScaleZ;
        Juguetes[playerid][index][j@Color1]  = SeleccionoColor1[playerid];
        Juguetes[playerid][index][j@Color2]  = SeleccionoColor2[playerid];

        // Actualizar en DataBase
        db_query(DataBaseX,"BEGIN");
        format(query,sizeof(query),
            "UPDATE `Objetos` SET model%d=%d, bone%d=%d, fOffsetX%d=%f, fOffsetY%d=%f, fOffsetZ%d=%f, fRotX%d=%f, fRotY%d=%f, fRotZ%d=%f, fScaleX%d=%f, fScaleY%d=%f, fScaleZ%d=%f, color1_%d=%d, color2_%d=%d \
             WHERE `Nombre` = '%s' COLLATE NOCASE",
            index,modelid,
            index,boneid,
            index,fOffsetX,
            index,fOffsetY,
            index,fOffsetZ,
            index,fRotX,
            index,fRotY,
            index,fRotZ,
            index,fScaleX,
            index,fScaleY,
            index,fScaleZ,
            index,SeleccionoColor1[playerid],
            index,SeleccionoColor2[playerid],
            DB_Escape(Nombre(playerid))
        );
        db_query(DataBaseX,query);
        db_query(DataBaseX,"COMMIT");
    }

    db_free_result(resultado);

    GameTextForPlayer(playerid, "~w~Objeto ~g~~h~Guardado.", 5000, 4);

    return 1;
}
//============================================================================//
public OnPlayerSpawn(playerid)
{
    ColocarObjetos(playerid);// Colocar objetos
    return 1;
}
//============================================================================//
CMD:objetos(playerid, params[])
{
    new lista[JUGUETES_MAXIMOS * 64];
    lista[0] = '\0';

    foreachEx(i : JUGUETES_MAXIMOS)
    {
        if (Juguetes[playerid][i][j@usado] == 1)
        {
            // Slot ocupado
            format(lista, sizeof(lista), "%s\n{FF0000}Espacio usado (Slot: %d)", lista, i);
        }
        else
        {
            // Slot libre
            format(lista, sizeof(lista), "%s\n{00FF00}Espacio libre (Slot: %d)", lista, i);
        }
    }

    ShowPlayerDialog(playerid, DIALOGO_MIS_JUGUETES, DIALOG_STYLE_LIST, "Mis objetos (Prendas)", lista, "Siguiente", "Salir");
    return 1;
}
//----------------------------------------------------------------------------//
CMD:hold(playerid, params[]) return cmd_objetos(playerid, params);
CMD:o(playerid, params[]) return cmd_objetos(playerid, params);
CMD:items(playerid, params[]) return cmd_objetos(playerid, params);
CMD:prendas(playerid, params[]) return cmd_objetos(playerid, params);
//============================================================================//
stock CargarJuguetes(playerid)
{
    foreachEx(i:JUGUETES_MAXIMOS)
    {
        Juguetes[playerid][i][j@usado] = 0;
    }

    new query[256], DBResult:resultado, load[64];
    format(query,sizeof(query),"SELECT * FROM `Objetos` WHERE `Nombre` = '%s' COLLATE NOCASE",DB_Escape(Nombre(playerid)));
    resultado = db_query(DataBaseX,query);

    if(db_num_rows(resultado))
    {
        foreachEx(index:JUGUETES_MAXIMOS)
        {
            format(load,sizeof(load),"model%d",index);
            Juguetes[playerid][index][j@modelid] = db_get_field_assoc_int(resultado,load);

            format(load,sizeof(load),"bone%d",index);
            Juguetes[playerid][index][j@bone] = db_get_field_assoc_int(resultado,load);

            format(load,sizeof(load),"fOffsetX%d",index);
            Juguetes[playerid][index][j@OffsetX] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fOffsetY%d",index);
            Juguetes[playerid][index][j@OffsetY] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fOffsetZ%d",index);
            Juguetes[playerid][index][j@OffsetZ] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fRotX%d",index);
            Juguetes[playerid][index][j@RotX] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fRotY%d",index);
            Juguetes[playerid][index][j@RotY] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fRotZ%d",index);
            Juguetes[playerid][index][j@RotZ] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fScaleX%d",index);
            Juguetes[playerid][index][j@ScaleX] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fScaleY%d",index);
            Juguetes[playerid][index][j@ScaleY] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"fScaleZ%d",index);
            Juguetes[playerid][index][j@ScaleZ] = db_get_field_assoc_float(resultado,load);

            format(load,sizeof(load),"color1_%d",index);
            Juguetes[playerid][index][j@Color1] = db_get_field_assoc_int(resultado,load);

            format(load,sizeof(load),"color2_%d",index);
            Juguetes[playerid][index][j@Color2] = db_get_field_assoc_int(resultado,load);

            if(Juguetes[playerid][index][j@bone] != 0)
            {
                Juguetes[playerid][index][j@usado] = 1;
            }
        }
    }
    db_free_result(resultado);
}
//============================================================================//
stock ColocarObjetos(playerid)
{
    foreachEx(i:JUGUETES_MAXIMOS)
    {
        if(Juguetes[playerid][i][j@usado] == 1)
        {
            SetPlayerAttachedObject(playerid,
                i,
                Juguetes[playerid][i][j@modelid],
                Juguetes[playerid][i][j@bone],
                Juguetes[playerid][i][j@OffsetX],
                Juguetes[playerid][i][j@OffsetY],
                Juguetes[playerid][i][j@OffsetZ],
                Juguetes[playerid][i][j@RotX],
                Juguetes[playerid][i][j@RotY],
                Juguetes[playerid][i][j@RotZ],
                Juguetes[playerid][i][j@ScaleX],
                Juguetes[playerid][i][j@ScaleY],
                Juguetes[playerid][i][j@ScaleZ],
                Juguetes[playerid][i][j@Color1], // Color primario
                Juguetes[playerid][i][j@Color2]  // Color secundario
            );
        }
    }
}
//============================================================================//
stock DB_Escape(text[])
{
    new ret[80 * 2],ch,i,j;
    while ((ch = text[i++]) && j < sizeof (ret)){
    if (ch == '\''){
    if (j < sizeof (ret) - 2){
    ret[j++] = '\'';
    ret[j++] = '\'';
    }}else if (j < sizeof (ret)){
    ret[j++] = ch;}else{
    j++;}}
    ret[sizeof (ret) - 1] = '\0';
    return ret;
}
//============================================================================//
stock Nombre(playerid)
{
    new NombreAE[MAX_PLAYER_NAME];
    GetPlayerName(playerid,NombreAE,sizeof(NombreAE));
    return NombreAE;
}
//============================================================================//
stock IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}
//============================================================================//
stock RGBAToARGB(col)
{
    return ((((col) << 24) & 0xFF000000) | (((col) >>> 8) & 0xFFFFFF));
}
//============================================================================//
stock IsObjectXValid(modelid)
{
    // Rango aprox de objetos en SA-MP
    if(modelid >= 615 && modelid <= 19999) return 1;
    return 0;
}
//============================================================================//
FormatColoredDialog()
{
    new Dialog_Colored_Lines[256];
    DIALOG_COLOR_String[0] = '\0';

    for(new i = 0; i < sizeof(ColorsObject); i++)
    {
        format(Dialog_Colored_Lines, sizeof(Dialog_Colored_Lines),
            "{%06x}--- COLOR --- %d\n", ColorsObject[i] >>> 8, i + 1);
        strcat(DIALOG_COLOR_String, Dialog_Colored_Lines);
    }
    return 1;
}
//============================================================================//
