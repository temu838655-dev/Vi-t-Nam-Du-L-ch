import bpy, math, os
from mathutils import Vector

# Original procedural hero asset. All geometry/materials are authored in this project.
OUT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "assets", "characters", "player", "player_hero.glb"))
os.makedirs(os.path.dirname(OUT), exist_ok=True)
bpy.ops.object.select_all(action="SELECT"); bpy.ops.object.delete(use_global=False)
for datablocks in (bpy.data.meshes, bpy.data.curves, bpy.data.materials, bpy.data.armatures, bpy.data.actions):
    pass

def mat(name, color, rough=0.72, metallic=0.0):
    m=bpy.data.materials.new(name); m.diffuse_color=(*color,1); m.use_nodes=True
    p=m.node_tree.nodes.get("Principled BSDF"); p.inputs["Base Color"].default_value=(*color,1)
    p.inputs["Roughness"].default_value=rough; p.inputs["Metallic"].default_value=metallic
    return m
skin=mat("Skin_Warm_Vietnamese_Tan",(0.53,0.31,0.22),.68)
skin_lite=mat("Skin_Highlight",(0.64,0.40,0.30),.7)
hair=mat("Hair_Black_Brown",(0.025,0.018,0.014),.38)
eye_white=mat("Eye_White",(0.82,0.78,0.69),.3)
iris=mat("Iris_Dark_Brown",(0.12,0.055,0.025),.25)
pupil=mat("Pupil",(0.008,0.006,0.004),.18)
brow=mat("Eyebrow",(0.045,0.027,0.018),.7)
lip=mat("Lips",(0.34,0.12,0.10),.55)
mouth=mat("Mouth_Cavity",(0.055,0.012,0.014),.9)
teeth=mat("Teeth",(0.88,0.82,0.68),.25)
shirt=mat("Polo_Deep_Teal",(0.035,0.19,0.20),.82)
shirt_trim=mat("Polo_Trim",(0.72,0.55,0.25),.6, .15)
pants=mat("Trousers_Charcoal",(0.055,0.065,0.075),.88)
shoe=mat("Sneakers",(0.035,0.04,0.045),.8)
sole=mat("Shoe_Sole",(0.20,0.20,0.19),.9)

def uv(name, loc, scale, material, seg=32, rings=20, bone="head"):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=seg, ring_count=rings, location=loc)
    o=bpy.context.object; o.name=name; o.scale=scale; bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    o.data.materials.append(material); o["rig_bone"]=bone
    for f in o.data.polygons: f.use_smooth=True
    return o

def cube(name, loc, scale, material, bevel=.04, bone="spine"):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc); o=bpy.context.object; o.name=name; o.dimensions=scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True); o.data.materials.append(material); o["rig_bone"]=bone
    if bevel:
        mod=o.modifiers.new("Soft tailored edges","BEVEL"); mod.width=bevel; mod.segments=3
        o.modifiers.new("Weighted corner normals","WEIGHTED_NORMAL")
    return o

def curve_obj(name, pts, radius, material, bone="head"):
    c=bpy.data.curves.new(name,"CURVE"); c.dimensions="3D"; c.resolution_u=16; c.bevel_depth=radius; c.bevel_resolution=4
    s=c.splines.new("BEZIER"); s.bezier_points.add(len(pts)-1)
    for b,p in zip(s.bezier_points,pts):
        b.co=p; b.handle_left_type="AUTO"; b.handle_right_type="AUTO"
    o=bpy.data.objects.new(name,c); bpy.context.collection.objects.link(o); o.data.materials.append(material); o["rig_bone"]=bone
    return o

