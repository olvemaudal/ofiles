#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
; SendMode Event
; SendMode InputThenPlay
SendMode Play
; SendMode Input
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

; SetCapsLockState, AlwaysOff

>^b::Send {Left}
>^f::Send {Right}
>^p::Send {Up}
>^n::Send {Down}
>^a::Send {Home}
>^e::Send {End}
>^h::Send {Backspace}
>^d::Send {Delete}
>^g::Send {Escape}

!>^b::Send {ControlDown}{Left}
!>^f::Send {ControlDown}{Right}
!>^p::Send {ControlDown}{Up}
!>^n::Send {ControlDown}{Down}

XButton1::Send {ShiftDown}
XButton2::Send {ShiftDown}

>^q::Return
>^w::Return
>^r::Return
>^t::Return
>^y::Return
>^u::Return
>^i::Return
#>^o::Return
>^s::Return
>^j::Return
>^k::Return
>^l::Return
#>^z::Return
#>^x::Return
#>^c::Return
#>^v::Return
>^m::Return

>^+b::Send {ShiftDown}{Left}
>^+f::Send {ShiftDown}{Right}
>^+p::Send {ShiftDown}{Up}
>^+n::Send {ShiftDown}{Down}
>^+a::Send {ShiftDown}{Home}
>^+e::Send {ShiftDown}{End}

; #IfWinExist ahk_exe ONENOTE.EXE
; >^p::SendPlay {Right}
; >^n::SendPlay {Down}
