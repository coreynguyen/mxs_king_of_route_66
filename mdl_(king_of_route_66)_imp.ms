/*
	3ds max's MaxScript for Importing mdl / tmb from king of route 66 on ps2

	written by mariokart64n
	dec 9 2022
	
	Script written around a dozen file samples uploaded here
	https://forum.xentax.com/viewtopic.php?p=156970#p156970

	notes:
		I was curious about the face drawing since others seemed to have issue with it.
		Looks as if the faces are written after the vertices as an array of bytes.
		when a 0 is read the face is saved, where if theres a 1 then you skip basically.
		The other component to this was to read the mesh table to get the proper submeshes
		out of the vertex buffer.. kind of standard stuff.
		
		Only issue is there isn't much to the mesh table, it links into an object table
		that builds bones which I was unable to resolve. But I was able to get the mesh
		to import correctly so I was happy enough with that.
		
		Script was only tested on the samples of Arizona, so theres a high chance the
		script won't work on anything.
		
		
*/
clearListener()

try(destroyDialog iu_king_of_route_66_mdl)catch(iu_king_of_route_66_mdl)
rollout iu_king_of_route_66_mdl "MDL" (
		
	struct fmtTMB_Entry_0x01 ( -- 96 bytes, material
		/*float[4]*/       	unk115 = #(0.0, 0.0, 0.0, 1.0), -- Diffuse Colour (RGBA)
		/*float[4]*/       	unk116 = #(1.0, 1.0, 1.0, 1.0), -- Ambient Colour (RGBA)
		/*float[4]*/       	unk117 = #(0.0, 0.0, 0.0, 1.0), -- Emissive Colour (RGBA)
		/*float[4]*/       	unk118 = #(1.0, 1.0, 1.0, 0.0), -- Specular Colour (RGBA)
		/*uint32_t*/       	unk119 = 0, -- Specular Power?
		/*uint16_t*/       	unk120 = 0,
		/*uint16_t*/       	unk121 = 0,
		/*uint16_t*/       	unk122 = 0,
		/*uint16_t*/       	unk123 = 0,
		/*uint32_t*/       	unk124 = 0,
		/*uint32_t*/       	unk125 = 0,
		/*uint32_t*/       	unk126 = 0,
		/*uint32_t*/       	unk127 = 0,
		/*uint32_t*/       	unk128 = 0,
		fn read &f = (
			unk115 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			unk116 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			unk117 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			unk118 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			unk119 = readLong f #unsigned
			unk120 = readShort f #unsigned
			unk121 = readShort f #unsigned
			unk122 = readShort f #unsigned
			unk123 = readShort f #unsigned
			unk124 = readLong f #unsigned
			unk125 = readLong f #unsigned
			unk126 = readLong f #unsigned
			unk127 = readLong f #unsigned
			unk128 = readLong f #unsigned
			)
		)
	
	struct fmtTMB_Entry_0x02 ( -- 240 bytes, object?
		
		/*char[32]*/               	name3 = "",
		/*float[4][4]*/           	unk131 = #( -- Transform
										#(1.0, 0.0, 0.0, 0.0), 
										#(0.0, 1.0, 0.0, 0.0), 
										#(0.0, 0.0, 1.0, 0.0), 
										#(0.0, 0.0, 0.0, 1.0)
										),
		/*uint32_t*/               	unk0132 = 0.0,
		/*uint32_t*/               	unk0133 = 0.0,
		/*uint32_t*/               	unk0134 = 0.0,
		/*uint32_t*/               	unk0135 = 0.0,
		/*uint32_t*/               	unk0136 = 0.0,
		/*uint32_t*/               	unk0137 = 0.0,
		/*uint32_t*/               	unk0138 = 0.0,
		/*uint32_t*/               	unk0139 = 0.0,
		/*uint32_t*/               	unk0140 = 0.0,
		/*uint32_t*/               	unk0141 = 0.0,
		/*uint32_t*/               	unk0142 = 0.0,
		/*uint32_t*/               	unk0143 = 0.0,
		/*uint32_t*/               	unk0144 = 0.0,
		/*uint32_t*/               	unk0145 = 0.0,
		/*uint32_t*/               	unk0146 = 0.0,
		/*uint32_t*/               	unk0147 = 0.0,
		/*uint32_t*/               	unk0148 = 0.0,
		/*uint32_t*/               	unk0149 = 0.0,
		/*uint32_t*/               	unk0150 = 0.0,
		/*uint32_t*/               	unk0151 = 0.0,
		/*uint32_t*/               	unk0152 = 0.0,
		/*uint32_t*/               	unk0153 = 0.0,
		/*uint32_t*/               	unk0154 = 0.0,
		/*uint32_t*/               	unk0155 = 0.0,
		/*uint32_t*/               	unk0156 = 0.0,
		/*uint32_t*/               	unk0157 = 0.0,
		/*uint32_t*/               	unk0158 = 0.0,
		/*uint32_t*/               	unk0159 = 0.0,
		/*uint32_t*/               	unk0160 = 0.0,
		/*uint32_t*/               	unk0161 = 0.0,
		/*uint32_t*/               	unk0162 = 0.0,
		/*uint32_t*/               	unk0163 = 0.0,
		/*int32_t*/               	unk0164 = -1,
		/*int32_t*/               	unk0165 = -1, -- -1 parent?
		/*int32_t*/               	unk0166 = -1, -- -1 index?
		/*uint32_t*/               	unk0167 = 0, -- padding probably
		
		fn readFixedString &f len = (
			str = ""
			local p = ftell f + len
			local i = 1
			local b = 1
			for i = 1 to len do (
				b = readByte f #unsigned
				if b > 0 then (
					str += bit.IntAsChar b
					)
				else (
					exit
					)
				)
			fseek f p #seek_set
			str
			),
		
		fn read &f = (
			name3 = readFixedString &f 32
			
			-- matrix?
			unk131 = #(
				#(readFloat f, readFloat f, readFloat f, readFloat f), -- 1 0 0 0
				#(readFloat f, readFloat f, readFloat f, readFloat f), -- 0 1 0 0
				#(readFloat f, readFloat f, readFloat f, readFloat f), -- 0 0 1 0
				#(readFloat f, readFloat f, readFloat f, readFloat f)  -- 0 0 0 1
				)
			
			unk0132 = readFloat f
			unk0133 = readFloat f
			unk0134 = readFloat f
			unk0135 = readFloat f -- 1.0
			
			-- empty
			unk0136 = readFloat f
			unk0137 = readFloat f
			unk0138 = readFloat f
			unk0139 = readFloat f
			unk0140 = readFloat f
			unk0141 = readFloat f
			unk0142 = readFloat f
			unk0143 = readFloat f
			unk0144 = readFloat f
			unk0145 = readFloat f
			unk0146 = readFloat f
			unk0147 = readFloat f
			unk0148 = readFloat f
			unk0149 = readFloat f
			unk0150 = readFloat f
			unk0151 = readFloat f
			
			-- transform?
			unk0152 = readFloat f
			unk0153 = readFloat f
			unk0154 = readFloat f
			unk0155 = readFloat f
			
			unk0156 = readFloat f
			unk0157 = readFloat f
			unk0158 = readFloat f
			unk0159 = readFloat f
			
			unk0160 = readFloat f
			unk0161 = readFloat f
			unk0162 = readFloat f
			unk0163 = readFloat f -- 1.0
			
			unk0164 = readLong f #signed
			unk0165 = readLong f #signed -- -1
			unk0166 = readLong f #signed -- -1
			unk0167 = readLong f #unsigned
			)
		)
	
	struct fmtTMB_Entry_0x03 ( -- 48 bytes, ??
		unk080 = 0,
		unk081 = 0,
		unk082 = 0,
		unk083 = 0.0,
		unk084 = 0.0,
		unk085 = 0.0,
		unk086 = 0.0,
		unk087 = 0.0,
		unk088 = 0,
		unk089 = 0,
		unk090 = 0,
		unk091 = 0,
		fn read &f = (
			unk080 = readLong f #unsigned
			unk081 = readLong f #unsigned
			unk082 = readLong f #unsigned
			unk083 = readFloat f
			unk084 = readFloat f
			unk085 = readFloat f
			unk086 = readFloat f
			unk087 = readFloat f
			unk088 = readLong f #unsigned
			unk089 = readLong f #unsigned
			unk090 = readLong f #unsigned
			unk091 = readLong f #unsigned
			)
		)
	
	struct fmtTMB_Entry_0x04 ( -- 32 bytes, mesh info? verts counts etc
		/*uint32_t*/               	unk0168 = 0,
		/*uint32_t*/               	unk0169 = 0, -- 3
		/*uint32_t*/               	unk0170 = 0,
		/*uint32_t*/               	unk0171 = 0,
		/*uint32_t*/               	unk0172 = 0,
		/*uint32_t*/               	unk0173 = 0,
		/*uint32_t*/               	unk0174 = 0,
		/*uint32_t*/               	unk0175 = 0, -- 0, probably padding
		fn read &f = (
			
			unk0168 = readLong f #unsigned
			unk0169 = readLong f #unsigned -- 3
			
			unk0170 = readLong f #unsigned
			unk0171 = readLong f #unsigned
			unk0172 = readLong f #unsigned
			unk0173 = readLong f #unsigned
			unk0174 = readLong f #unsigned
			unk0175 = readLong f #unsigned
			),
		
		fn repr = (
			format "%\t%\t%\t%\t%\t%\t%\t%\n" \
				unk0168 unk0169 unk0170 unk0171 \
				unk0172 unk0173 unk0174 unk0175
			)
		
		)
	
	struct fmtTMB_Entry_0x05 ( -- 32 bytes, vertex position, normal
		/*
			vertices are in world space, yay no need to transform them
		*/
		/*float[4]*/               	unk0180 = #(0.0, 0.0, 0.0, 1.0), -- Position
		/*float[4]*/               	unk0181 = #(0.0, 0.0, 0.0, 1.0), -- Normal
		fn read &f = (
			unk0180 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			unk0181 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			)
		
		)
	
	struct fmtTMB_Entry_0x06 ( -- 16 bytes, Vertex Positions Again lol
		/*float[4]*/               	unk0191 = #(0.0, 0.0, 0.0, 0.0), -- Position
		fn read &f = (
			unk0191 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			)
		)
	
	--struct fmtTMB_Entry_0x07 (uint8_t b) -- weird boolean table

	struct fmtTMB_Entry_0x08 ( -- 16 bytes, Normals Again
		/*float[4]*/               	unk0192 = #(0.0, 0.0, 0.0, 0.0),
		fn read &f = (
			unk0192 = #(readFloat f, readFloat f, readFloat f, readFloat f)
			)
		)
	
	struct fmtTMB_Entry_0x0B (
		/*uint32_t*/               	type = 0,
		/*uint32_t*/               	unk0200 = #(),
		fn read &f = (
			/*
			need to review more samples,
			
			looks like its an array of ints,
			and it the int is bitmasked with 0x80
			then you start reading a new array to
			stream into..
			
			however theres some ints and floats so
			i had figured there was a type specifier
			but i'm unsure...
			
			i'll have to look at smaller samples to
			quantify the patterns in the stream..
			
			*/
			)
		)
	
	--struct fmtTMB_Entry_0x0C ()
	
	struct fmtTMB_Table3_Entry ( -- 32 bytes
		/*uint32_t*/       	unk0181 = 0, -- vertex size
		/*uint32_t*/       	unk0182 = 0, -- 3
		/*uint32_t*/       	unk0183 = 0, -- index?
		/*uint32_t*/       	unk0184 = 0, -- 1.) vertex position
		/*uint32_t*/       	unk0185 = 0, -- 2.) ? position
		/*uint32_t*/       	unk0186 = 0, -- 3.) normal position
		/*uint32_t*/       	unk0187 = 0, -- 4.) ? position
		/*uint32_t*/       	unk0188 = 0, -- 5.) ? position
		fn read_table3_entry &f = (
			unk0181 = readLong f #unsigned
			unk0182 = readLong f #unsigned
			unk0183 = readLong f #unsigned
			unk0184 = readLong f #unsigned
			unk0185 = readLong f #unsigned
			unk0186 = readLong f #unsigned
			unk0187 = readLong f #unsigned
			unk0188 = readLong f #unsigned
			)
		)
	
	struct fmtTMB_Addr ( -- 8 bytes
		/*uint32_t*/       	addr = 0, -- multiply by 16
		/*uint32_t*/       	count = 0,
		fn read &f = (
			addr = readLong f #unsigned
			count = readLong f #unsigned
			)
		)
	
	struct fmtTMB (
		/*uint32_t*/               	type = 0x20424D54,
		/*uint32_t*/               	unk101 = 0,
		/*float*/                  	unk102 = 0.0,
		/*fmtTMB_Addr[13]*/     	addrs = #(),
		
		/*char[64]*/               	textures = #(),
		/*fmtTMB_Entry_0x01[]*/    	boneArray = #(),
		/*fmtTMB_Entry_0x02[]*/    	objArray = #(),
		/*fmtTMB_Entry_0x03[]*/    	mshArray = #(),
		--0x04
		/*fmtTMB_Entry_0x05[]*/    	vertArray = #(),
		/*fmtTMB_Entry_0x06[]*/    	unk0190Array = #(),
		/*uint8_t[]*/             	flagArray = #(),
		/*fmtTMB_Entry_0x08[]*/    	unk0193Array = #(),
		/*uint16_t[]*/            	unk0195Array = #(),
		fn readFixedString &f len = (
			str = ""
			local p = ftell f + len
			local i = 1
			local b = 1
			for i = 1 to len do (
				b = readByte f #unsigned
				if b > 0 then (
					str += bit.IntAsChar b
					)
				else (
					exit
					)
				)
			fseek f p #seek_set
			str
			),
		
		fn readFaces pos count = (
			
			local Face_array = #()	
			if count > 0 do (
				local face = #(1, 2, 3)
				local counter = 1
				local j = 1
				for j = 1 to flagArray.count do (
					
					face = #(face[2], face[3], counter)
					
					if face[1] > count or face[2] > count or face[3] > count do (
						exit
						)
					
					counter += 1
					
					if flagArray[j + pos] == 0 then (
						if bit.and j 1 then (
							append Face_array [face[1], face[2], face[3]]
							)
						else (
							append Face_array [face[1], face[3], face[2]]
							)
						)
					)
				)
			Face_array
			),
		
		fn read &f = (
			
			-- get start of file
			local pos = ftell f
			
			-- Read header
			type = readLong f #unsigned
			unk101 = readLong f #unsigned
			unk102 = readFloat f
			
			-- Read Block Table
			addrs = #()
			local num_addrs = 13
			addrs[num_addrs] = fmtTMB_Addr()
			
			local i = 1
			local x = 0
			local j = 1
			textures = #()
			boneArray = #()
			objArray = #()
			mshArray = #()
			vertArray = #()
			unk0190Array = #()
			flagArray = #()
			unk0193Array = #()
			unk0195Array = #()
			for i = 1 to num_addrs do (
				
				-- deduct 1, only required for maxscript
				x = i - 1
				
				-- seek to table entry
				fseek f (pos + 12 + (x * 8)) #seek_set
				
				-- Init Array Element
				addrs[i] = fmtTMB_Addr()
				
				-- Read Entry
				addrs[i].read(&f)
				
				-- Skip if address is null
				if addrs[i].addr == 0 do continue
				
				-- Read Block
				fseek f (pos + (addrs[i].addr * 16)) #seek_set
				case x of (
					0x00: ( -- Texture Names
						if addrs[i].count > 0 do (
							textures[addrs[i].count] = ""
							for j = 1 to addrs[i].count do (
								textures[j] = readFixedString f 64
								)
							)
						)
					0x01: ( -- Bones, Probably...
						if addrs[i].count > 0 do (
							boneArray[addrs[i].count] = fmtTMB_Entry_0x01()
							for j = 1 to addrs[i].count do (
								boneArray[j] = fmtTMB_Entry_0x01()
								boneArray[j].read(&f)
								)
							)
						)
					0x02: ( -- Object
						if addrs[i].count > 0 do (
							objArray[addrs[i].count] = fmtTMB_Entry_0x02()
							for j = 1 to addrs[i].count do (
								objArray[j] = fmtTMB_Entry_0x02()
								objArray[j].read(&f)
								)
							)
						)
					0x03: (
						-- need to examine other samples
						)
					0x04: ( -- Mesh Info
						if addrs[i].count > 0 do (
							mshArray[addrs[i].count] = fmtTMB_Entry_0x04()
							for j = 1 to addrs[i].count do (
								mshArray[j] = fmtTMB_Entry_0x04()
								mshArray[j].read(&f)
								--mshArray[j].repr()
								)
							)
						)
					0x05: ( -- Vertex Positions, hm maybe this used for lookup
						if addrs[i].count > 0 do (
							vertArray[addrs[i].count] = fmtTMB_Entry_0x05()
							for j = 1 to addrs[i].count do (
								vertArray[j] = fmtTMB_Entry_0x05()
								vertArray[j].read(&f)
								)	
							)
						
						
						)
					0x06: ( -- Vertices Again
						
						local count = (addrs[i].count / 16) as integer
						if addrs[i].count > 0 do (
							unk0190Array[count] = fmtTMB_Entry_0x06()
							for j = 1 to count do (
								unk0190Array[j] = fmtTMB_Entry_0x06()
								unk0190Array[j].read(&f)
								)
							)
						)
					0x07: ( -- Faces
						
						flagArray = #()
						local count = addrs[i].count
						if count > 0 do (
							flagArray[count] = 0
							for j = 1 to count do (
								flagArray[j] = readbyte f #unsigned
								)
							
							)
						
						)
					0x08: ( -- Normals Again
						local count = (addrs[i].count / 16) as integer
						if addrs[i].count > 0 do (
							unk0193Array[count] = fmtTMB_Entry_0x08()
							for j = 1 to count do (
								unk0193Array[j] = fmtTMB_Entry_0x08()
								unk0193Array[j].read(&f)
								)
							)
						)
					0x09: ( -- texture corrdinates maybe??
						local count = (addrs[i].count / 4) as integer
						if addrs[i].count > 0 do (
							unk0195Array[count] = [0.0, 0.0, 0.0]
							for j = 1 to count do (
								unk0195Array[j] = [readShort f #unsigned, readShort f #unsigned, 0.0] / 1024.0
								)
							)
						)
					0x0A: (
						-- not present in my sample, need to review more samples
						)
					0x0B: ( -- some sort of data stream
						--fmtTMB_Entry_0x0B()
						)
					0x0C: (
						-- need to examine more samples, not alot data is present at this block
						)
					)
				)
			),
		
		fn build clearScene:false mscale:3.937007874015748031496 buildBones:false = (
			
			-- ClearScene
			if clearScene do (delete $*)
			
			
			-- Loop Through object
			local o = undefined
			local t = matrix3 1
			local d = undefined
			local msh = undefined
			local bnsArray = #()
			local vertices = #()
			local tvertices = #()
			local faceArray = #()
			local faceStart = 0
			local j = 1
			local v = 1
			local uvStart = 0
			
			for j = 1 to mshArray.count do (
				-- Mesh
				
				vertices = #()
				faceArray = #()
				
				-- if no vertices, then SKIP
				if mshArray[j].unk0168 == 0 do continue
				
				-- Read Faces
				faceArray = readFaces faceStart mshArray[j].unk0168
				faceStart += (mshArray[j].unk0168 + (mod (16-(mod mshArray[j].unk0168 16)) 16))
				
				
				-- Read Vertices
				vertices = #()
				tvertices = #()
				vertices[mshArray[j].unk0168] = [0.0, 0.0, 0.0]
				tvertices[mshArray[j].unk0168] = [0.0, 0.0, 0.0]
				
				for v = (mshArray[j].unk0171 + 1) to (mshArray[j].unk0171 + mshArray[j].unk0168) do (
					vertices[v - mshArray[j].unk0171] = [unk0190Array[v].unk0191[1], -unk0190Array[v].unk0191[3], unk0190Array[v].unk0191[2]] * mscale
					)
				
				
				for v = 1 to mshArray[j].unk0168 do (
					tvertices[v] = try([unk0195Array[v + uvStart][1], unk0195Array[v + uvStart][2], 0.0])catch([0.0, 0.0, 0.0])
					)
					
					
				uvStart += (((mshArray[j].unk0168 * 4) + (mod (16-(mod (mshArray[j].unk0168 * 4) 16)) 16)) / 4.0) as integer
				
				
				-- Build Mesh
				msh = mesh vertices:vertices faces:faceArray tverts:tvertices
				buildTVFaces msh
				for v = 1 to faceArray.count do (setTVFace msh v faceArray[v])
				
				msh.backfacecull = on
				msh.displayByLayer = false
				msh.wirecolor = random (color 0 0 0) (color 255 255 255)
				for v = 1 to faceArray.count do setFaceSmoothGroup msh v 1
				
				--msh.transform = t
				--append mdls msh
				)
			
			
			
			if buildBones do (
				-- Build Bones
				for o in objArray do (
					
					-- Bone
					d = Dummy name:o.name3 boxSize:[0.25, 0.25, 0.25] transform:(
						matrix3 \
							([o.unk131[1][1], o.unk131[1][2], o.unk131[1][3]] + o.unk131[1][4]) \
							([o.unk131[2][1], o.unk131[2][2], o.unk131[2][3]] + o.unk131[2][4]) \
							([o.unk131[3][1], o.unk131[3][2], o.unk131[3][3]] + o.unk131[3][4]) \
							([o.unk131[4][1], o.unk131[4][2], o.unk131[4][3]] * mscale * o.unk131[4][4])
						)
					d.showLinks = d.showLinksOnly = true
					append bnsArray d
					)
				
				local i = 1
				local par = 1
				local pos = [0.0, 0.0, 0.0]
				for i = 1 to bnsArray.count do (
					
					
					par = objArray[i].unk0166 + 1
					if par > 0 do (
						t = bnsArray[i].transform
						pos = bnsArray[i].position
						while par > 0 do (
							t *= bnsArray[par].transform 
							pos += bnsArray[par].position
							
							
							par = objArray[par].unk0166 + 1
							exit
							)
						bnsArray[i].transform = t
						--bnsArray[i].position = pos
						
						bnsArray[i].parent = bnsArray[objArray[i].unk0166 + 1] 
						)
					
					
					
					)
				)
			

			)
		
		)
	
	struct fmtP2IG (
		/*uint32_t*/       	type = 0x47493250, -- P2IG
		/*uint32_t*/       	unk001 = 0,
		/*uint32_t*/       	unk002 = 0,
		/*uint16_t*/       	unk003 = 0,
		/*uint16_t*/       	unk004 = 0,
		/*char[8]*/       	name = "",
		/*uint32_t*/       	unk005 = 0,
		/*uint32_t*/       	unk006 = 0,
		/*uint16_t*/       	unk007 = 0, -- width
		/*uint16_t*/       	unk008 = 0, -- length
		/*uint32_t*/       	unk009 = 0, -- type 0x13 = 8bit, 0x14 = 4bit?
		/*uint32_t*/       	unk010 = 0,
		/*uint32_t*/       	unk011 = 0,
		/*uint32_t*/       	unk012 = 0,
		/*uint32_t*/       	unk013 = 0,
		/*uint32_t*/       	unk014 = 0,
		/*uint32_t*/       	unk015 = 0,
		/*uint32_t*/       	unk016 = 0, -- pal pos
		/*uint32_t*/       	unk017 = 0, -- pal size
		/*uint32_t*/       	unk018 = 0, -- img pos
		/*uint32_t*/       	unk019 = 0, -- img size
		/*uint32_t*/       	unk020 = 0,
		/*uint32_t*/       	unk021 = 0,
		/*uint32_t*/       	unk022 = 0,
		/*uint32_t*/       	unk023 = 0,
		/*uint32_t*/       	unk024 = 0,
		/*uint32_t*/       	unk025 = 0,
		/*uint32_t*/       	unk026 = 0,
		/*uint32_t*/       	unk027 = 0,
		/*uint32_t*/       	unk028 = 0,
		/*uint32_t*/       	unk029 = 0,
		/*uint32_t*/       	unk030 = 0,
		/*uint32_t*/       	unk031 = 0,
		/*uint8_t[4][]*/   	pal = #(),
		/*uint8_t[]*/    	img = #(),
		
		/*
			ps2 unswizzle code courtesy of TopazTK,
			while I was working on soul calibur 3
			
			https://forum.xentax.com/viewtopic.php?t=22497
		*/
		
		fn BoolSwitch input = (
			if Input == 0 then (
				input+=1
				)
			else if input == 1 do (
				input-=1
				)
			),
		
		fn QImage_IMGD_Parse8 &data &colors width height = (
			local i = 1, x = 1, y = 1, OutputIMG = #(), pixel = 1
			local i = 1, index = 0, remainder = 0, indexes = #()
			
			indexes[data.count] = 0
			for i = 1 to data.count do (
				index = data[i]
				
				remainder = mod index 32
				
				if remainder > 7 and remainder < 16 then (
					indexes[i] = (index + 8)
					)
				else if remainder > 15 and remainder < 24 then (
					indexes[i] = (Index - 8)
					)
				else (
					indexes[i] = index
					)
				)
			
			OutputIMG[width * height] = white
			
			for y = 1 to height do (
				for x = 1 to width do (
					i = indexes[pixel] + 1
					OutputIMG[pixel] = colors[i]
					pixel+=1
					)
				)
			
			OutputIMG
			),
		
		fn QImage_IMGD_Decode8 &pixels &Width =  (
			local PixelList = #()
			
			local TrueX = 0
			local TrueY = 0
			
			local BoolY = 0
			local BoolPixel = 0
			local p = 0, x = 0, y = 0
			
			local TruePixel = 0
			local cp = 0, a = 0
			
			PixelList[pixels.count] = white
			for p = 1 to pixels.count do (PixelList[p] = white)
			
			for p = 0 to (pixels.count - 1) do (
				if p != 0 do (
					if (mod p (Width * 2)) == 0 then (
						case BoolY of (
							0: (
								TrueY += 1
								)
							1: (
								TrueY += 3
								BoolPixel = BoolSwitch(BoolPixel)
								)
							)
						
						TrueX = 0
						BoolY = BoolSwitch(BoolY)
						)
					else if (mod p 32) == 0 do (
						TrueX += 16
						)
					)
				
				x = TrueX
				y = TrueY
				
				TruePixel = mod p 16
				cp = mod (p / 16) 2
				
				if BoolPixel == 1 do (
					cp = BoolSwitch(cp)
					)
				
				case cp of (
					0: (
						x = TrueX + ((mod TruePixel 4) * 4) + (TruePixel / 4)
						)
					1: (
						a = 4
						if (mod TruePixel 4) >= 2 do (
							a = 12
							)
						x = TrueX + (a - ((mod TruePixel 2) * 4)) + (TruePixel / 4)
						)
					)
				
				if mod p 2 == 1 do (
					y = TrueY + 2
					)
				PixelList[(y * Width) + x + 1] = pixels[p + 1]
				)
			PixelList
			),
		
		fn readFixedString &f len = (
			str = ""
			local p = ftell f + len
			local i = 1
			local b = 1
			for i = 1 to len do (
				b = readByte f #unsigned
				if b > 0 then (
					str += bit.IntAsChar b
					)
				else (
					exit
					)
				)
			fseek f p #seek_set
			str
			),
		
		fn read &f = (
			
			type = readLong f #unsigned
			unk001 = readLong f #unsigned
			unk002 = readLong f #unsigned
			unk003 = readShort f #unsigned
			unk004 = readShort f #unsigned
			name = readFixedString &f 8
			unk005 = readLong f #unsigned
			unk006 = readLong f #unsigned
			unk007 = readShort f #unsigned
			unk008 = readShort f #unsigned
			unk009 = readLong f #unsigned
			unk010 = readLong f #unsigned
			unk011 = readLong f #unsigned
			unk012 = readLong f #unsigned
			unk013 = readLong f #unsigned
			unk014 = readLong f #unsigned
			unk015 = readLong f #unsigned
			unk016 = readLong f #unsigned
			unk017 = readLong f #unsigned
			unk018 = readLong f #unsigned
			unk019 = readLong f #unsigned
			unk020 = readLong f #unsigned
			unk021 = readLong f #unsigned
			unk022 = readLong f #unsigned
			unk023 = readLong f #unsigned
			unk024 = readLong f #unsigned
			unk025 = readLong f #unsigned
			unk026 = readLong f #unsigned
			unk027 = readLong f #unsigned
			unk028 = readLong f #unsigned
			unk029 = readLong f #unsigned
			unk030 = readLong f #unsigned
			unk031 = readLong f #unsigned
			
			-- Read Image Data
			local i = 1
			local count = unk017 / 4
			img = #()
			pal = #()
			if count > 0 do (
				fseek f unk016 #seek_set
				pal[count] = color 0 0 0 255
				for i = 1 to count do (
					pal[i] = color (readByte f #unsigned) (readByte f #unsigned) (readByte f #unsigned) (readByte f #unsigned)
					)
				fseek f unk018 #seek_set
				if unk019 > 0 do (
					img[unk019] = 0
					for i = 1 to unk019 do (
						img[i] = readByte f #unsigned
						)
					)
				)
			
			),
		
		fn correctGamma &c gamma:2.2 = (
			local p = color \
				((pow (c.red / 255) gamma) * 255) \
				((pow (c.green / 255) gamma) * 255) \
				((pow (c.blue / 255) gamma) * 255) \
				((pow (c.a / 255) gamma) * 255)
			p
			),
		
		fn build = (
			
			local width = unk007
			local height = unk008
			
			local b = bitmap width height color:white
			
			if width > 0 and img.count > 0 do (
				local p = #()
				local c = #()
				local x = 0
				local y = 0
				local i = 0
				
				
				c = QImage_IMGD_Parse8 img pal width height
				
				c = QImage_IMGD_Decode8 c width
				
				p[width] = color 0 0 0 255
				
				
				for y = 1 to height do (
					
					
					for x = 1 to width do (
						
						
						p[x] = correctGamma c[i+=1]
						)
					setPixels b [0, y - 1] p
					
					)
				
				
				)
			
			
			display b
			
			)
		
		)
	
	struct fmtMDL_Asset (
		/*
			this is just an intermediate between the different assets
		*/
		
		/*uint32_t*/   	type = 0,
		/*fmtTMB*/     	model = undefined,
		/*fmtP2IG*/ 	texture = undefined,
		
		fn read &f &fsize = (
			
			/*
				I include the asset size in the param 'fsize'
				as a precaution since the mdl acts as a file
				container.
			*/
			
			local pos = ftell f -- log current cursor position
			
			type = readLong f #unsigned
			fseek f pos #seek_set -- restore cursor position to start of asset
			
			case type of (
				0x20424D54: ( -- TMB (Model)
					model = fmtTMB()
					model.read(&f)
					model.build()
					)
				0x47493250: ( -- P2IG (Texture)
					texture = fmtP2IG()
					texture.read(&f) -- has paring issue
					--texture.build() -- code from sc3 still needs to be adopted
					)
				default: (
					format "Assest Unsupported {0x%}\n" (bit.IntAsHex(type as integer))
					)
				)
			)
		
		)
		
	struct fmtMDL (
		
		/*uint32_t[]*/         	addrs = #(), -- address table is padded to 16bytes
		/*fmtMDL_Asset[]*/  	asset = #(), -- being ps2 assets are probably padded to 16 as well
		
		fn read &f = (
			
			-- Reset Arrays
			addrs = #()
			asset = #()
			
			-- Get File Size
			local pos = ftell f
			fseek f 0 #seek_end
			local fsize = ftell f
			fseek f pos #seek_set
			
			-- Read Address Table
			local addr = 0
			local eariest_addr = fsize
			while ftell f < eariest_addr do (
				
				-- Read Address
				addr = readLong f #unsigned
				
				-- Exit if addr is 0
				if addr == 0 do exit
				
				-- Log Address
				append addrs addr
				
				-- Log addr if its smaller then last addr
				if addr < eariest_addr do (
					eariest_addr = addr
					)
				
				)
			
			-- Get asset count from number of valid addresses
			local count = addrs.count
			if count > 0 do (
				local i = 1
				
				-- Generate a list of unique address, so calculate blocks sizes
				local index = 0
				local sizes = #(fsize) -- include the full size to start
				for i = 1 to count do (
					-- Search sizes array for the address
					index = findItem sizes addrs[i]
					
					-- Not in sizes array, so append address to it.
					if index == 0 do (
						append sizes addrs[i]
						)
					)
				
				-- Sort sizes Array
				sort sizes
				
				-- Dimension Asset Array
				asset[count] = fmtMDL_Asset()
				
				-- Process Each Asset
				for i = 1 to count do (
					
					-- Search for ordered address in the sizes array
					index = (findItem sizes addrs[i]) + 1 -- index up to the next address
					
					--  Initialize Array Element
					asset[i] = fmtMDL_Asset()
					
					-- Read Asset
					fseek f addrs[i] #seek_set -- set cursor at start of asset
					asset[i].read &f sizes[index] -- sizes[index] specifies the length of the asset
					)
				)
			)
		)
	
	button btn_open "Import"
	checkbox chk_batch "batch"
	checkbox chk_clear "clear scene"
	group "about" (
		label lbl_about "by mariokart64n"
		label lbl_date "Released: Dec 9 2022"
		)
	
	
	fn read file = (
		if file != undefined and file != "" do (
			
			local f = try(fopen file "rb")catch(undefined)
			if f != undefined then (
				
				local pos = ftell f
				
				local filetype = readLong f #unsigned
				fseek f pos #seek_set
				case filetype of (
					0x20424D54: ( -- TMB
						format "TMB File\n"
						tmb = fmtTMB()
						tmb.read(&f)
						with undo off with redraw off tmb.build()
						)
					default: ( -- Try MDL
						format "MDL File\n"
						mdl = fmtMDL()
						with undo off with redraw off mdl.read(&f)
						)
					)
				
				fclose f
				) else (format "Failed to open file {%}\n" file)
			)
		)
	
	
	fn batch folder = (
		if folder != undefined and folder != "" do (
			
			if folder.count > 0 and subString folder folder.count 1 != "\\" do (
				folder += "\\"
				)
			
			local files = getFiles (folder + "*.*")
			local file = ""
			for file in files do (
				
				if matchPattern file pattern:"*.tmb" then (
					read(file)
					)
				else if matchPattern file pattern:"*.mdl" then (
					read(file)
					
					)
				
				)
			)
		)
	
	on btn_open pressed do (
		if chk_clear.checked do (delete $*)
		if chk_batch.checked then (
			batch(getSavePath())
			)
		else (
			read(getOpenFileName caption:"Open A File:" types:"King of Route 66 mdl (*.mdl)|*.mdl;*.tmb|All|*.*|")
			)
		
		)
	
	)

createDialog iu_king_of_route_66_mdl