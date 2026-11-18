import bpy, math, os
from mathutils import Vector

# Original project-authored underbone motorcycle baseline.
# Not an OEM-verified Honda Wave Alpha replica; geometry needs visual review.
OUT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "assets", "vehicles", "motorbikes", "honda_wave_alpha_110.glb"))
os.makedirs(os.path.dirname(OUT), exist_ok=True)
bpy.ops.object.select_all(action="SELECT"); bpy.ops.object.delete(use_global=False)

def mat(name, color, rough=.45, metal=0.0):
    m=bpy.data.materials.new(name); m.diffuse_color=(*color,1); m.use_nodes=True
    p=m.node_tree.nodes.get("Principled BSDF")
    p.inputs["Base Color"].default_value=(*color,1); p.inputs["Roughness"].default_value=rough; p.inputs["Metallic"].default_value=metal
    return m

paint=mat("Deep_Red_Metallic_Paint",(.42,.018,.025),.28,.55)
paint2=mat("Dark_Red_Panel",(.18,.012,.018),.3,.48)
black=mat("Textured_Black_Plastic",(.018,.022,.025),.68)
rubber=mat("Tire_Rubber",(.012,.014,.016),.9)
metal=mat("Brushed_Steel",(.32,.36,.39),.28,.82)
chrome=mat("Chrome",(.72,.75,.77),.18,.92)
seatmat=mat("Seat_Vinyl",(.025,.027,.03),.82)
glass=mat("Headlamp_Glass",(.78,.86,.92),.18,.1)
redlens=mat("Tail_Lamp_Red",(.65,.012,.018),.2,.05)
amber=mat("Indicator_Amber",(1,.25,.018),.24,.05)
dial=mat("Instrument_Dial",(.82,.83,.78),.5)
darkglass=mat("Instrument_Glass",(.012,.022,.028),.15,.15)

def smooth(o):
    if o.type=="MESH":
        for p in o.data.polygons: p.use_smooth=True
    return o

def uv(name, loc, scale, material, seg=32, rings=20):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=seg, ring_count=rings, location=loc)
    o=bpy.context.object; o.name=name; o.scale=scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    o.data.materials.append(material); return smooth(o)

def cube(name, loc, dims, material, bevel=.035):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc)
    o=bpy.context.object; o.name=name; o.dimensions=dims
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True); o.data.materials.append(material)
    if bevel:
        b=o.modifiers.new("Manufactured_Rounded_Edges","BEVEL"); b.width=bevel; b.segments=3
        o.modifiers.new("Weighted_Normals","WEIGHTED_NORMAL")
    return o

def cyl(name, loc, radius, depth, material, axis="Z", verts=32):
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=radius, depth=depth, location=loc)
    o=bpy.context.object; o.name=name
    if axis=="X": o.rotation_euler[1]=math.pi/2
    elif axis=="Y": o.rotation_euler[0]=math.pi/2
    o.data.materials.append(material); return smooth(o)

def rod(name, a, b, radius, material, verts=16):
    a,b=Vector(a),Vector(b); d=b-a
    o=cyl(name,(a+b)*.5,radius,d.length,material,verts=verts)
    o.rotation_mode="QUATERNION"; o.rotation_quaternion=d.to_track_quat("Z","Y")
    return o

def torus(name, loc, major, minor, material):
    bpy.ops.mesh.primitive_torus_add(major_radius=major, minor_radius=minor, major_segments=64, minor_segments=12, location=loc, rotation=(0,math.pi/2,0))
    o=bpy.context.object; o.name=name; o.data.materials.append(material); return smooth(o)

def empty(name, loc):
    o=bpy.data.objects.new(name,None); bpy.context.collection.objects.link(o); o.location=loc
    o.empty_display_type="PLAIN_AXES"; o.empty_display_size=.12
    return o

def keep_parent(obj, parent):
    world=obj.matrix_world.copy(); obj.parent=parent; obj.matrix_world=world

front_y=-.94; rear_y=.91; axle_z=.365; wheel_r=.34

