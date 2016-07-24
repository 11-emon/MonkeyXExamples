Import mojo

Class gridbackground
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field mapdepth:Int
    Field mapr:Int[][]
    Field mapg:Int[][]
    Field mapb:Int[][]    
    Field pixels:Int[]
    Field image:Image
    Method New(mapwidth:Int,mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        pixels = New Int[mapwidth*mapheight]
        image = CreateImage(mapwidth,mapheight)
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        mapr = New Int[mapwidth][]
        mapg = New Int[mapwidth][]
        mapb = New Int[mapwidth][]                
        For Local i = 0 Until mapwidth
            mapr[i] = New Int[mapheight]
			mapg[i] = New Int[mapheight]            
			mapb[i] = New Int[mapheight]
        Next 
        addrectslayer
        brusheffect()
        smooth
		darkenrange(230,255,30)
		brusheffect2
		'avarage
        putinimage
    End Method
    Method avarage()
    	For Local i=0 Until (mapwidth*mapheight)/100
    		Local x1:Int=Rnd(0,mapwidth)
    		Local y1:Int=Rnd(0,mapheight)
    		Local col1r:Int=mapr[x1][y1]
    		Local col1g:Int=mapg[x1][y1]
    		Local col1b:Int=mapb[x1][y1]
		   	For Local ii=0 Until (mapwidth*mapheight)/50
	    		Local x2:Int=Rnd(0,mapwidth)
	    		Local y2:Int=Rnd(0,mapheight)
	   			If mapr[x2][y2] < col1r Then mapr[x2][y2] += 1
	   			If mapg[x2][y2] < col1g Then mapg[x2][y2] += 1
	   			If mapb[x2][y2] < col1b Then mapb[x2][y2] += 1

   				If mapr[x2][y2] > col1r Then mapr[x2][y2] -= 1
	   			If mapg[x2][y2] > col1g Then mapg[x2][y2] -= 1
	   			If mapb[x2][y2] > col1b Then mapb[x2][y2] -= 1
			Next
	   	Next
    End Method
    Method darkenrange(low:Int,high:Int,ranval:Int)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
			If mapr[x][y] > low
				mapr[x][y] -= Rnd(ranval/2,ranval)
				mapg[x][y] -= Rnd(ranval/2,ranval)
				mapb[x][y] -= Rnd(ranval/2,ranval)
			End If
			If mapg[x][y] > low
				mapr[x][y] -= Rnd(ranval/2,ranval)
				mapg[x][y] -= Rnd(ranval/2,ranval)
				mapb[x][y] -= Rnd(ranval/2,ranval)
			End If
			If mapb[x][y] > low
				mapr[x][y] -= Rnd(ranval/2,ranval)
				mapg[x][y] -= Rnd(ranval/2,ranval)
				mapb[x][y] -= Rnd(ranval/2,ranval)
			End If

		Next
		Next    	
    End Method
    Method smooth()
    	For Local i=0 Until (mapwidth*mapheight)
    		Local x:Int=Rnd(0,mapwidth-1)
    		Local y:Int=Rnd(0,mapheight-1)
    		Local col1r:Int=mapr[x+1][y]
    		Local col1g:Int=mapg[x+1][y]
    		Local col1b:Int=mapb[x+1][y]    		    		
    		
    		Local col2r:Int=mapr[x+1][y+1]
	   		Local col2g:Int=mapg[x+1][y+1]    		
    		Local col2b:Int=mapb[x+1][y+1]
    		
    		Local col3r:Int=mapr[x][y+1]    		    		
    		Local col3g:Int=mapg[x][y+1]    		    		
    		Local col3b:Int=mapb[x][y+1]    		    		

    		Local col4r:Int=(col1r+col2r+col3r)/3
    		Local col4g:Int=(col1g+col2g+col3g)/3
    		Local col4b:Int=(col1b+col2b+col3b)/3    		    		
    		mapr[x][y] = col4r+Rnd(0,20)
    		mapg[x][y] = col4g
    		mapb[x][y] = col4b
    		mapr[x][y] = Clamp(mapr[x][y],0,255)
    		mapg[x][y] = Clamp(mapg[x][y],0,255)
    		mapb[x][y] = Clamp(mapb[x][y],0,255)
    	Next
    End Method
    Method brusheffect() 'explosion effect copy from in area to another part in area in half the brishtness
    	For Local i=0 Until (mapwidth*mapheight)/20
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		For Local y1=-5 To 5
    		For Local x1=-5 To 5
    			Local x2:Int=x+x1
    			Local y2:Int=y+y1
				If Rnd(10)<3
				If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
					Local colr:Int=mapr[x2][y2]
					Local colg:Int=mapg[x2][y2]
					Local colb:Int=mapb[x2][y2]
					
					Local x3:Int=x2+Rnd(-5,5)
					Local y3:Int=y2+Rnd(-5,5)
					If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
						mapr[x3][y3] = (colr)/2
						mapg[x3][y3] = (colg)/2
						mapb[x3][y3] = (colb)/2
					End If
				End If
				End If
    		Next
    		Next
    	Next
    End Method
    Method brusheffect2()
    	For Local i=0 Until (mapwidth*mapheight)
    		Local x1:Float=Rnd(0,mapwidth)
    		Local y1:Float=Rnd(0,mapheight)
    		Local angle:Int=Rnd(-180,180)
    		Local dist:Int=Rnd(3,15)
    		For Local iii=0 Until 20
    		For Local ii=0 Until dist
    			Local x4:Float=x1+Rnd(-5,5)
    			Local y4:Float=y1+Rnd(-5,5)
    			Local x2:Float=x4+Cos(angle)*1
    			Local y2:Float=y4+Sin(angle)*1
    			Local x3:Float=x4+Cos(angle)*2
    			Local y3:Float=y4+Sin(angle)*2
    			If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
    			If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
    				mapr[x3][y3] = mapr[x2][y2]
    				mapg[x3][y3] = mapg[x2][y2]
    				mapb[x3][y3] = mapb[x2][y2]
    			End If
    			End If    			
			Next
			Next
    	Next
    End Method    
    Method addrectslayer()
    	For Local i=0 Until (mapwidth*mapheight)/20
    		Local w:Int=Rnd(3,10)
    		Local h:Int=Rnd(3,10)
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		Local colr:Int=255
    		Local colg:Int=255
    		Local colb:Int=255
    		mapdrawrect(x,y,w,h,colr,colg,colb)
    	Next
    End Method
    Method mapdrawrect(x:Int,y:Int,w:Int,h:Int,colr:Int,colg:Int,colb:Int)
    	For Local y1=y Until y+h
    	For Local x1=x Until x+w
    		If x1>-1 And y1>-1 And x1<mapwidth And y1<mapheight
    			mapr[x1][y1] = colr
    			mapg[x1][y1] = colg
    			mapb[x1][y1] = colb
    		End If
    	Next
    	Next
    End Method
    Method draw()
    	DrawImage image,0,0,0,1.2,1
    	Return
        For Local y=0 Until mapheight-1
        For Local x=0 Until mapwidth-1
			Local colr:Int=mapr[x][y]
			Local colg:Int=mapg[x][y]
			Local colb:Int=mapb[x][y]
			SetColor colr,colg,colb
			DrawRect x*tilewidth,y*tileheight,tilewidth+1,tileheight+1
        Next
        Next    
    End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method  
	Method argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
	   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Method
    Method putinimage()
    	Local cnt:Int=0
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		pixels[cnt] = argb(mapr[x][y],mapg[x][y],mapb[x][y])
    		cnt+=1
    	Next
    	Next
        image.WritePixels(pixels, 0, 0, mapwidth, mapheight, 0)
    End Method
End Class

Global mygbg:gridbackground

Class MyGame Extends App
    Field time:Int=0
    Method OnCreate()
    	Seed = GetDate[5]
        SetUpdateRate(1)
        mygbg = New gridbackground(512,512)
    End Method
    Method OnUpdate() 
    	time+=1
    	If time>10 Then
			time=0
	    	Local r:Int=Rnd(3)
	    	Local ts:Int=128
	    	If r=0 Then	ts=512
			If r=1 Then ts=512
			If r=2 Then ts=512
			mygbg = New gridbackground(ts,ts)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mygbg.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