# Body proportions: approximately 1.73 m tall, adult build.
parts=[]
parts += [uv("Torso_Polo_Fitted",(0,0,1.22),(.255,.145,.36),shirt,bone="spine")]
parts += [uv("Chest_Polo",(0,-.005,1.43),(.29,.15,.19),shirt,bone="chest")]
parts += [uv("Pelvis_Trousers",(0,.005,.88),(.235,.14,.20),pants,bone="pelvis")]
# collar, placket and buttons
parts += [curve_obj("Polo_Collar_Left",[(0,-.142,1.54),(-.07,-.151,1.49),(-.11,-.14,1.54)],.018,shirt_trim,"chest")]
parts += [curve_obj("Polo_Collar_Right",[(0,-.142,1.54),(.07,-.151,1.49),(.11,-.14,1.54)],.018,shirt_trim,"chest")]
parts += [cube("Polo_Placket",(0,-.151,1.39),(.035,.012,.22),shirt_trim,.008,"chest")]
for z in (1.46,1.39,1.32): parts.append(uv("Polo_Button",(0,-.162,z),(.009,.005,.009),teeth,16,8,"chest"))
for side in (-1,1):
    s="L" if side<0 else "R"
    parts.append(uv("Shoulder_"+s,(side*.30,0,1.43),(.13,.145,.14),shirt,bone="upper_arm."+s))
    parts.append(uv("UpperArm_"+s,(side*.36,0,1.23),(.095,.105,.25),shirt,bone="upper_arm."+s))
    parts.append(uv("Elbow_"+s,(side*.37,-.002,1.02),(.082,.09,.085),skin,bone="forearm."+s))
    parts.append(uv("Forearm_"+s,(side*.38,-.005,.90),(.075,.082,.17),skin,bone="forearm."+s))
    parts.append(uv("Palm_"+s,(side*.38,-.025,.77),(.075,.045,.09),skin,bone="hand."+s))
    for j in range(4):
        x=side*.38+(j-1.5)*.026
        parts.append(uv("Finger_%s_%d"%(s,j),(x,-.035,.69),(.012,.014,.065),skin,16,10,"hand."+s))
    parts.append(uv("Thumb_"+s,(side*.31,-.045,.75),(.025,.022,.055),skin,16,10,"hand."+s))
    parts.append(uv("Thigh_"+s,(side*.13,.005,.61),(.115,.13,.27),pants,bone="thigh."+s))
    parts.append(uv("Knee_"+s,(side*.13,-.008,.36),(.09,.105,.095),pants,bone="shin."+s))
    parts.append(uv("Shin_"+s,(side*.13,.0,.21),(.075,.09,.18),pants,bone="shin."+s))
    parts.append(uv("Sneaker_"+s,(side*.13,-.055,.075),(.105,.19,.065),shoe,bone="foot."+s))
    parts.append(uv("Sneaker_Sole_"+s,(side*.13,-.055,.035),(.11,.195,.025),sole,bone="foot."+s))
# Neck and head
parts.append(uv("Neck",(0,0,1.61),(.105,.10,.15),skin,bone="neck"))
head=uv("Head_Face_Sculpt",(0,-.012,1.82),(.205,.18,.255),skin,48,32,"head")
# shape keys for future facial performance; geometry remains inspectable and editable.
head.shape_key_add(name="Basis")
for key in ("Smile","Jaw_Open","Blink_Left","Blink_Right","Brow_Raise"):
    sk=head.shape_key_add(name=key)
    for v in sk.data:
        co=v.co
        if key=="Smile" and co.z < -.05 and abs(co.x)>.04: co.y -= .012
        elif key=="Jaw_Open" and co.z < -.08: co.z -= .025
        elif key.startswith("Blink") and .0 < co.z < .10: co.z -= .006
        elif key=="Brow_Raise" and co.z > .12: co.z += .012
parts.append(head)
# Hair cap and shaped fringe
parts.append(uv("Hair_Scalp",(0,.002,1.965),(.212,.184,.125),hair,40,24,"head"))
parts.append(uv("Hair_Fringe",(0,-.145,1.94),(.16,.045,.065),hair,32,16,"head"))
parts.append(uv("Hair_Side_L",(-.185,-.005,1.84),(.045,.13,.15),hair,24,16,"head"))
parts.append(uv("Hair_Side_R",(.185,-.005,1.84),(.045,.13,.15),hair,24,16,"head"))
# ears with outer helix and inner concha
for side in (-1,1):
    s="Left" if side<0 else "Right"
    parts.append(uv("Ear_"+s,(side*.205,-.002,1.82),(.055,.052,.09),skin,28,18,"head"))
    parts.append(uv("Ear_Concha_"+s,(side*.239,-.044,1.825),(.018,.018,.047),skin_lite,20,12,"head"))
# Eyes: sockets, eyeballs, iris, pupils, catchlights, upper/lower lids, brows
for side in (-1,1):
    s="Left" if side<0 else "Right"; x=side*.078
    parts.append(uv("EyeSocket_"+s,(x,-.168,1.855),(.061,.025,.039),skin_lite,28,18,"head"))
    parts.append(uv("Eye_"+s,(x,-.188,1.855),(.047,.025,.027),eye_white,32,20,"head"))
    parts.append(uv("EyeBall_"+s,(x,-.188,1.855),(.047,.025,.027),eye_white,32,20,"head"))
    parts.append(uv("Eye_Iris_"+s,(x,-.210,1.854),(.020,.009,.021),iris,24,16,"head"))
    parts.append(uv("Eye_Pupil_"+s,(x,-.218,1.854),(.010,.006,.013),pupil,20,12,"head"))
    parts.append(uv("Eye_Catchlight_"+s,(x-.006,-.224,1.863),(.004,.003,.005),teeth,12,8,"head"))
    parts.append(curve_obj("Eyelid_Upper_"+s,[(x-.052,-.185,1.856),(x,-.201,1.887),(x+.052,-.185,1.856)],.008,skin,"head"))
    parts.append(curve_obj("Eyelid_Lower_"+s,[(x-.048,-.184,1.85),(x,-.198,1.829),(x+.048,-.184,1.85)],.006,skin_lite,"head"))
    parts.append(curve_obj("Eyebrow_"+s,[(x-.052,-.183,1.902),(x,-.195,1.918),(x+.052,-.183,1.906)],.012,brow,"head"))