# Front and rear wheel assemblies, with tyre, rim, hub, spokes and brake hardware.
for label, y in (("Front",front_y),("Rear",rear_y)):
    pivot=empty(label+"_Wheel", (0,y,axle_z))
    tire=torus(label+"_Wheel_Tire", (0,y,axle_z), wheel_r-.055, .055, rubber); keep_parent(tire,pivot)
    rim=torus(label+"_Wheel_Rim", (0,y,axle_z), wheel_r-.105, .018, chrome); keep_parent(rim,pivot)
    hub=cyl(label+"_Wheel_Hub",(0,y,axle_z),.075,.19,metal,"X"); keep_parent(hub,pivot)
    for side in (-1,1):
        sx=side*.075
        for i in range(12):
            a=2*math.pi*i/12
            p1=(sx,y+math.cos(a)*.075,axle_z+math.sin(a)*.075)
            p2=(side*.045,y+math.cos(a)*(.34-.075),axle_z+math.sin(a)*(.34-.075))
            sp=rod(label+"_Spoke_"+str(side)+"_"+str(i),p1,p2,.006,chrome); keep_parent(sp,pivot)
    if label=="Front":
        disc=cyl("Front_Brake_Disc",(0,y,axle_z),.22,.012,chrome,"X"); keep_parent(disc,pivot)
        for i in range(8):
            a=2*math.pi*i/8
            hole=cyl("Front_Brake_Disc_Perforation",(0,y+math.cos(a)*.18,axle_z+math.sin(a)*.18),.012,.016,black,"X",12); keep_parent(hole,pivot)
        cal=cube("Front_Brake_Caliper",(.11,y-.02,axle_z+.10),(.07,.15,.18),black); keep_parent(cal,pivot)
    else:
        drum=cyl("Rear_Brake_Drum",(0,y,axle_z),.18,.16,metal,"X"); keep_parent(drum,pivot)

# Frame and underbone chassis.
cube("Main_Frame_Backbone",(0,.02,.77),(.075,1.22,.09),metal,.025)
rod("Front_Frame_Downtube",(0,-.30,.80),(0,-.70,.42),.045,metal)
rod("Rear_Frame_Rail_L",(-.11,.20,.72),(-.12,.86,.56),.035,metal)
rod("Rear_Frame_Rail_R",(.11,.20,.72),(.12,.86,.56),.035,metal)
cube("Footboard_Center",(0,-.02,.52),(.43,.62,.07),black,.045)
cube("Left_Footrest",(-.25,.02,.48),(.13,.30,.045),rubber,.02)
cube("Right_Footrest",(.25,.02,.48),(.13,.30,.045),rubber,.02)

# Engine block, cooling fins, crankcase, covers and gear lever.
uv("Engine_Crankcase",(0,.20,.52),(.25,.34,.22),metal)
cube("Engine_Cylinder_Block",(0,-.01,.70),(.26,.28,.25),metal,.045)
for z in (.62,.67,.72,.77):
    cube("Engine_Cooling_Fin_"+str(z),(0,-.015,z),(.31,.30,.018),chrome,.008)
uv("Left_Engine_Cover",(-.145,.23,.51),(.035,.20,.16),chrome)
uv("Right_Engine_Cover",(.145,.23,.51),(.035,.20,.16),metal)
rod("Gear_Shift_Lever",(-.20,.02,.42),(-.32,-.02,.42),.014,chrome)
rod("Kick_Start_Lever",(.18,.30,.48),(.28,.44,.44),.018,chrome)

# Fuel tank / step-through centre spine and side body panels.
uv("Fuel_Tank_Cover",(0,.02,.91),(.22,.33,.17),paint,40,24)
cube("Left_Side_Cover",(-.205,.43,.78),(.10,.48,.23),paint,.07)
cube("Right_Side_Cover",(.205,.43,.78),(.10,.48,.23),paint,.07)
cube("Left_Lower_Side_Cover",(-.18,.18,.62),(.08,.30,.12),paint2,.035)
cube("Right_Lower_Side_Cover",(.18,.18,.62),(.08,.30,.12),paint2,.035)
uv("Front_Leg_Shield",(0,-.43,.91),(.29,.16,.40),paint,40,28)
uv("Front_Leg_Shield_Inner",(0,-.34,.82),(.22,.09,.28),black)
uv("Front_Fender",(0,-.93,.68),(.22,.42,.075),paint,40,20)
uv("Rear_Fender",(0,.92,.62),(.20,.37,.06),black,32,16)

# Seat and rear grab rail.
uv("Seat_Upholstery",(0,.48,1.02),(.235,.56,.105),seatmat,48,24)
uv("Seat_Front_Pad",(0,.12,1.02),(.21,.22,.08),seatmat)
rod("Rear_Grab_Rail_L",(-.20,.36,.91),(-.22,.91,.87),.018,chrome)
rod("Rear_Grab_Rail_R",(.20,.36,.91),(.22,.91,.87),.018,chrome)
rod("Rear_Grab_Rail_Crossbar",(-.22,.91,.87),(.22,.91,.87),.018,chrome)

