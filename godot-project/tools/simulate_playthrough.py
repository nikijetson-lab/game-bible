#!/usr/bin/env python3
"""Simulate a playthrough of the Hazemoor quest graph.

Loads all quests, walks through the canonical path, auto-completing
objectives in order, making default resolution choices (canonical where specified).
Reports: total steps, quests completed, branches encountered, flags set.
"""

import json, os, sys
from pathlib import Path

ROOT=os.environ.get('HAZEMOOR_ROOT', os.path.join(os.path.dirname(__file__),'..'))
QDIR=os.path.join(ROOT,'data','quests')

CANON_ORDER=[
    "greyford_01_missing_recipient","greyford_side_01_witch_trouble","greyford_side_02_lost_heirloom",
    "hazemoor_01_path_through_swamp","tykhy_shelest_01",
    "sonk_ferry_01_hunger_from_below","sonk_ferry_02_salt_in_book","sonk_ferry_03_ferry_oath",
    "hazemoor_02_ashes_under_chapel","sonk_ferry_04_quota_knife","hazemoor_02_glade_and_mour",
    "valkorn_01_man_from_swamp","valkorn_02_two_truths","valkorn_03_right_price",
    "valkorn_04_messenger_of_rufin","valkorn_05_keeper_of_first_seal",
    "deep_bog_01_voice_from_fog","deep_bog_02_mad_ferry","deep_bog_03_flooded_sanctuary",
    "ep4_01_return_to_valkorn","ep4_02_valkorn_climax","ep4_03_hazemoor_mour_heart",
    "ep4_04_final_resolution","ep4_05_hero_departure",
]

def load_quests():
    qs={}
    for f in sorted(os.listdir(QDIR)):
        if not f.endswith('.json') or f.startswith('_'): continue
        d=json.load(open(os.path.join(QDIR,f),encoding='utf-8'))
        qs[d['id']]=d
    return qs

def step(qid, qdata, world_flags, completed, branch='V'):
    """Simulate completing one quest. Returns (objectives_done, resolution, flags_set)."""
    objs=qdata.get('objectives',[])
    cc=qdata.get('completion_conditions',{})
    required=cc.get('required_objectives',[oid['id'] for oid in objs])
    
    # Auto-complete all required objectives
    resolution=''
    flags=set()
    
    for obj in objs:
        oid=obj.get('id','')
        # Track flags from objectives
        for k in ['sets_flags','set_flags']:
            v=obj.get(k,[])
            if isinstance(v,str): flags.add(v)
            elif isinstance(v,list): flags.update(v)
    
    # Resolution choice
    rc=qdata.get('resolution_choice',{})
    if rc:
        opts=rc.get('options',[])
        # Try canonical first, then 'V', then first
        chosen=None
        for o in opts:
            if o.get('canonical'): 
                chosen=o; break
        if not chosen:
            for o in opts:
                if o.get('id')==branch or o.get('resolution')==branch:
                    chosen=o; break
        if not chosen and opts:
            chosen=opts[0]
        if chosen:
            resolution=chosen.get('id',chosen.get('resolution',''))
            sf=chosen.get('set_flag','')
            if sf: flags.add(sf)
            sv=chosen.get('set_variable','')
            if sv:
                val=chosen.get('value','')
                world_flags[sv]=val
    
    # Mark completed
    completed.add(qid)
    for f in flags:
        world_flags[f]=True
    
    return len(objs), resolution, flags

def run(branch='V'):
    quests=load_quests()
    flags={}
    completed=set()
    total_objs=0
    quests_done=0
    resolutions={}
    
    for qid in CANON_ORDER:
        if qid not in quests: continue
        qdata=quests[qid]
        
        # Check prerequisites
        pr=qdata.get('prerequisites',{})
        if isinstance(pr,dict):
            for preq in pr.get('quests_completed',[]):
                if preq not in completed:
                    continue  # skip — can't start yet
            flag_req=pr.get('flag','')
            if flag_req and not flags.get(flag_req):
                continue
        
        n_obj, res, new_flags = step(qid, qdata, flags, completed, branch)
        total_objs+=n_obj
        quests_done+=1
        if res:
            resolutions[qid]=res
    
    # Critical path stats
    path=[qid for qid in CANON_ORDER if qid in completed]
    return total_objs, quests_done, len(path), resolutions

if __name__=='__main__':
    for branch in ['V','A','B','C']:
        objs, done, path_len, res=run(branch)
        verdicts={k:v for k,v in res.items() if 'verdict' in k or 'keeper' in k}
        print(f"Branch {branch}: {done} quests, {objs} objectives, path={path_len}")
        if verdicts:
            for k,v in verdicts.items():
                print(f"  {k}: {v}")