# Nose bridge, tip, alae and nostrils
parts.append(uv("Nose_Bridge",(0,-.183,1.80),(.035,.043,.09),skin_lite,32,20,"head"))
parts.append(uv("Nose_Tip",(0,-.218,1.755),(.043,.038,.032),skin,28,18,"head"))
for side in (-1,1):
    parts.append(uv("Nose_Alae_"+("L" if side<0 else "R"),(side*.033,-.208,1.75),(.025,.025,.021),skin_lite,24,14,"head"))
    parts.append(uv("Nostril_"+("L" if side<0 else "R"),(side*.022,-.229,1.739),(.009,.006,.006),mouth,16,8,"head"))
# Mouth cavity, shaped lips, teeth and chin
parts.append(uv("Mouth_Cavity",(0,-.176,1.685),(.060,.018,.027),mouth,32,16,"head"))
parts.append(curve_obj("Upper_Lip", [(-.059,-.195,1.696),(-.026,-.207,1.704),(0,-.211,1.695),(.026,-.207,1.704),(.059,-.195,1.696)],.009,lip))
parts.append(curve_obj("Lower_Lip",[(-.052,-.194,1.681),(0,-.208,1.671),(.052,-.194,1.681)],.010,lip,"jaw"))
parts.append(uv("Upper_Teeth",(0,-.198,1.692),(.040,.009,.010),teeth,24,12,"head"))
parts.append(uv("Lower_Teeth",(0,-.196,1.672),(.034,.008,.008),teeth,24,12,"jaw"))
parts.append(uv("Chin",(0,-.15,1.635),(.085,.055,.045),skin,28,18,"jaw"))
# Armature with deforming body hierarchy.
arm_data=bpy.data.armatures.new("VietnameseHero_Armature"); arm=bpy.data.objects.new("VietnameseHero_Rig",arm_data); bpy.context.collection.objects.link(arm)
bpy.context.view_layer.objects.active=arm; arm.select_set(True); bpy.ops.object.mode_set(mode="EDIT")
bones={
"root":((0,0,0),(0,0,.12),None),
"pelvis":((0,0,.82),(0,0,1.02),"root"),
"spine":((0,0,1.02),(0,0,1.34),"pelvis"),
"chest":((0,0,1.34),(0,0,1.52),"spine"),
"neck":((0,0,1.52),(0,0,1.68),"chest"),
"head":((0,0,1.68),(0,0,1.98),"neck"),
"jaw":((0,0,1.69),(0,-.04,1.62),"head")}
for side in ("L","R"):
    x=-1 if side=="L" else 1
    bones["upper_arm."+side]=((x*.22,0,1.45),(x*.37,0,1.12),"chest")
    bones["forearm."+side]=((x*.37,0,1.12),(x*.38,0,.83),"upper_arm."+side)
    bones["hand."+side]=((x*.38,0,.83),(x*.38,0,.68),"forearm."+side)
    bones["thigh."+side]=((x*.13,0,.88),(x*.13,0,.42),"pelvis")
    bones["shin."+side]=((x*.13,0,.42),(x*.13,0,.12),"thigh."+side)
    bones["foot."+side]=((x*.13,0,.12),(x*.13,-.16,.06),"shin."+side)
edit={}
for name,(a,b,parent) in bones.items():
    eb=arm_data.edit_bones.new(name); eb.head=a; eb.tail=b
    if parent: eb.parent=edit[parent]
    edit[name]=eb
bpy.ops.object.mode_set(mode="OBJECT"); arm.show_in_front=True
# Rigid skinning per authored component, with named bone weights.
for o in parts:
    if o.type!="MESH": continue
    bone=o.get("rig_bone","head")
    if bone not in arm.data.bones: bone="head"
    vg=o.vertex_groups.new(name=bone); vg.add(list(range(len(o.data.vertices))),1.0,"REPLACE")
    mod=o.modifiers.new("Hero_Skeleton","ARMATURE"); mod.object=arm
    o.parent=arm
