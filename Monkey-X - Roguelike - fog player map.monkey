
Import mojo

Global mapwidth:Int=50
Global mapheight:Int=50
Global sw:Int=640
Global sh:Int=480

Class player
	Field x:Int,y:Int,controldelay:Int
	Field tleft:Bool,tright:Bool,tup:Bool,tdown:Bool
	Field tleftx:Int=20
	Field tlefty:Int=sh-100
	Field trightx:Int=120
	Field trighty:Int=sh-100
	Field tupx:Int=70
	Field tupy:Int=sh-150
	Field tdownx:Int=70
	Field tdowny:Int=sh-50
	Method New()
		 x = mymap.mypoint.Get(1).x
		 y = mymap.mypoint.Get(1).y
		 playerfog(x,y,6)
	End Method
	Method update()
		controldelay+=1
		If controldelay<10 Then Return
		'touch mouse input
		If MouseDown(MOUSE_LEFT) Or TouchDown
			Local x:Int
			Local y:Int
			Local w:Int=100
			Local h:Int=50
			x = tupx
			y = tupy
			If rectsoverlap(x,y,w,h,MouseX(),MouseY(),1,1) Then tup=True
			x = tdownx
			y = tdowny
			If rectsoverlap(x,y,w,h,MouseX(),MouseY(),1,1) Then tdown=True
			x = tleftx
			y = tlefty
			If rectsoverlap(x,y,w,h,MouseX(),MouseY(),1,1) Then tleft=True
			x = trightx
			y = trighty
			If rectsoverlap(x,y,w,h,MouseX(),MouseY(),1,1) Then tright=True
		End If

		'keyinput
		If KeyDown(KEY_UP) Or tup
			If y-1 >= 0 
				If mymap.map[x][y-1] = 1 Then y-=1
				controldelay = 0
				playerfog(x,y,6)
			End If
		End If
		If KeyDown(KEY_DOWN) Or tdown
			If y+1 < mymap.mh
				If mymap.map[x][y+1] = 1 Then y+=1
				controldelay = 0
				playerfog(x,y,6)
			End If
		End If
		If KeyDown(KEY_RIGHT) Or tright
			If x+1 < mymap.mw
				If mymap.map[x+1][y] = 1 Then x+=1
				controldelay = 0
				playerfog(x,y,6)
			End If
		End If
		If KeyDown(KEY_LEFT) Or tleft
			If x-1 >=0 
				If mymap.map[x-1][y] = 1 Then x-=1
				controldelay = 0
				playerfog(x,y,6)
			End If
		End If
		tup=False
		tright=False
		tdown=False
		tleft=false
	End Method
	Method draw()
		SetColor 255,255,255
		Local tw:Float=mymap.tw
		Local th:Float=mymap.th
		DrawRect x*tw,y*th,tw,th
		SetColor 255,255,0
		DrawRect tleftx,tlefty,100,50
		SetColor 255,255,255
		DrawText "Left",tleftx+50,tlefty+25,0.5,0.5
		SetColor 255,255,0
		DrawRect trightx,trighty,100,50
		SetColor 255,255,255
		DrawText "Right",trightx+50,trighty+25,0.5,0.5
		SetColor 255,255,0
		DrawRect tupx,tupy,100,50
		SetColor 255,255,255
		DrawText "Up",tupx+50,tupy+25,0.5,0.5
		SetColor 255,255,0
		DrawRect tdownx,tdowny,100,50
		SetColor 255,255,255
		DrawText "Down",tdownx+50,tdowny+25,0.5,0.5

	End Method
    Method playerfog(x1,y1,radius:Float)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                If x3>=0 And x3<mymap.mw And y3>=0 And y3<mymap.mh
					mymap.fogmap[x3][y3] = True
				End If
            End If
        Next
        Next    
    End Method
    Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method 
End Class

