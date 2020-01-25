;Constants

;Closing a window
WM_DESTROY			equ 2

;Create a window
WM_CREATE			equ 1

;Error icon
MB_ICONERROR		equ 00000010h

MAX_PATH			equ 260

;Click event (left mouse button)
;WM_LBUTTONDOWN 		equ 201h

;Click event (right mouse button)
;WM_RBUTTONDOWN 		equ 204h

WS_CHILD 			equ 40000000h
WS_VISIBLE          equ 10000000h
LBS_NOTIFY         	equ 0001h
LBS_SORT            equ 0002h
WS_VSCROLL          equ 00200000h
WS_BORDER           equ 00800000h
LBS_WANTKEYBOARDINPUT equ 0400h
LBS_STANDARD        equ (LBS_NOTIFY or LBS_SORT or WS_VSCROLL or WS_BORDER)
;!Constants

;Window propertirs
CS_VREDRAW			equ 1h
CS_HREDRAW			equ 2h
CS_GLOBALCLASS 		equ 4000h
WS_OVERLAPPEDWINDOW equ 000CF0000h

STYLE_WINDOW 		equ CS_HREDRAW+CS_VREDRAW+CS_GLOBALCLASS

;Programm icon
IDI_APPLICATION		equ 32512

;List box (with processes)
ID_LIST_MODUL		equ 000000091h

WS_EX_CLIENTEDGE	equ 00000200h

;!Window propertirs

;Cursor id
IDC_CROSS			equ 32515

;Window mode
SW_SHOWNORMAL		equ 1

;Prototypes of external procedures
EXTERN MessageBoxA@16:NEAR
EXTERN CreateWindowExA@48:NEAR
EXTERN DefWindowProcA@16:NEAR
EXTERN DispatchMessageA@4:NEAR
EXTERN ExitProcess@4:NEAR
EXTERN GetMessageA@16:NEAR
EXTERN GetModuleHandleA@4:NEAR
EXTERN LoadCursorA@8:NEAR
EXTERN LoadIconA@8:NEAR
EXTERN PostQuitMessage@4:NEAR
EXTERN RegisterClassA@4:NEAR
EXTERN ShowWindow@8:NEAR
EXTERN TranslateMessage@4:NEAR
EXTERN UpdateWindow@4:NEAR
EXTERN CreateToolhelp32Snapshot@8:NEAR
EXTERN Process32FirstW@8:NEAR
EXTERN SendMessageW@16:NEAR
;!Prototypes of external procedures