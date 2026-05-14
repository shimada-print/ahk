; ===========================================================
; Make Version: AutoHotkey v2.026
; Make Code: 2026.5.14
; Maker: https://zenn.dev/shimada_print
; ===========================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

SaveFile := "data.ini"
CurrentSlot := 1

LeftEdits := []
RightEdits := []

; =========================
; GUI
; =========================

MyGui := Gui()
MyGui.Title := "PasswordMemo 100 File ver.1"

; =========================
; ファイルメニュー
; =========================

FileMenu := Menu()

FileMenu.Add("保存", SaveData)

FileMenu.Add()

Loop 100
{
    n := A_Index

    slotName := IniRead(
        SaveFile,
        "Slot" n,
        "Name1",
        ""
    )

    if (slotName = "")
        menuText := n
    else
        menuText := n " 「" slotName "」"

    FileMenu.Add(
        menuText,
        LoadSlotMenu.Bind(n)
    )
}

FileMenu.Add()

FileMenu.Add("終了", ExitProgram)

; =========================
; ヘルプメニュー
; =========================

HelpMenu := Menu()

HelpMenu.Add("説明", OpenReadme)

HelpMenu.Add("ホームページ", OpenHomepage)

; =========================
; メニューバー
; =========================

MainMenu := MenuBar()

MainMenu.Add("　　　ファイル　　　", FileMenu)

MainMenu.Add("　　　ヘルプ　　　", HelpMenu)

MyGui.MenuBar := MainMenu

; =========================
; 名前欄
; =========================

MyGui.AddText("x10 y10", "名前")

NameLeft := MyGui.AddEdit(
    "x60 y8 w180"
)

NameRight := MyGui.AddEdit(
    "x250 y8 w320"
)

; =========================
; 項目欄
; =========================

Loop 4
{
    y := 50 + ((A_Index - 1) * 40)

    MyGui.AddText(
        "x10 y" y,
        "項目" A_Index
    )

    leftEdit := MyGui.AddEdit(
        "x70 y" y " w180"
    )

    rightEdit := MyGui.AddEdit(
        "x260 y" y " w300"
    )

    LeftEdits.Push(leftEdit)
    RightEdits.Push(rightEdit)
}

; =========================
; 保存ボタン
; =========================

SaveBtn := MyGui.AddButton(
    "x70 y230 w100",
    "保存"
)

SaveBtn.OnEvent("Click", SaveData)

; =========================
; 状態表示
; =========================

StatusText := MyGui.AddText(
    "x200 y235 w380",
    ""
)

; =========================
; 初回ロード
; =========================

LoadSlot(1)

; =========================
; 表示
; =========================

MyGui.Show("w620 h300")

; =========================
; 保存
; =========================

SaveData(*)
{
    global SaveFile
    global CurrentSlot

    global NameLeft
    global NameRight

    global LeftEdits
    global RightEdits

    global StatusText

    IniWrite(
        NameLeft.Text,
        SaveFile,
        "Slot" CurrentSlot,
        "Name1"
    )

    IniWrite(
        NameRight.Text,
        SaveFile,
        "Slot" CurrentSlot,
        "Name2"
    )

    Loop 4
    {
        IniWrite(
            LeftEdits[A_Index].Text,
            SaveFile,
            "Slot" CurrentSlot,
            "Left" A_Index
        )

        IniWrite(
            RightEdits[A_Index].Text,
            SaveFile,
            "Slot" CurrentSlot,
            "Right" A_Index
        )
    }

    StatusText.Text := "現在: ファイル番号" CurrentSlot " / " NameLeft.Text

    MsgBox("保存しました")
}

; =========================
; 読込
; =========================

LoadSlot(slot)
{
    global SaveFile
    global CurrentSlot

    global NameLeft
    global NameRight

    global LeftEdits
    global RightEdits

    global StatusText

    CurrentSlot := slot

    NameLeft.Text := IniRead(
        SaveFile,
        "Slot" slot,
        "Name1",
        ""
    )

    NameRight.Text := IniRead(
        SaveFile,
        "Slot" slot,
        "Name2",
        ""
    )

    Loop 4
    {
        LeftEdits[A_Index].Text := IniRead(
            SaveFile,
            "Slot" slot,
            "Left" A_Index,
            ""
        )

        RightEdits[A_Index].Text := IniRead(
            SaveFile,
            "Slot" slot,
            "Right" A_Index,
            ""
        )
    }

    StatusText.Text := "現在: ファイル番号" CurrentSlot " / " NameLeft.Text
}

; =========================
; メニュー
; =========================

LoadSlotMenu(slot, *)
{
    LoadSlot(slot)
}

; =========================
; readme.txtを開く
; =========================

OpenReadme(*)
{
    Run("readme.txt")
}

; =========================
; ホームページ
; =========================

OpenHomepage(*)
{
    Run("https://github.com/shimada-print/ahk/edit/main/win-app/Password-Memo_100-File_ver.1/")
}

; =========================
; 終了
; =========================

ExitProgram(*)
{
    ExitApp()
}
