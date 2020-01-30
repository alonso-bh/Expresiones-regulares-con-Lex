%option noyywrap

%{

/******************************************************************************/
// ALONSO BUENO HERRERO, MANUEL CASTELLÓN REGUERO Y PABLO LOMBARDERO ROS
// PRÁCTICA 2 DE MODELOS DE COMPUTACIÓN
// CURSO 2019/20
/******************************************************************************/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

// ficheros de entrada y salida 
ifstream fichero;
ofstream out; 


int nc, np, nl;
vector<string> correos, contrasenas;
void mostrarResultados();
void ordenarCorreos();
%}

CORREO	[a-z0-9]+"@"[a-z]+"."[a-z]*["."[a-z]+]*
PEGAMENTO	[\r\n"	"" "]+
CONTRASENA	[a-zA-Z0-9"@""#""_""&""%""ç""/""€""."]+

%%

{CORREO}{PEGAMENTO}{CONTRASENA}	{
	string cadena(yytext);
	string contrasena;
	cout << cadena << "\n";
	size_t pos = cadena.length(), aux;

	aux = cadena.find("\n");
	if (aux != string::npos && aux < pos)
		pos = aux;
	
	aux = cadena.find("\r");
	if (aux != string::npos && aux < pos)
		pos = aux;
	
	aux = cadena.find("	");			//TAB
	if (aux != string::npos && aux < pos)
		pos = aux;
		
	aux = cadena.find(" ");			//ESPACIO
	if (aux != string::npos && aux < pos)
		pos = aux;
		
	// añadir correo a la lista 
	correos.push_back(cadena.substr(0, pos));
	
	// empezamos a procesar la contraseña 
	contrasena = cadena.substr(pos+1);   
	
	pos = contrasena.find_last_of("\n");
	
	if (pos != string::npos)
		contrasena = contrasena.substr(pos+1);
	
	pos = contrasena.find_last_of("\r");
	if (pos != string::npos)
		contrasena = contrasena.substr(pos+1);
	
	pos = contrasena.find_last_of("	");			//TAB
	if (pos != string::npos)
		contrasena = contrasena.substr(pos+1);
		
	pos = contrasena.find_last_of(" ");			//ESPACIO
	if (pos != string::npos)
		contrasena = contrasena.substr(pos+1);
		
	// añadir contraseña 
	contrasenas.push_back(contrasena);
}

%%


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
int main(int argc, char *argv[]){
	if (argc == 3){
		// abrir flujos de entrada y salida 
		fichero.open(argv[1]);
		out.open(argv[2]); 
		
		if (!fichero){
			cout << "error de lectura" << endl;
			exit(1);
		}
		
		if (!out)
		{
			cout << "Error al abrir el fichero de salida" << endl; 
			exit (2); 
		}
	}
	else{ 
		cout << "Ejecución: ./practica2 <entrada.txt> <salida.txt>" << endl; 
		exit(1);
	}
		
	cout << "HOLA\n";
	
	yyFlexLexer flujo(&fichero, 0);
	flujo.yylex();
	mostrarResultados();
	
	out.close(); 
	
	return 0;
}


/******************************************************************************/
// construye el fichero de salida 
void mostrarResultados(){
	ordenarCorreos();
	cout << "\nRESULTADOS:\n";
	
	// rellenar el fichero de salida con tuplas <correo,clave> ordenadas
	//   por nombre de dominio según el orden alfabético. 
	
	for (int i=0; i<correos.size(); i++){
		out  << correos[i] << "\n";
		out  << contrasenas[i]  << "\n";
	}
}


/******************************************************************************/
// procesamiento de correos y contraseñas: ordenar por dominio 
void ordenarCorreos(){
	vector<string> dominios;
	int pos;
	string tmp;
	bool intercambio = true;
	
	for (int i=0; i<correos.size(); i++){
		pos = correos[i].find("@");
		dominios.push_back(correos[i].substr(pos+1));
	}
	
	// ordenación de los correos, contraseñas y dominios usando el criterio
	//  de ordenación de los dominios alfabéticamente
	for (int i=0;i<dominios.size() && intercambio;i++){
			intercambio=false;			
			for(int j=dominios.size()-1;j>i;j--)
				if(dominios[j]<dominios[j-1])
				{
					intercambio=true;
					tmp=dominios[j];
					dominios[j]=dominios[j-1];
					dominios[j-1]=tmp;
					tmp=correos[j];
					correos[j]=correos[j-1];
					correos[j-1]=tmp;
					tmp=contrasenas[j];
					contrasenas[j]=contrasenas[j-1];
					contrasenas[j-1]=tmp;
				}
	}
}

/******************************************************************************/


