
export default function DungeonMap() {
  const BG="#060402",FL="#3a2e1e",OUT="#7a6a40",OUTA="#c8a840";
  const TX="#c8b888",TD="#786a48",GO="#c8a840",GD="#786030";
  const RE="#cc2828",RD="#8b0000",BL="#2a5a9a",BF="#0a1828";

  const Stone = ({x,y,w,h}) => <>
    {Array.from({length:Math.floor(w/20)-1},(_,i)=>
      <line key={`v${i}`} x1={x+(i+1)*20} y1={y} x2={x+(i+1)*20} y2={y+h} stroke="rgba(4,3,1,0.4)" strokeWidth="0.5"/>)}
    {Array.from({length:Math.floor(h/20)-1},(_,i)=>
      <line key={`h${i}`} x1={x} y1={y+(i+1)*20} x2={x+w} y2={y+(i+1)*20} stroke="rgba(4,3,1,0.4)" strokeWidth="0.5"/>)}
  </>;

  const Room = ({x,y,w,h,label="",sub="",id="",active=false}) => <>
    <rect x={x} y={y} width={w} height={h} fill={FL} stroke={active?OUTA:OUT} strokeWidth={active?2.5:1.5}/>
    <Stone x={x} y={y} w={w} h={h}/>
    {id&&<><circle cx={x+13} cy={y+13} r={9} fill={GD} stroke={GO} strokeWidth={1}/>
      <text x={x+13} y={y+17} textAnchor="middle" fill={GO} fontSize={8} fontFamily="serif" fontWeight="bold">{id}</text></>}
    {label&&label.split('\n').map((l,i,a)=>
      <text key={i} x={x+w/2} y={y+h/2+(i-a.length/2+0.5)*14} textAnchor="middle"
        fill={TX} fontSize={9} fontFamily="serif" fontWeight="bold">{l}</text>)}
    {sub&&<text x={x+w/2} y={y+h-7} textAnchor="middle" fill={TD} fontSize={7} fontFamily="serif" fontStyle="italic">{sub}</text>}
  </>;

  const Cor = ({x,y,w,h}) =>
    <rect x={x} y={y} width={w} height={h} fill={FL} stroke={OUT} strokeWidth={1}/>;

  const Trap = ({x,y,label="",type="яма"}) => {
    const c=type==="газ"?"#8b8000":type==="дріт"?"#8b5000":RE;
    return <g>
      <polygon points={`${x},${y-8} ${x+8},${y} ${x},${y+8} ${x-8},${y}`} fill={c} opacity="0.9"/>
      <line x1={x-5} y1={y-5} x2={x+5} y2={y+5} stroke="white" strokeWidth="1.2"/>
      <line x1={x+5} y1={y-5} x2={x-5} y2={y+5} stroke="white" strokeWidth="1.2"/>
      {label&&<text x={x} y={y+18} textAnchor="middle" fill={c} fontSize={6} fontFamily="serif" fontStyle="italic">{label}</text>}
    </g>;
  };

  const Glow = ({cx,cy}) => <>
    {[55,40,28,18].map((r,i)=><circle key={r} cx={cx} cy={cy} r={r} fill={`rgba(180,150,60,${0.05+i*0.04})`}/>)}
    {[40,28,18].map(r=><circle key={r} cx={cx} cy={cy} r={r} fill="none" stroke={`${GD}66`} strokeWidth="0.8" strokeDasharray="3,2"/>)}
    <rect x={cx-8} y={cy-16} width={16} height={30} rx={2} fill="#b8a870" stroke={GO} strokeWidth="1.5"/>
    <rect x={cx-5} y={cy-12} width={10} height={22} rx={2} fill="#d0c890"/>
    {[[10,8],[-12,11],[5,-9]].map(([ox,oy])=><ellipse key={ox} cx={cx+ox} cy={cy+oy} rx={4} ry={2} fill={`${RD}88`}/>)}
    <text x={cx} y={cy+24} textAnchor="middle" fill={GO} fontSize={7} fontFamily="serif" fontWeight="bold">☆ АРТЕФАКТ</text>
  </>;

  const Seal = ({x,y}) => <>
    <rect x={x-3} y={y-20} width={6} height={40} fill={RE}/>
    {[13,8,4].map(r=><circle key={r} cx={x} cy={y} r={r} fill="none" stroke={RE} strokeWidth={1}/>)}
    {Array.from({length:8},(_,i)=>{
      const a=i*Math.PI/4;
      return <line key={i} x1={x+5*Math.cos(a)} y1={y+5*Math.sin(a)} x2={x+13*Math.cos(a)} y2={y+13*Math.sin(a)} stroke={RE} strokeWidth="1.5"/>;
    })}
  </>;

  const RegRoom = ({x,y,w,h}) => {
    const cx=x+w/2,cy=y+h/2;
    return <>
      <rect x={x} y={y} width={w} height={h} fill="#0a0603" stroke="#3a1808" strokeWidth={3}/>
      {[[x+18,y+18],[x+w-18,y+18],[x+18,y+h-18],[x+w-18,y+h-18]].map(([px,py],i)=><g key={i}>
        <circle cx={px} cy={py} r={7} fill="#2a1808" stroke="#4a3020" strokeWidth="1.5"/>
        {Array.from({length:8},(_,s)=>{
          const t=s/8;
          return <circle key={s} cx={px+t*(cx-px)} cy={py+t*(cy-py)} r={2} fill="#3a2810" opacity="0.6"/>;
        })}
      </g>)}
      {[55,40,28,18,10].map(r=><circle key={r} cx={cx} cy={cy} r={r} fill="#040302"/>)}
      <text x={cx} y={cy-7} textAnchor="middle" fill={TD} fontSize={7} fontFamily="serif" fontStyle="italic">не намагайся</text>
      <text x={cx} y={cy+6} textAnchor="middle" fill={TD} fontSize={7} fontFamily="serif" fontStyle="italic">дізнатись що там</text>
      <circle cx={x+13} cy={y+13} r={9} fill={GD} stroke={GO} strokeWidth={1}/>
      <text x={x+13} y={y+17} textAnchor="middle" fill={GO} fontSize={8} fontFamily="serif" fontWeight="bold">3B</text>
      <text x={cx} y={y+h-8} textAnchor="middle" fill={TD} fontSize={8} fontFamily="serif">ПІДВАЛ РЕГУЛЯТОРА</text>
    </>;
  };

  const Divider = ({x}) => <>
    {Array.from({length:55},(_,i)=><rect key={i} x={x} y={i*12} width={2} height={8} fill={OUT} opacity="0.4"/>)}
  </>;

  return (
    <div style={{background:BG,padding:6}}>
      <svg width="1520" height="620" viewBox="0 0 1520 620" style={{maxWidth:'100%',height:'auto',display:'block'}}>

        <rect width="1520" height="620" fill={BG}/>
        {Array.from({length:77},(_,i)=><line key={`v${i}`} x1={i*20} y1={0} x2={i*20} y2={620} stroke="#0e0b08" strokeWidth="0.4"/>)}
        {Array.from({length:32},(_,i)=><line key={`h${i}`} x1={0} y1={i*20} x2={1520} y2={i*20} stroke="#0e0b08" strokeWidth="0.4"/>)}

        {/* ЗАГОЛОВОК */}
        <rect x={510} y={3} width={500} height={28} fill="#0d0b08" stroke={OUT} strokeWidth={1}/>
        <text x={760} y={15} textAnchor="middle" fill={TX} fontSize={12} fontFamily="serif" fontWeight="bold">ЧОРНИЙ АРХІВ — Схема Підземного Комплексу</text>
        <text x={760} y={26} textAnchor="middle" fill={TD} fontSize={7} fontFamily="serif" fontStyle="italic">Мал. невідомий. Знайдено у кишені мертвого дослідника.</text>

        {/* ══ РІВЕНЬ 1 ══ */}
        <text x={185} y={18} textAnchor="middle" fill={TX} fontSize={11} fontFamily="serif" fontWeight="bold">РІВЕНЬ 1: ВХІД</text>

        <Room x={8} y={35} w={82} h={82} id="1A" label={"ПРИХОВАНИЙ\nВХІД"} sub="4×4м"/>
        <line x1={8} y1={35} x2={90} y2={35} stroke={GD} strokeWidth={1.5} strokeDasharray="7,4"/>
        <text x={10} y={31} fill={GD} fontSize={7} fontStyle="italic">← книжкова шафа</text>

        <Cor x={90} y={58} w={32} h={22}/>
        <Room x={122} y={32} w={126} h={115} id="1B" label={"КІМНАТА\nВАРТИ"} sub="6×8м"/>
        <text x={138} y={130} fill={TD} fontSize={8} fontFamily="serif">⛓ манакли</text>

        <Cor x={248} y={58} w={42} h={22}/>
        <Cor x={290} y={18} w={30} h={215}/>
        <text x={305} y={128} textAnchor="middle" fill={TX} fontSize={9} fontFamily="serif" fontWeight="bold">T</text>

        <rect x={290} y={6} width={30} height={12} fill="#120e0a" stroke="#201810" strokeWidth={1}/>
        <line x1={290} y1={6} x2={320} y2={18} stroke="#303020" strokeWidth={1.5}/>
        <line x1={320} y1={6} x2={290} y2={18} stroke="#303020" strokeWidth={1.5}/>
        <text x={305} y={16} textAnchor="middle" fill={TD} fontSize={6}>ТУПИК</text>

        <Trap x={305} y={188} label="T1: яма" type="яма"/>
        <text x={268} y={198} fill={RE} fontSize={7} fontStyle="italic">ЛІВА!</text>

        <Cor x={320} y={62} w={42} h={22}/>
        <Trap x={340} y={73} label="T2" type="дріт"/>
        <Room x={362} y={36} w={105} h={88} label={"ПІДСОБНЕ\nСКЛЕПІННЯ"}/>
        <text x={414} y={112} textAnchor="middle" fill={RE} fontSize={7} fontStyle="italic">порожньо? ні.</text>

        <Cor x={290} y={233} w={30} h={48}/>
        <text x={305} y={294} textAnchor="middle" fill={GO} fontSize={9} fontFamily="serif" fontWeight="bold">▼ Р.2</text>

        <Divider x={480}/>
        <g transform={`rotate(-90,481,310)`}><text x={481} y={310} fill={TD} fontSize={8} fontFamily="serif">Р.1 → Р.2</text></g>

        {/* ══ РІВЕНЬ 2 ══ */}
        <text x={750} y={18} textAnchor="middle" fill={TX} fontSize={11} fontFamily="serif" fontWeight="bold">РІВЕНЬ 2: АРХІВ</text>

        <Room x={498} y={35} w={92} h={66} label={"ВЕСТИ-\nБЮЛЬ"}/>
        <Cor x={528} y={101} w={30} h={46}/>
        <Trap x={543} y={128} label="T3:газ" type="газ"/>
        <text x={500} y={158} fill={RE} fontSize={7} fontStyle="italic">← ЛІВА!</text>

        <Room x={498} y={147} w={418} h={178} id="2A" label={"ВЕЛИКИЙ СХОВОК  8×20м"} sub="стелажі по периметру" active={true}/>
        {Array.from({length:22},(_,i)=><g key={i}>
          <rect x={514+i*16} y={151} width={13} height={7} fill="#302818" stroke="#3a3020" strokeWidth="0.5"/>
          <rect x={514+i*16} y={315} width={13} height={7} fill="#302818" stroke="#3a3020" strokeWidth="0.5"/>
        </g>)}
        <Glow cx={707} cy={248}/>

        {/* таємний хід */}
        {[0,1,2,3].map(i=><rect key={i} x={913} y={224+i*7} width={4} height={5} fill={`${GD}cc`}/>)}
        <text x={908} y={220} textAnchor="end" fill={GD} fontSize={7} fontStyle="italic">{"< таємний хід"}</text>
        <Cor x={916} y={204} w={20} h={82}/>
        <Room x={936} y={155} w={132} h={128} id="2B" label={"КАБІНЕТ\nСЕБАСТЬЯНА"} sub="4×5м"/>
        <Trap x={952} y={178} label="T4" type="дріт"/>
        <text x={954} y={252} fill={TX} fontSize={9}>♦ костюм</text>
        <text x={954} y={266} fill={TD} fontSize={7} fontStyle="italic">🪞 до стіни</text>

        <Cor x={554} y={325} w={30} h={58}/>
        <Trap x={569} y={350} label="T5" type="шип"/>
        <Cor x={606} y={325} w={30} h={58}/>
        <Trap x={621} y={368} label="T6" type="газ"/>
        <text x={584} y={380} textAnchor="middle" fill={RE} fontSize={7} fontStyle="italic">ЛІВА!</text>

        <Room x={518} y={383} w={168} h={98} id="2C" label={"ПОРОЖНЯ\nКІМНАТА"} sub="3×3м"/>
        <rect x={589} y={434} width={28} height={18} fill="#2a1808" stroke="#4a3020" strokeWidth="1.5"/>
        <text x={603} y={454} textAnchor="middle" fill={RE} fontSize={13} fontFamily="serif" fontWeight="bold">???</text>
        <Cor x={621} y={383} w={15} h={62}/>
        <text x={628} y={455} textAnchor="middle" fill={GO} fontSize={9} fontFamily="serif" fontWeight="bold">▼ Р.3</text>

        <Divider x={1060}/>
        <g transform={`rotate(-90,1061,310)`}><text x={1061} y={310} fill={TD} fontSize={8} fontFamily="serif">Р.2 → Р.3</text></g>

        {/* ══ РІВЕНЬ 3 ══ */}
        <text x={1290} y={18} textAnchor="middle" fill={TX} fontSize={11} fontFamily="serif" fontWeight="bold">РІВЕНЬ 3: ГЛИБИНА</text>

        <Cor x={1082} y={28} w={30} h={90}/>

        <rect x={970} y={88} width={112} height={82} fill={BF} stroke={BL} strokeWidth="1.5"/>
        <text x={1026} y={125} textAnchor="middle" fill={BL} fontSize={8} fontFamily="serif" fontWeight="bold">ЗАТОПЛЕНИЙ</text>
        <text x={1026} y={139} textAnchor="middle" fill={BL} fontSize={8} fontFamily="serif" fontWeight="bold">ПРОХІД</text>
        <text x={1026} y={153} textAnchor="middle" fill={`${BL}aa`} fontSize={7} fontStyle="italic">вода 1.5м</text>
        <text x={972} y={182} fill={`${BL}88`} fontSize={7} fontStyle="italic">→ під Хейзмуром</text>

        <Room x={1082} y={118} w={158} h={114} id="3A" label={"ПЕРЕДКІМНАТА\nРЕГУЛЯТОРА"} sub="5×5м"/>
        <Seal x={1240} y={192}/>
        <text x={1250} y={174} fill={RE} fontSize={7} fontWeight="bold">КРИВАВНА</text>
        <text x={1250} y={184} fill={RE} fontSize={7}>ПЕЧАТКА</text>
        <text x={1250} y={198} fill={RE} fontSize={7} fontStyle="italic">тільки кров</text>
        <text x={1250} y={208} fill={RE} fontSize={7} fontStyle="italic">Ключника</text>

        <Cor x={1240} y={168} w={20} h={50}/>
        <RegRoom x={1260} y={88} w={216} h={370}/>

        <Cor x={1476} y={168} w={46} h={30}/>
        <line x1={1522} y1={183} x2={1516} y2={183} stroke={TD} strokeWidth="1.5" strokeDasharray="5,5"/>
        <text x={1476} y={162} fill={TD} fontSize={7} fontStyle="italic">→ невідомо куди</text>
        <text x={1476} y={208} fill={RE} fontSize={7} fontStyle="italic">стіни не природні</text>

        {/* НОТАТКИ */}
        <text x={8} y={578} fill={RE} fontSize={8} fontStyle="italic">"Третій коридор — не ходи. Я ходив. Не ходи."</text>
        <text x={8} y={590} fill={TD} fontSize={7} fontStyle="italic">"Після кровяної печатки компас не працює. Хтось приходив сюди до нас. Давно."</text>

        {/* ЛЕГЕНДА */}
        <rect x={4} y={600} width={560} height={18} fill="#0d0b08" stroke={OUT} strokeWidth={1}/>
        {[["⬥ Пастка/яма",RE],["⬥ Газ","#8b8000"],["--- Таємний хід",GD],
          ["❋ Печатка",RE],["▓ Стелажі",TD],["██ Затоплений",BL],["● Тунель невідомо",TD]
        ].map(([l,c],i)=>
          <text key={i} x={14+i*78} y={612} fill={c} fontSize={7} fontFamily="serif">{l}</text>)}

      </svg>
    </div>
  );
}