Class map
	Field mw:Int,mh:Int,sw:Int,sh:Int,tw:Float,th:Float
	Field mypoint:Stack<point> = New Stack<point>
	Field myline:Stack<line> = New Stack<line>
	Field map:Int[][]
	Field fogmap:Bool[][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw)/Float(mw)
		Self.th = Float(sh)/Float(mh)
		map = New Int[mw][]
		fogmap = New Bool[mw][]
		For Local i=0 Until mw
			map[i] = New Int[mh]
			fogmap[i] = New Bool[mh]
		Next
		For Local i=0 Until mw*mh/200
			Local x:Int=Rnd(5,mw-5)
			Local y:Int=Rnd(5,mh-5)
			If rectsoverlap(x*tw,y*th,1,1,0,sh-240,320,240) = False
			mypoint.Push(New point(i,x,y))
			End If
		Next
		makemap()
	End Method
	Method makemap()
		' connect point to closest point with unique id
		'get first point
		Local x:Int=mypoint.Get(0).x
		Local y:Int=mypoint.Get(0).y
		Local id:Int=mypoint.Get(0).id 
		Local closestindex:Int=0
		While closestindex<>-1
			'find closest
			Local dist:Int=10000		
			closestindex=-1		
			For Local ii=0 Until mypoint.Length
				If mypoint.Get(ii).id <> id
				Local d:Int=distance(x,y,mypoint.Get(ii).x,mypoint.Get(ii).y) 
				If d<dist Then			
					dist=d
					closestindex = ii
				End If
				End If
			Next
			If closestindex>-1
				mypoint.Get(closestindex).id = id
				myline.Push(New line(x,y,mypoint.Get(closestindex).x,mypoint.Get(closestindex).y))
				x = mypoint.Get(closestindex).x
				y = mypoint.Get(closestindex).y
			End If
		Wend
		'make the map
		For Local i:=Eachin myline
			Local x1:Int=i.x1
			Local y1:Int=i.y1
			Local x2:Int=i.x2
			Local y2:Int=i.y2
			Local exitloop:Bool=False
			While exitloop=False
				If x1<x2 Then x1+=1
				If x1>x2 Then x1-=1
				If y1<y2 Then y1+=1
				If y1>y2 Then y1-=1
				If x1=x2 And y1=y2 Then exitloop=True
				' create the tunnel size
				Local s:Int=Rnd(1,3)
				' sometimes make a wider tunnel
				If Rnd(mw*mh)< (mw*mh/7) Then s=Rnd(s,s*3)
				putmap(x1,y1,s)
			Wend
		Next
	End Method
	Method putmap(x:Int,y:Int,s:Int)
		For Local y3=-s To s
		For Local x3=-s To s
			Local x4:Int=x+x3
			Local y4:Int=y+y3
			If x4>=0 And x4<mw And y4>=0 And y4<mh
			map[x4][y4] = 1
			End If
		Next
		Next	
	End Method
	Method draw()
		SetColor 155,50,0
		For Local y=0 Until mh
		For Local x=0 Until mw
			If map[x][y] = 1 And fogmap[x][y] = true
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
	End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method	
    Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method 
End Class

Class point
	Field id:Int
	Field x:Int,y:Int
	Method New(id:Int,x:Int,y:Int)
		Self.id = id
		Self.x = x
		Self.y = y
	End Method
End Class
Class line
	Field x1:Int,y1:Int
	Field x2:Int,y2:Int
	Method New(x1:Int,y1:Int,x2:Int,y2:Int)
		Self.x1 = x1
		Self.y1 = y1
		Self.x2 = x2
		Self.y2 = y2
	End Method
End Class

Global mymap:map
Global myplayer:player

Class MyGame Extends App
	Field mapexplored:Bool=False
	Field w:Int=mapwidth,h:Int=mapheight
    Method OnCreate()
        SetUpdateRate(60)
        mymap = New map(640,480,w,h)
        myplayer = New player()
    End Method
    Method OnUpdate()        
    	If KeyDown(KEY_SPACE) Or mapexplored = True Then 
    		mapexplored = False
			Seed = Millisecs()
			w+=2
			h+=2
			If w>300 Then w = 50 ; h = 50
			mymap = New map(640,480,w,h)
			myplayer = New player()
    	End If
    	myplayer.update
    	If Rnd()<.01 And ismapexplored() Then mapexplored=True
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        myplayer.draw
        SetColor 255,255,255
        SetAlpha 0.5
        DrawText "RogueLike random maps and fog of war and player. space/mouse new map, cursors move.",0,0
        DrawText "If everything is explored a new map is created.",0,15
    End Method
End Class

Function ismapexplored:Bool()
	Local ex:Bool=True
	For Local y=0 Until mymap.mh
	For Local x=0 Until mymap.mw
		If mymap.map[x][y] = 1 And mymap.fogmap[x][y] = False Then ex=False
	Next
	Next
	Return ex
End Function

Function Main()
    New MyGame()
End Function