# Convert facial/clothing curves to meshes and skin them to the intended bone.
for o in list(bpy.context.scene.objects):
    if o.type=="CURVE":
        bone=o.get("rig_bone","head")
        if bone not in arm.data.bones: bone="head"
        bpy.ops.object.select_all(action="DESELECT"); o.select_set(True); bpy.context.view_layer.objects.active=o
        bpy.ops.object.convert(target="MESH")
        o=bpy.context.object
        # Export real eyelid morph targets so blink affects eyelid geometry.
        if o.name.startswith(("Eyelid_Upper_Left", "Eyelid_Lower_Left")):
            blink_name = "Blink_Left"
        elif o.name.startswith(("Eyelid_Upper_Right", "Eyelid_Lower_Right")):
            blink_name = "Blink_Right"
        else:
            blink_name = ""
        if blink_name:
            o.shape_key_add(name="Basis")
            blink = o.shape_key_add(name=blink_name)
            upper = o.name.startswith("Eyelid_Upper_")
            for vertex in blink.data:
                vertex.co.z += -0.022 if upper else 0.014
        elif o.name.startswith(("Upper_Lip", "Lower_Lip")):
            o.shape_key_add(name="Basis")
            smile = o.shape_key_add(name="Smile")
            for vertex in smile.data:
                if abs(vertex.co.x) > 0.012:
                    vertex.co.y -= 0.012
                    vertex.co.z += 0.006
        elif o.name.startswith("Eyebrow_"):
            o.shape_key_add(name="Basis")
            brow_raise = o.shape_key_add(name="Brow_Raise")
            for vertex in brow_raise.data:
                vertex.co.z += 0.012
        vg=o.vertex_groups.new(name=bone); vg.add(list(range(len(o.data.vertices))),1.0,"REPLACE")
        mod=o.modifiers.new("Hero_Skeleton","ARMATURE"); mod.object=arm
        o.parent=arm
# Basic authored animation actions, designed as a starting point for animator polish.
def action(name, frames):
    arm.animation_data_create()
    act=bpy.data.actions.new(name)
    arm.animation_data.action=act
    bpy.context.view_layer.objects.active=arm
    bpy.ops.object.mode_set(mode="POSE")
    for bone_name, keys in frames.items():
        pb=arm.pose.bones.get(bone_name)
        if not pb: continue
        pb.rotation_mode="XYZ"
        for frame,rot in keys:
            pb.rotation_euler=rot
            pb.keyframe_insert(data_path="rotation_euler",frame=frame,group=bone_name)
    bpy.ops.object.mode_set(mode="OBJECT")
    act["clip_type"]=name.lower()
    act.use_fake_user=True
    track=arm.animation_data.nla_tracks.new()
    track.name=name
    track.strips.new(name, 1, act)
    arm.animation_data.action=None
action("Idle",{"spine":[(1,(0,0,0)),(24,(.015,0,0)),(48,(0,0,0))],"head":[(1,(0,0,0)),(24,(0,.015,0)),(48,(0,0,0))]})
action("Walk",{"upper_arm.L":[(1,(.35,0,0)),(13,(-.35,0,0)),(25,(.35,0,0))],"upper_arm.R":[(1,(-.35,0,0)),(13,(.35,0,0)),(25,(-.35,0,0))],"thigh.L":[(1,(-.45,0,0)),(13,(.45,0,0)),(25,(-.45,0,0))],"thigh.R":[(1,(.45,0,0)),(13,(-.45,0,0)),(25,(.45,0,0))]})
action("Run",{"upper_arm.L":[(1,(.7,0,0)),(10,(-.7,0,0)),(19,(.7,0,0))],"upper_arm.R":[(1,(-.7,0,0)),(10,(.7,0,0)),(19,(-.7,0,0))],"thigh.L":[(1,(-.8,0,0)),(10,(.8,0,0)),(19,(-.8,0,0))],"thigh.R":[(1,(.8,0,0)),(10,(-.8,0,0)),(19,(.8,0,0))]})
action("Talk",{"head":[(1,(0,0,0)),(12,(.02,.04,0)),(24,(0,-.025,0)),(36,(0,0,0))],"jaw":[(1,(0,0,0)),(8,(.08,0,0)),(16,(0,0,0)),(24,(.08,0,0)),(36,(0,0,0))]})
# Ensure all relevant objects selected for GLB export.
bpy.ops.object.select_all(action="DESELECT")
for o in bpy.context.scene.objects:
    if o.type in {"MESH","ARMATURE","EMPTY","CURVE"}: o.select_set(True)
bpy.context.view_layer.objects.active=arm
bpy.ops.export_scene.gltf(filepath=OUT,export_format="GLB",use_selection=True,export_apply=True,export_animations=True,export_skins=True,export_morph=True,export_materials="EXPORT",export_yup=True,export_nla_strips=True)
print("Generated original Vietnamese hero GLB:",OUT)
