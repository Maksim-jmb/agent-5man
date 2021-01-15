objectdef bhSession
{
    variable bool HighlightFullSize=FALSE

    method Initialize()
    {
        ; LavishScript:RegisterEvent[OnFrame]
        ; Event[OnFrame]:AttachAtom[This:OnFrame]
        LavishScript:RegisterEvent[OnMouseEnter]
        LavishScript:RegisterEvent[OnMouseExit]
        Event[OnMouseEnter]:AttachAtom[This:OnMouseEnter]
        Event[OnMouseExit]:AttachAtom[This:OnMouseExit]

        LGUI2:LoadPackageFile[xBH.Session.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xBH.Session.lgui2Package.json]
    }

    method OnMouseEnter()
    {
        if ${Display.ViewableWidth}!=${Display.Width}
        {
            return
        }
        else
        {
            LGUI2.Element[bh.Highlight]:SetVisibility[Visible]
            LGUI2.Element[bh.Number]:SetVisibility[Hidden]
        }
    }
    method OnMouseExit()
    {
       if ${Display.ViewableWidth}!=${Display.Width}
        {
            return
        }
        else
        {
            LGUI2.Element[bh.Highlight]:SetVisibility[Hidden]
            LGUI2.Element[bh.Number]:SetVisibility[Visible]
        }
    }
}

variable(global) bhSession BHSession

function main()
{
    while 1
        waitframe
}