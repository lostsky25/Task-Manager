TH32CS_SNAPPROCESS equ 00000002h

PROCESSENTRY32W STRUC
    dwSize              DWORD ?
    cntUsage            DWORD ?
    th32ProcessID       DWORD ?
    th32DefaultHeapID   DWORD ?
    th32ModuleID        DWORD ?
    cntThreads          DWORD ?
    th32ParentProcessID DWORD ?
    pcPriClassBase      DWORD ?
    dwFlags             DWORD ?
    szExeFile           dw MAX_PATH dup(?)
PROCESSENTRY32W ENDS