# Front fork, rear shocks and swingarm.
steer=empty("Steering_Pivot",(0,-.72,.94))
for side in (-1,1):
    x=side*.105
    fork=rod("Front_Suspension_Fork_"+str(side),(x,-.91,.40),(x,-.68,1.12),.035,chrome); keep_parent(fork,steer)
    boot=uv("Front_Fork_Boot_"+str(side),(x,-.86,.58),(.052,.07,.16),black); keep_parent(boot,steer)
    shock=rod("Rear_Suspension_Shock_"+str(side),(x,.84,.53),(x,.56,.91),.032,chrome)
    spring=rod("Rear_Shock_Spring_"+str(side),(x,.82,.55),(x,.58,.88),.012,metal)
    rod("Rear_Shock_Mount_"+str(side),(x,.84,.53),(x,.56,.91),.047,black)
rod("Rear_Swingarm_L",(-.13,.80,.52),(-.13,.26,.48),.035,metal)
rod("Rear_Swingarm_R",(.13,.80,.52),(.13,.26,.48),.035,metal)

# Handlebar, grips, controls and instrument cluster.
rod("Handlebar_Crossbar",(-.43,-.73,1.19),(.43,-.73,1.19),.025,chrome)
for side in (-1,1):
    x=side*.40
    uv("Handlebar_Grip_"+str(side),(x,-.73,1.19),(.075,.06,.045),black)
    cyl("Handlebar_BarEnd_"+str(side),(x+side*.055,-.73,1.19),.022,.045,chrome,"X")
    rod("Brake_Lever_"+str(side),(x,-.73,1.20),(x-side*.12,-.78,1.16),.012,chrome)
    mirror_stem=rod("Mirror_Stem_"+str(side),(side*.30,-.72,1.22),(side*.42,-.78,1.53),.012,chrome)
    mirror=uv("Mirror_"+str(side),(side*.44,-.79,1.55),(.095,.035,.065),chrome,24,16)
    mirror.rotation_euler[1]=side*.16
    cube("Mirror_Back_"+str(side),(side*.44,-.79,1.55),(.15,.045,.11),black,.035)
uv("Instrument_Cluster",(0,-.72,1.30),(.19,.13,.10),black)
uv("Instrument_Glass",(0,-.825,1.31),(.15,.025,.067),darkglass)
uv("Instrument_Dial_Face",(0,-.846,1.31),(.12,.012,.052),dial)
for i in range(7):
    a=math.pi*(.15+.7*i/6)
    uv("Instrument_Mark_"+str(i),(.095*math.cos(a),-.858,1.31+.040*math.sin(a)),(.006,.004,.006),black,12,8)

# Front cowl, headlamp lens, indicators and rear lighting.
uv("Headlight_Housing",(0,-.83,1.13),(.22,.12,.16),black,36,24)
uv("Headlight",(0,-.94,1.13),(.16,.035,.105),glass,36,24)
for side in (-1,1):
    uv("Front_Indicator_"+str(side),(side*.23,-.79,1.02),(.055,.06,.035),amber,24,16)
uv("Tail_Light_Housing",(0,1.13,.78),(.13,.08,.09),black)
uv("Tail_Light",(0,1.19,.79),(.09,.025,.055),redlens)
for side in (-1,1):
    uv("Rear_Indicator_"+str(side),(side*.18,1.08,.75),(.045,.055,.035),amber,20,12)

# Exhaust, heat shield and outlet.
rod("Exhaust_Header",(0,.30,.43),(.18,.62,.40),.035,metal)
cyl("Exhaust_Muffler",(.19,.68,.43),.075,.62,chrome,"Y")
cube("Exhaust_Heat_Shield",(.265,.68,.46),(.035,.40,.10),black,.025)
cyl("Exhaust_Outlet",(.19,.99,.43),.048,.05,black,"Y")

# Chain guard, sprocket, brake pedal, stand and number plate.
cube("Chain_Guard",(-.17,.56,.46),(.055,.62,.07),black,.025)
cyl("Rear_Sprocket",(-.15,.91,.365),.12,.025,chrome,"X")
rod("Rear_Brake_Linkage",(.17,.86,.48),(.17,.35,.46),.012,metal)
rod("Side_Stand",(0,.18,.48),(-.12,.42,.12),.018,metal)
cube("Rear_Number_Plate",(0,1.10,.60),(.22,.025,.12),dial,.012)
for side in (-1,1):
    uv("Foot_Pedal_Rubber_"+str(side),(side*.24,-.05,.44),(.07,.11,.035),black)

# Export all meshes and rig pivots; apply bevel modifiers for stable runtime import.
bpy.ops.object.select_all(action="DESELECT")
for o in bpy.context.scene.objects:
    if o.type in {"MESH","EMPTY"}: o.select_set(True)
bpy.context.view_layer.objects.active=bpy.context.scene.objects.get("Steering_Pivot")
bpy.ops.export_scene.gltf(filepath=OUT, export_format="GLB", use_selection=True, export_apply=True, export_materials="EXPORT", export_yup=True)
print("Generated original underbone motorcycle GLB:", OUT)
