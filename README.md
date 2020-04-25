# Task-Manager
![sc](https://user-images.githubusercontent.com/57411317/80278190-f5169580-86fc-11ea-9b1c-72351ddddf60.PNG)

The application allows to suspend\resume and kill some process. For that I used NativeAPI functions, such as: 
* NtSuspendProcess
* NtResumeProcess

The binary file takes 7.50 КБ. You can build it, using the following commands:

Build:
ml /coff /c task_manager.asm
link /SUBSYSTEM:WINDOWS task_manager.obj

Run:
task_manager.exe

[Download MASM](https://www.masm32.com/)

## Task-Manager Errors:
  *	Process opening , the access to some process– error code  101
  *	Troubles with getting of the loaded module – error code 102
  *	Impossible retrieve(извлекает) the address of an exported function or variable from dynamic-link library – error code 103
  *	It didn’t chose process, you should chose any process – error code 104
  *	You don’t have permissions for  that – error code 105
  *	Process can’t be  terminate – error 106
  *	Process list could not be retrieved – error code 107
  *	First module can’t be get (of some process) – error code 108
  * Can’t retrieves a module handle for the specified module – error code 109
