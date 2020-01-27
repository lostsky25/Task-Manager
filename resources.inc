;Constants

WM_NOTIFY			equ 78

;Closing a window
WM_DESTROY			equ 2

;Create a window
WM_CREATE			equ 1


;Error icon
MB_ICONERROR		equ 00000010h

MAX_PATH			equ 260

BS_PUSHBUTTON       equ 00000000h
LB_RESETCONTENT     equ 0184h
LB_ADDSTRING        equ	0180h

;IDS
ID_LIST_PROC		equ 00000020h
ID_LIST_MODUL 		equ 00000021h
ID_BTN_KILL_PROC 	equ 00000022h
; ID_BTN_PAUSE_PROC 	equ 00000013h
; ID_BTN_RESUME_PROC 	equ 00000014h
; IDC_TAB 			equ 00000015h
ID_TABCTRL 			equ 00000023h

; FIRST_PAGE			equ 00000001h
; #define SECOND_PAGE equ 00000002h

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

ICC_TAB_CLASSES     equ   00000008h ;tab, tooltips
TCIF_TEXT           equ	  0001h ;text
TCM_FIRST			equ   1300h
TCM_GETCURFOCUS 	equ   (TCM_FIRST + 47)
TCM_GETITEMCOUNT    equ   (TCM_FIRST + 4)
TCM_INSERTITEMW     equ   (TCM_FIRST + 62)
;Window propertirs
CS_VREDRAW			equ 1h
CS_HREDRAW			equ 2h
CS_GLOBALCLASS 		equ 4000h
WS_OVERLAPPEDWINDOW equ 000CF0000h

STYLE_WINDOW 		equ CS_HREDRAW+CS_VREDRAW+CS_GLOBALCLASS

;Programm icon
IDI_APPLICATION		equ 32512

;List box (with processes)
; ID_LIST_MODUL		equ 000000091h

WS_EX_CLIENTEDGE	equ 00000200h

;!Window propertirs

;Cursor id
IDC_CROSS			equ 32515

;Window mode
SW_SHOWNORMAL		equ 1

;Prototypes of external procedures
EXTERN MessageBoxA@16:NEAR
EXTERN CreateWindowExA@48:NEAR
EXTERN CreateWindowExW@48:NEAR
; EXTERN CreateWindowW@48:NEAR
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
EXTERN InitCommonControlsEx@4:NEAR
EXTERN SendMessageW@16:NEAR
EXTERN Process32NextW@8:NEAR
EXTERN CloseHandle@4:NEAR
EXTERN MoveWindow@24:NEAR
EXTERN UpdateWindow@4:NEAR
;!Prototypes of external procedures

;  DWORD     dwExStyle,
;   LPCSTR    lpClassName,
;   LPCSTR    lpWindowName,
;   DWORD     dwStyle,
;   int       X,
;   int       Y,
;   int       nWidth,
;   int       nHeight,
;   HWND      hWndParent,
;   HMENU     hMenu,
;   HINSTANCE hInstance,
;   LPVOID    lpParam

;  LPCTSTR lpClassName,
; LPCTSTR  lpWindowName,
;  DWORD  dwStyle,
;  int  x,
;  int  y,
;  int  nWidth,
;  int nHeight,
;  HWND hWndParent,
;  HMENU  hMenu,
;  HINSTANCE hInstance,
;   LPVOID lpParam