/* ÓRDINARE — interactions */
(function(){
  // ---- Nav scroll state ----
  const nav = document.getElementById('nav');
  const onScroll = () => nav.classList.toggle('scrolled', window.scrollY > 40);
  window.addEventListener('scroll', onScroll, {passive:true});
  onScroll();

  // ---- Scroll reveal (IntersectionObserver — fires regardless of which ancestor scrolls) ----
  const reveals = Array.from(document.querySelectorAll('.reveal'));
  if('IntersectionObserver' in window){
    const io = new IntersectionObserver((entries, obs)=>{
      entries.forEach(e=>{ if(e.isIntersecting){ e.target.classList.add('in'); obs.unobserve(e.target); } });
    }, {threshold:0.08, rootMargin:'0px 0px -6% 0px'});
    reveals.forEach(el=>io.observe(el));
  } else {
    reveals.forEach(el=>el.classList.add('in'));
  }
  // safety net: nothing stays permanently hidden if observer never fires in an embedded context
  setTimeout(()=>{ document.querySelectorAll('.reveal:not(.in)').forEach(el=>el.classList.add('in')); }, 2600);

  // ---- Accordion ----
  document.querySelectorAll('.acc-head').forEach(btn=>{
    btn.addEventListener('click', ()=>{
      const item = btn.parentElement;
      const body = item.querySelector('.acc-body');
      const open = item.classList.contains('open');
      // close siblings
      item.parentElement.querySelectorAll('.acc-item').forEach(i=>{
        i.classList.remove('open');
        i.querySelector('.acc-body').style.maxHeight = null;
      });
      if(!open){
        item.classList.add('open');
        body.style.maxHeight = body.scrollHeight + 'px';
      }
    });
  });
  // open the first accordion on load
  const firstOpen = document.querySelector('.acc-item.open .acc-body');
  if(firstOpen){ firstOpen.style.maxHeight = firstOpen.scrollHeight + 'px'; }

  // ---- Testimonials carousel ----
  const track = document.getElementById('ttrack');
  if(track){
    const cards = Array.from(track.children);
    let index = 0;
    const perView = () => {
      const w = window.innerWidth;
      if(w <= 680) return 1;
      if(w <= 1000) return 2;
      return 3;
    };
    const maxIndex = () => Math.max(0, cards.length - perView());
    const go = (i) => {
      index = Math.max(0, Math.min(i, maxIndex()));
      const card = cards[0];
      const gap = 20;
      const step = card.getBoundingClientRect().width + gap;
      track.style.transform = `translateX(${-index*step}px)`;
    };
    document.getElementById('tnext').addEventListener('click', ()=>{
      index = index >= maxIndex() ? 0 : index + 1; go(index);
    });
    document.getElementById('tprev').addEventListener('click', ()=>{
      index = index <= 0 ? maxIndex() : index - 1; go(index);
    });
    window.addEventListener('resize', ()=>go(index));
    go(0);
    // autoplay
    let timer = setInterval(()=>{ index = index >= maxIndex() ? 0 : index+1; go(index); }, 5500);
    track.parentElement.addEventListener('mouseenter', ()=>clearInterval(timer));
  }

  // ---- Mobile burger ----
  const burger = document.getElementById('burger');
  const links = document.querySelector('.nav-links');
  if(burger){
    burger.addEventListener('click', ()=>{
      const open = links.style.display === 'flex';
      if(open){ links.style.display=''; }
      else {
        Object.assign(links.style,{
          display:'flex', position:'absolute', top:'100%', left:0, right:0,
          flexDirection:'column', background:'var(--cream)', padding:'24px var(--pad)',
          gap:'18px', boxShadow:'0 20px 40px -24px rgba(29,26,21,.4)'
        });
      }
    });
    links.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{ links.style.display=''; }));
  }

  // ---- Parallax drift on engagement chips ----
  const chips = document.querySelectorAll('.chip');
  window.addEventListener('scroll', ()=>{
    const y = window.scrollY;
    chips.forEach((c,i)=>{
      const depth = (i+1)*0.04;
      c.style.marginTop = (y*depth*-0.15)+'px';
    });
  }, {passive:true});
})();
