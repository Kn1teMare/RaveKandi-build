#!/bin/bash
# set -e removed — non-zero exits from pkg/gradle killed the build silently
echo "============================================"
echo " RaveKandi V63.03.04 Build Script Starting"
echo "============================================"
echo "Bash: $BASH_VERSION"
echo "User: $(whoami)"
echo "Home: $HOME"
echo "Date: $(date)"
echo "============================================"

# Block 1
mkdir -p ~/ravekandi-app/public
mkdir -p ~/ravekandi-app/src
mkdir -p ~/.gradle
cd ~/ravekandi-app

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover" />
    <title>RaveKandi V63.03.04</title>
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json">
    <link rel="apple-touch-icon" href="%PUBLIC_URL%/apple-touch-icon.png">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="RaveKandi">
    <meta name="theme-color" content="#0f001e">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
      body { background-color: #0a0014; color: white; margin: 0; padding: 0; -ms-overflow-style: none; }
      /* V63: hide the native page scrollbar app-wide (scrolling still works). The .rk-scroll
         picker boxes opt back IN to a visible bar below. */
      html, body { scrollbar-width: none; }
      html::-webkit-scrollbar, body::-webkit-scrollbar { width: 0; height: 0; display: none; }
      /* V63: lock horizontal scrolling — the page can only scroll up/down, never left/right. */
      html, body { overflow-x: hidden; max-width: 100%; width: 100%; overscroll-behavior-x: none; }
      #root { overflow-x: hidden; max-width: 100%; }
      @keyframes rkMarquee { from { transform: translateX(0); } to { transform: translateX(-50%); } }
      .rk-marquee-track { display: flex; width: max-content; animation: rkMarquee 60s linear infinite; will-change: transform; }
      @keyframes rkGhostFlash { 0%, 100% { opacity: 0.25; } 50% { opacity: 0.95; } }
      @keyframes rkCascade { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
      .rk-radio-on { background: linear-gradient(60deg, #16ff8e, #00c853, #7CFC00, #16ff8e); background-size: 300% 300%; animation: rkCascade 2.2s linear infinite; box-shadow: 0 0 18px rgba(0,255,140,0.8); }
      .rk-radio-off { background: linear-gradient(45deg, #ff1744, #b71c1c); box-shadow: 0 0 16px rgba(255,23,68,0.75); }
      .rk-pastel-shift { background-size: 300% 300%; -webkit-background-clip: text; background-clip: text; animation: rkCascade 5s ease infinite; }
      .rk-msg-icon { background: linear-gradient(60deg, #ffd1f7, #c4f0ff, #d8ffd1, #fff3c4, #ffd1f7); background-size: 300% 300%; animation: rkCascade 4s ease infinite; box-shadow: 0 0 12px rgba(216,180,254,0.6); }
      .rk-msg-icon svg { color: #6b2d8c; }
      /* V42.22 Phase 7: VIP text effects (font selector) */
      .rkfx-pastel { background-image: linear-gradient(90deg,#ffd1f7,#c4f0ff,#d8ffd1,#fff3c4,#ffd1f7); background-size:300% 300%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkCascade 6s ease infinite; }
      .rkfx-metallic { background-image: linear-gradient(180deg,#fafafa 0%,#b0b0b0 45%,#6e6e6e 55%,#dcdcdc 100%); -webkit-background-clip:text; background-clip:text; color:transparent; text-shadow:0 1px 1px rgba(255,255,255,0.25); }
      .rkfx-shimmer { background-image: linear-gradient(90deg,#ff80bf,#ffffff,#80ffff,#ffffff,#ff80bf); background-size:200% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkShimmerMove 3s linear infinite; }
      .rk-shimmer-border { position:relative; border:2px solid transparent; background:linear-gradient(#120024,#120024) padding-box, linear-gradient(90deg,#ff50b4,#a855f7,#22d3ee,#a855f7,#ff50b4) border-box; background-size:300% 100%; animation: rkBorderShimmer 3s linear infinite; }
      @keyframes rkBorderShimmer { 0%{background-position:0 0, 0% 0;} 100%{background-position:0 0, 300% 0;} }
      @keyframes rkShimmerMove { 0%{background-position:0% 0;} 100%{background-position:200% 0;} }
      .rkfx-neon { color:#fff; text-shadow:0 0 4px #fff,0 0 8px var(--rkfx-c,#ff2db3),0 0 16px var(--rkfx-c,#ff2db3),0 0 28px var(--rkfx-c,#ff2db3); }
      .rkfx-gradient { background-image: linear-gradient(90deg,var(--rkfx-c,#ff2db3),var(--rkfx-c2,#2db3ff)); -webkit-background-clip:text; background-clip:text; color:transparent; }
      /* V63: custom-colored animated gradient — flows between the user's two chosen colors */
      .rkfx-flow { background-image: linear-gradient(90deg,var(--rkfx-c,#ff2db3),var(--rkfx-c2,#2db3ff),var(--rkfx-c,#ff2db3)); background-size:300% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkShimmerMove 4s linear infinite; }
      /* V63: custom-colored shimmer — sweeps a white highlight across the two chosen colors */
      .rkfx-shimmer2 { background-image: linear-gradient(90deg,var(--rkfx-c,#ff80bf),#ffffff,var(--rkfx-c2,#80ffff),#ffffff,var(--rkfx-c,#ff80bf)); background-size:200% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkShimmerMove 2.6s linear infinite; }
      /* V63: flowing metallic — animated brushed-metal sheen */
      .rkfx-flowmetal { background-image: linear-gradient(110deg,#e8e8e8 0%,#9a9a9a 25%,#ffffff 45%,#7a7a7a 55%,#cfcfcf 75%,#9a9a9a 100%); background-size:250% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; text-shadow:0 1px 1px rgba(255,255,255,0.2); animation: rkShimmerMove 3.5s linear infinite; }
      /* V63: iridescent — soft oil-slick pearl that drifts */
      .rkfx-iridescent { background-image: linear-gradient(90deg,#a8edea,#fed6e3,#d3a4ff,#a1c4fd,#c2ffd8,#a8edea); background-size:400% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkCascade 7s ease infinite; }
      /* V63: trippy — high-saturation rainbow churn */
      .rkfx-trippy { background-image: linear-gradient(90deg,#ff0080,#ff8c00,#ffee00,#00ff6a,#00d4ff,#9d4edd,#ff0080); background-size:400% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkCascade 3.5s linear infinite; filter:saturate(1.3); }
      /* V63: chromatic — RGB split / glitch aberration */
      .rkfx-chromatic { color:#fff; text-shadow:-2px 0 1px rgba(255,0,90,0.85), 2px 0 1px rgba(0,200,255,0.85), 0 0 6px rgba(255,255,255,0.3); animation: rkChroma 2.4s ease-in-out infinite; }
      @keyframes rkChroma { 0%,100%{text-shadow:-2px 0 1px rgba(255,0,90,0.85),2px 0 1px rgba(0,200,255,0.85),0 0 6px rgba(255,255,255,0.3);} 50%{text-shadow:2px 0 1px rgba(255,0,90,0.85),-2px 0 1px rgba(0,200,255,0.85),0 0 6px rgba(255,255,255,0.3);} }
      /* V63: gold foil — warm shimmering gold */
      .rkfx-gold { background-image: linear-gradient(110deg,#fff3b0,#d4af37,#fff3b0,#b8860b,#ffe9a8); background-size:250% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkShimmerMove 3s linear infinite; }
      /* V63: holographic — bright sweeping holo sticker */
      .rkfx-holo { background-image: linear-gradient(115deg,#ff6ec4,#7873f5,#4ade80,#facc15,#ff6ec4); background-size:300% 100%; -webkit-background-clip:text; background-clip:text; color:transparent; animation: rkShimmerMove 3.2s linear infinite; filter:saturate(1.15); }
      .rk-ghost-flash { animation: rkGhostFlash 1.6s ease-in-out infinite; }
      /* V63: visible scrollbar for picker scroll-boxes so users know they can scroll */
      .rk-scroll { scrollbar-width: thin; scrollbar-color: #ec4899 rgba(255,255,255,0.08); }
      .rk-scroll::-webkit-scrollbar { width: 8px; }
      .rk-scroll::-webkit-scrollbar-track { background: rgba(255,255,255,0.08); border-radius: 8px; }
      .rk-scroll::-webkit-scrollbar-thumb { background: linear-gradient(180deg,#ff50b4,#a855f7); border-radius: 8px; border: 1px solid rgba(0,0,0,0.3); }
    </style>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

cat << 'EOF' > public/manifest.json
{
  "name": "RaveKandi",
  "short_name": "RaveKandi",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#0f001e",
  "theme_color": "#0f001e",
  "icons": [ { "src": "icon-192.png", "sizes": "192x192", "type": "image/png" } ]
}
EOF

# V42.12: app icon for Add-to-Home-Screen / PWA installs (192x192 neon bolt)
base64 -d > public/apple-touch-icon.png << 'B64EOF'
iVBORw0KGgoAAAANSUhEUgAAAMAAAADACAIAAADdvvtQAAAHxElEQVR42u2dvY4bOwxGtUKaVLlAkDZvsECKvN2t83YpAuxjBAHSpU1hYBHY6/GI4s9H8mO3xcIj6viQmpFHTx/G58FgSGMyBQwCxCBADALEIEAMBgFiECAGAWIQIAbjUbxjCsYYv5+/yf7xv5f/m6fuqeGjDDEuRKopQKbENOepLECB0LSCqRpAgNzUJqkIQCm4KUlSeoCSolMGo6wAFeCmBkn5ADJCRzB5OFdCgFwnzHSGUlxkO4D2ZyVkPpJedjWAajxnqPq0BBogWdLBM15sUKAAlUSn5AARAVpNrkpaP778WP2XX89fkg62LEBu2RTgYopUXoyAAFpKoiCDRtAowmSdgcoAnc/dUuKcoVGBySgVZQGyyJdPQ2P6KVkwCgboZJrU0VHpfx0+XT0/pQDSzc7DyTOCZozx8/ufT1/fG10POENhAJ3Jiwo6dty80jPGuAVI9/IU01UBIK10HMyNNTfnAdK6WkyGvAHSEjICOkv0qFw5YDlzBUjlO3RvAjy52QFofyBQKvIDaH/YUOi80iMGaGdQOAw5AWRETxQ6igCJRwfC0CQ9m/SoxJtjOV6+nYHDYed4/G/j06FjFJdBXY338ue98V5SF/v7AvMSdjy8VXpA0PlXP/v1a3/gO0mGLmEl6XGzkVY5M1WUoYHE9ICXravux8JAsjyEeMgKIEV60MTjBpAgIf4MTdITuPhSL2f+tQzoFXedmx7dlsgz9AGS6ScFPbf6sa5fAoacJaTcA6nQAyueQIBWc+XWDE3SA9v9nFFRuIeceqDs9CC3RDKG4AASQJ2IHhD9rDLkIKHpQA9fphwVDoVsRo2hgH78O2jAQqYA0AHIbH3AGdqXUMCNxFz0oHU/6s1QMEAC/dA9pgw5S2g604NzD76AfpYybMTQDBwb9VOgkMkBWtVPOnqO9RO7BJMxZCGhiTBaRt6sCgHa1A+7n6hmSF1Cs8kXhRICMhD1QwmFGYj6KZZhTYAe6icFPWf0g7YEO2BoVULmAJU8Z4khnl81A/XRT7pCZiqhaYono7yEDJto6gdcQkBNdIE9h8XocZu1BYCWzJbu3s/5AF+CqczI+bmeDiBnf25ao4oZSWiGw87AlJAyQOL1F/UDLqHNGd81EH+y07yV1i9h3LTaqorZPkyt9+g04xLMdBZOAVT1BnTDez/qbdCWgdgAsQ1SLmGJHl+00o/dY43J7x+DAFE/wADd66QaNkBJn4LttEEP+2hNA2VpgHrqx6gNYg/E2Ip33Qa8ox91dRWoiTQQOyoCxO4HFiDuoqd+jhkQGuh21Ye/BKN+jhdisvsy7IGoH/ZA1A8Bon4IEPVDAzGoHwJE/RAg6ocAUT80EIP6aQ0Qjn4K70SjgRgEiPohQAwCRP200w8NxCBA1E9oCDfV/37+drX/6Nfzl9c9Sh9ffgTuKdOdtkq3Io83/Zmc1sPXJ1A/xwywB+qiH/ZA1A8BYhAgBvVjBZDP4Qykx2IJZgiQ+MUf7KAThfglPixhLF7sgRhlAOrcBiHrx+6H51sA8dULtRsgNYAaPtBY7aBLdj9n5t22B+K5T2j1K0ETXe98jEr6UZ+dXYDYBnVugBYAErdBGavYUgMErh9x/k/OuEkP1LCK9axfOgA9dCBPcIbVz34HsgDQUhXrIKFcS/elGTk/1zoljK10w/bZsAe6RT5RFTvZQePrx+e9uWsAcY99h1iaZTUDvenDqs9WC+hHq+uYpngyautHuQdqIiHqx6mJlt2ZSNFBZ6HHISQAHVjuoYSoH89Y1Y+gP5nlvyKtwj+3aqf1dJAQ9QNhIEqoUlblAG1KCJCh4w4613NTH/14GwifocL0wBlIIKHBrUJBrY+RfhQMJGAonYQK7Dk0oiemic5byFi8TADaL2QIDN3roLP83tS/eDkZKBFDJd1jvddPB6BjkPPuV8z+e9PjzKtsrFAzkOBqKKHA1kdrW86M/SogM5TiXWOBxUsfIFkhQ2Ao0S4OFXoUdwU+fRifEeruLTeeK9JbgAD1cz5FbvSYlDAVD7ElSkHPgHrFHQ5DaPqJ1XMAQOJVfQhDV/UrNT3O+jHpgfYH8yY0dt85WIBW8+BPjy1Am0Ny8/a/ACHTczz8EHrMe6CdO9Sd2+os9JgbyMJD6ip6NRCCfgTjDaRniE8sVMfr3jgvubtK6+VPFYxwbiGqo5N4FSb4EqyWM/WKFqsfI3ocfofuUcK0BnyPmB0Vhdcv2aBA6HEFSGvYuhhdAAqhRzwQHHq8ATpftsUYrZLkD9DOlWtlLzFAut+hTYyc6dm8WijxBAOkm47jbvpgbnwAEl8ePj2RAKkL+eGi7Haqfn7/Y0eP4HqylC0UgCyyc3Jtb/RURP3TwemJB2is3A1Tx2gTKdNPsUhLTYBM8wXy+GyJzizoYAE0Fm/MC3LnDJNAadYZKA7QWH+4g3aGkLi1cht4cYACs+nTNlVCBxegIX3OnOgd1mUGCApQYYyKDQoaoJ2MoyW9xihSAjQ0dk6FTEPSyy4IkNZ8OMxKiotsCpDuDO1PGM6VECAUjGIj40lIWQGqRFLqE7TSA5QaowKHrxUBKBdJlQ7tqwYQMkklD3ssCxAITOVPCG0BkCdP3c6U7QiQIlI8gpgAMbZiMgUMAsQgQAwCxCBADAYBYhAgBgFitIi/0ysOiu+tnSkAAAAASUVORK5CYII=
B64EOF
cp public/apple-touch-icon.png public/icon-192.png

cat << 'EOF' > src/index.js
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

class ErrorBoundary extends React.Component {
  constructor(props) { super(props); this.state = { hasError: false, error: null, errorInfo: null, errorLogs: [], minimized: true }; }
  componentDidMount() {
    window.addEventListener('error', this.handleGlobalError, true);
    window.addEventListener('unhandledrejection', this.handlePromiseRejection, true);
    try {
      localStorage.removeItem('rk_error_logs');
      this.setState({ errorLogs: [] });
    } catch(e){}
  }
  componentWillUnmount() {
    window.removeEventListener('error', this.handleGlobalError, true);
    window.removeEventListener('unhandledrejection', this.handlePromiseRejection, true);
  }
  logError = (msg) => {
    try {
      const newLogs = [{ time: new Date().toLocaleTimeString(), msg: String(msg) }, ...this.state.errorLogs].slice(0, 50);
      this.setState({ errorLogs: newLogs });
      localStorage.setItem('rk_error_logs', JSON.stringify(newLogs));
    } catch(e) {}
  }
  handleGlobalError = (event) => {
    const m = event.message || (event.target && event.target.tagName ? event.target.tagName.toLowerCase() + ' failed to load: ' + (event.target.src || event.target.href || 'unknown source') : null);
    if (!m || m === 'undefined') return; // V37.14: skip contextless resource events (was logging "Global: undefined")
    this.logError(`Global: ${m}`);
  }
  handlePromiseRejection = (event) => { const r = event.reason; const m = (r && (r.message || (r.toString && r.toString()))) || 'Unhandled rejection (no detail)'; this.logError(`Promise: ${m}`); }
  
  componentDidCatch(error, errorInfo) { 
      this.setState({ hasError: true, error, errorInfo, minimized: false });
      this.logError(`React Crash: ${error.toString()}`);
  }
  clearLogs = () => { 
    try { localStorage.removeItem('rk_error_logs'); } catch(e){} 
    this.setState({errorLogs: []}); 
  }

  render() {
    const { errorLogs, minimized, hasError } = this.state;
    return (
      <>
        {hasError ? null : this.props.children}
        <div style={{ position: 'fixed', bottom: minimized ? '10px' : '0', right: minimized ? '10px' : '0', width: minimized ? 'auto' : '100%', height: minimized ? 'auto' : '100%', backgroundColor: minimized ? '#f87171' : 'rgba(0,0,0,0.95)', color: 'white', zIndex: 99999, padding: minimized ? '8px 12px' : '20px', borderRadius: minimized ? '20px' : '0', display: 'flex', flexDirection: 'column', fontFamily: 'monospace', transition: 'all 0.3s', boxShadow: '0 0 20px rgba(0,0,0,0.8)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: minimized ? '0' : '15px' }}>
            <span style={{ fontWeight: 'bold', fontSize: minimized ? '12px' : '18px', color: minimized ? 'black' : '#f87171', cursor: 'pointer' }} onClick={() => this.setState({ minimized: !minimized })}>
              {minimized ? `🐞 Bugs (${errorLogs.length})` : 'System Diagnostic Log V63.03.04'}
            </span>
            {!minimized && <button onClick={() => this.setState({ minimized: true })} style={{ background: 'none', border: 'none', color: 'white', fontSize: '24px', cursor: 'pointer' }}>×</button>}
          </div>
          {!minimized && (
            <>
              {hasError && <p style={{ marginBottom: '10px', fontWeight: 'bold', color: '#fca5a5' }}>FATAL: {this.state.error?.toString()}</p>}
              <div style={{ flex: 1, overflowY: 'auto', backgroundColor: '#111', padding: '10px', borderRadius: '5px', border: '1px solid #333' }}>
                {errorLogs.length === 0 && <span style={{ color: '#a3e635' }}>No errors logged. System Stable.</span>}
                {errorLogs.map((l, i) => <div key={i} style={{ borderBottom: '1px dashed #333', padding: '6px 0', fontSize: '10px', color: '#ff80bf', wordBreak: 'break-all' }}>[{l.time}] {l.msg}</div>)}
              </div>
              <div style={{ display: 'flex', gap: '10px', marginTop: '15px' }}>
                <button onClick={() => window.location.reload()} style={{ flex: 1, padding: '12px', backgroundColor: '#bef264', color: 'black', borderRadius: '5px', fontWeight: 'bold' }}>Reboot App</button>
                <button onClick={this.clearLogs} style={{ flex: 1, padding: '12px', backgroundColor: '#333', color: 'white', borderRadius: '5px', fontWeight: 'bold' }}>Clear Logs</button>
              </div>
            </>
          )}
        </div>
      </>
    );
  }
}

const container = document.getElementById('root');
const root = createRoot(container);
root.render(<ErrorBoundary><App /></ErrorBoundary>);
EOF

# Block 2
cat << 'EOF' > tailwind.config.js
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      fontFamily: { sans: ['Inter', 'sans-serif'] },
      animation: { 
        'text-shimmer': 'textShimmer 5s ease-in-out infinite',
        'fade-in-pulse': 'fadeInPulse 3s infinite',
        'tracer-glow': 'tracerGlow 4s linear infinite',
        'marquee-pause': 'marqueePause 15s linear infinite',
        'marquee-scroll': 'marqueeScroll 18s linear infinite',
      },
      keyframes: {
        textShimmer: { '0%, 100%': { 'background-size': '200% 200%', 'background-position': 'left center' }, '50%': { 'background-size': '200% 200%', 'background-position': 'right center' } },
        fadeInPulse: { '0%, 100%': { opacity: '0.7', transform: 'scale(1)', filter: 'blur(1px)' }, '50%': { opacity: '1', transform: 'scale(1.05)', filter: 'blur(0px)' } },
        tracerGlow: { '0%': { backgroundPosition: '0% 50%' }, '50%': { backgroundPosition: '100% 50%' }, '100%': { backgroundPosition: '0% 50%' } },
        marqueeScroll: {
          '0%': { transform: 'translateX(100vw)' },
          '100%': { transform: 'translateX(-100%)' },
        },
        marqueePause: {
          '0%': { transform: 'translateX(100vw)' },
          '40%': { transform: 'translateX(0)' },
          '60%': { transform: 'translateX(0)' },
          '100%': { transform: 'translateX(-100vw)' },
        }
      }
    }
  },
  plugins: [],
}
EOF

# Block 3
rm -f src/App.js
cat << 'EOF' > src/App.js
import React, { useState, useEffect, useRef, useMemo } from 'react';
import { createPortal } from 'react-dom';
import { initializeApp } from 'firebase/app';
import { getAuth, onAuthStateChanged, setPersistence, browserLocalPersistence, indexedDBLocalPersistence, browserSessionPersistence, signOut, updateEmail, signInWithEmailAndPassword, createUserWithEmailAndPassword, GoogleAuthProvider, TwitterAuthProvider, OAuthProvider, signInWithPopup, signInWithRedirect, getRedirectResult, signInAnonymously, sendPasswordResetEmail, fetchSignInMethodsForEmail, inMemoryPersistence, EmailAuthProvider, reauthenticateWithCredential, updatePassword, linkWithCredential } from 'firebase/auth';
import { getFirestore, initializeFirestore, doc, collection, query, onSnapshot, addDoc, updateDoc, setDoc, deleteDoc, arrayUnion, arrayRemove, where, getDoc, getDocs, orderBy, limit, increment, runTransaction, writeBatch } from 'firebase/firestore';
import { getStorage, ref, uploadBytesResumable, getDownloadURL, deleteObject } from 'firebase/storage';
import { SplashScreen } from '@capacitor/splash-screen';
import { loadStripe } from '@stripe/stripe-js';
import { Elements, CardElement, useStripe, useElements } from '@stripe/react-stripe-js';
import { QRCodeCanvas } from 'qrcode.react';
import { 
  AlertTriangle, Award, Bell, Bot, Box, Briefcase, Calendar, Camera, Check, CheckCircle, ChevronDown, ChevronUp, ChevronLeft, ChevronRight, 
  Ban, ShieldOff, UserPlus, Bomb, Clock, Code, Compass, Copy, CreditCard, DollarSign, Download, Edit, Eye, EyeOff, Facebook, FileText, Filter, Gift, Globe, Hammer, Heart, Type, 
  Image as ImageIcon, Info, Instagram, LayoutList, Link, Lock, LogOut, Mail, MapPin, MessageSquare, 
  Package, Pencil, Play, PlusCircle, MinusCircle, Receipt, RefreshCw, Save, Send, Settings, Share2, Shield, ShieldCheck, 
  ShoppingBag, Smartphone, Sparkles, Star, Tag, Trash2, Truck, Twitch, Twitter, User, Video, Wallet, FlaskConical, 
  Wand2, X, XCircle, Youtube, Zap, HelpCircle, Search, Phone, Music, Ghost, CheckSquare, Square, Activity, WifiOff, Users, ThumbsUp, MoreHorizontal, ShoppingCart, 
  Trash, Maximize2, List, BarChart3, TrendingUp, Radio, Crown, Music as MusicIcon, Star as StarIcon, Disc
} from 'lucide-react';

const appId = 'ravekandi-core-prod'; 

// V42.21 Phase 6: real shareable links that open the app. Optionally embed a referral
// code (?ref=) so the invitee's signup auto-fills it, and an item (?item=) for deep
// links. APP_ORIGIN is the live host so links work even when shared from the installed PWA.
const APP_ORIGIN = (() => { try { const o = window.location.origin; return (o && o.startsWith('http')) ? o : 'https://ravekandi.web.app'; } catch (e) { return 'https://ravekandi.web.app'; } })();
const buildShareUrl = ({ ref, item } = {}) => { const p = new URLSearchParams(); if (ref) p.set('ref', ref); if (item) p.set('item', item); const qs = p.toString(); return APP_ORIGIN + (qs ? ('/?' + qs) : '/'); };
// Read invite params once at load (used to auto-fill referral on signup + deep-link items).
const RK_URL_PARAMS = (() => { try { const p = new URLSearchParams(window.location.search); return { ref: p.get('ref') || '', item: p.get('item') || '' }; } catch (e) { return { ref: '', item: '' }; } })();

// V42.31 Stage C: admin moderation helpers usable directly from content cards.
const adminDeleteItem = async (item) => {
    if (!window.confirm('ADMIN: permanently delete this item post?\n"' + (item.name || '') + '"')) return;
    try {
        await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id));
        if (item.ownerId) { try { await deleteDoc(doc(db, 'artifacts', appId, 'users', item.ownerId, 'inventory', item.refId || item.id)); } catch (e) {} }
        alert('Item deleted.');
    } catch (e) { alert('Delete failed: ' + e.message); }
};
const adminBanUser = async (uid, name, durationMs, label) => {
    if (!uid) return;
    if (!window.confirm('ADMIN: ban ' + (name || 'this user') + ' ' + label + '?')) return;
    try {
        const until = durationMs === 'permanent' ? 'permanent' : Date.now() + durationMs;
        await setDoc(doc(db, 'artifacts', appId, 'users', uid), { bannedUntil: until }, { merge: true });
        pushNotif(uid, 'admin', '⛔ Your account has been restricted by the RaveKandi team (' + label + ').');
        alert((name || 'User') + ' banned ' + label + '.');
    } catch (e) { alert('Ban failed: ' + e.message); }
};
const adminDeleteComment = async (item, c) => {
    if (!window.confirm('ADMIN: delete this comment by ' + (c.user || 'user') + '?')) return;
    try { await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { comments: arrayRemove(c) }); }
    catch (e) { alert('Failed: ' + e.message); }
};
const adminDeleteBanner = async (slotId) => {
    if (!slotId) return;
    if (!window.confirm('ADMIN: remove this banner advertisement?')) return;
    try { await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'bannerSlots', String(slotId))); alert('Banner removed.'); }
    catch (e) { alert('Failed: ' + e.message); }
};

const firebaseConfig = {
  apiKey: "AIzaSyAg6iiyr3EUXLilmC9O4Mt5oJ4AVbihdr4",
  // V52.1: authDomain MUST be the app's own host. Using the default firebaseapp.com makes
  // Google sign-in hop to a different domain and fail in storage-partitioned browsers with
  // a blank "missing initial state" page. Keeping OAuth on ravekandi.web.app fixes it.
  authDomain: "ravekandi.web.app",
  projectId: "ravekandi",
  storageBucket: "ravekandi.firebasestorage.app",
  messagingSenderId: "188727793702",
  appId: "1:188727793702:web:cda6938da639ea61fb2ee7"
};
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
// V52.1: In-app browsers (Instagram, Messenger, TikTok webviews) frequently BLOCK or
// throw on IndexedDB/localStorage. setPersistence(indexedDB...) then throws BEFORE we even
// attempt the login, which broke account creation & password login inside those browsers
// (while Google redirect still worked). This helper tries the best available storage and
// gracefully falls back — preferred → localStorage → in-memory — so auth ALWAYS proceeds.
const safeSetPersistence = async (preferLocal) => {
    const chain = preferLocal
        ? [indexedDBLocalPersistence, browserLocalPersistence, browserSessionPersistence, inMemoryPersistence]
        : [browserSessionPersistence, inMemoryPersistence];
    for (const p of chain) {
        try { await setPersistence(auth, p); return; }
        catch (e) { /* this storage is blocked in this browser — try the next */ }
    }
    // If every option failed, auth still works for this session (default in-memory).
};
const db = initializeFirestore(app, { experimentalForceLongPolling: true });
const storage = getStorage(app);

const stripePromise = loadStripe('pk_test_51TPtnt2MxetxkseOoF7LgE3ZvI8F7txTFexIp8h6gxm1YABwoR7ndJGZxxD3gj9cTEjCAi6zQbBpDnipZHVZxDQy00zbrmzqlU');
const SOLANA_RECEIVER = 'BUadX7d3Z7fVwvdQEd3C4vVA7toZpFeosEnueRiVb3mV';
EOF

# Block 4
cat << 'EOF' >> src/App.js

const GEMINI_API_KEY = "AIzaSyBVM6ot4YUYk4RpD4AgAymh4PuDczwJSh0";
const PROFIT_MARGIN = 2.2;
const COMMISSION_RATE = 0.20;
const KANDI_TYPES = [
    'Single (Bracelet)', 'Cuff', 'Multi-Bead Set', 'Charm Bracelet', 'Beaded Ring', 'Anklet', 'Necklace', 'Choker', 'Earrings', 'Beaded Watch',
    'Perler / Fuse Art', 'Mask', 'Goggles', 'Pacifier / Bottle',
    'Pashmina', 'Hat / Cap', 'Bucket Hat', 'Beanie', 'Sunglasses / Shades', 'Gloves / Fluffies', 'Leg Warmers', 'Bra / Top', 'Bodysuit', 'Shorts / Bottoms', 'Pasties', 'Harness', 'Hood', 'Tutu / Skirt', 'Wings', 'Boot Covers', 'Arm Sleeves',
    'Hair Clip / Accessory', 'Pin / Button', 'Patch', 'Keychain', 'Bag / Purse', 'Belt',
    'Full Outfit / Set', 'Bead Supplies', 'Charms (loose)', 'String / Cord', 'Custom Commission', 'Other'
];
const NAME_CHANGE_LIMIT_DAYS = 30;
const BIO_CHAR_LIMIT = 200;
// V42.11: DEV_PIN backdoor removed for launch (Firestore rules deny the write anyway).
// Admins are seeded once via the Firebase Console — see LAUNCH_INSTRUCTIONS.md.
// V52.2: unique-visitor analytics. Counts each device once (ever) on first app open, plus
// daily-active pings — so the admin can gauge traffic vs. signups. Stored on global/stats.
const trackUniqueVisit = async () => {
    try {
        const VKEY = 'rk_visitor_id';
        let isNew = false;
        let vid = localStorage.getItem(VKEY);
        if (!vid) { vid = 'v_' + Date.now() + '_' + Math.random().toString(36).slice(2, 8); localStorage.setItem(VKEY, vid); isNew = true; }
        const statsRef = doc(db, 'artifacts', appId, 'global', 'stats');
        // daily-active stamp (one per device per day)
        const today = new Date().toISOString().slice(0, 10);
        const dKey = 'rk_da_' + today;
        const countedToday = localStorage.getItem(dKey);
        const upd = {};
        if (isNew) upd.uniqueVisitors = increment(1);
        if (!countedToday) { upd['dau_' + today] = increment(1); localStorage.setItem(dKey, '1'); }
        if (Object.keys(upd).length) { try { await setDoc(statsRef, upd, { merge: true }); } catch (e) {} }
    } catch (e) { /* storage blocked — skip */ }
};

// Remote config: live-synced from artifacts/{appId}/global/config by an App listener.
let RK_CFG = { checkoutEnabled: true, paymentsLive: false, bannersEnabled: true, boostsEnabled: true, aiLabEnabled: true, launchPerks: true, maintenanceMessage: '', minVersion: '', marqueeSpeed: 60, videoRotateSec: 8, videoWindowMin: 30, bannerAnnounceOnly: false, maintenanceExpiry: 0, popInActive: false, popInMessage: '', popInTheme: 'message', popInMedia: '', popInMediaType: '', popInExpiry: 0, popInId: '', discoveryTipMin: 0, spotlightPlaceholderActive: false, spotlightPlaceholderUrl: '', spotlightPlaceholderCaption: '', spotlightPlaceholderName: 'RaveKandi', chatDelaySec: 8, chatVipShareMax: 5, chatCollectionShareMax: 5 };
const APP_VERSION = '63.03.04';
const cmpVer = (a, b) => { const pa = String(a).replace(/^V/i, '').split('.').map(n => parseInt(n) || 0), pb = String(b).replace(/^V/i, '').split('.').map(n => parseInt(n) || 0); for (let i = 0; i < 3; i++) { if ((pa[i] || 0) !== (pb[i] || 0)) return (pa[i] || 0) - (pb[i] || 0); } return 0; };
// V42.12: launch perks — while RK_CFG.launchPerks is ON, every raver is treated
// as VIP and seller commission drops by 10 points (20% → 10%). Admin toggles it
// off in Remote Config at full release; paid plans then resume.
const isEffVIP = (profile) => !!(profile?.isVIP || RK_CFG.launchPerks);
const effCommissionRate = (base, lockedRate) => {
    const b = (base === null || base === undefined) ? COMMISSION_RATE : base;
    const live = RK_CFG.launchPerks ? Math.max(0, b - 0.10) : b; // current period rate
    // Permanent launch lock-in: a user granted lockedCommissionRate never pays more than it.
    if (lockedRate !== null && lockedRate !== undefined && !isNaN(lockedRate)) return Math.min(live, lockedRate);
    return live;
};
// V42.12: iOS-in-browser detection for the Add-to-Home-Screen guide
const IS_IOS_BROWSER = (() => { try { const ua = navigator.userAgent || ''; const ios = /iphone|ipad|ipod/i.test(ua); const standalone = (window.matchMedia && window.matchMedia('(display-mode: standalone)').matches) || window.navigator.standalone === true; return ios && !standalone; } catch (e) { return false; } })();
// V42.16: true when running in a normal browser tab (NOT the installed home-screen app).
const IS_STANDALONE = (() => { try { return (window.matchMedia && window.matchMedia('(display-mode: standalone)').matches) || window.navigator.standalone === true; } catch (e) { return false; } })();
const IS_IOS = (() => { try { return /iphone|ipad|ipod/i.test(navigator.userAgent || ''); } catch (e) { return false; } })();
const IS_ANDROID = (() => { try { return /android/i.test(navigator.userAgent || ''); } catch (e) { return false; } })();
// V62: detect HOW the user is connected so the install popup can offer the right options.
// 'apk' = running inside the native Capacitor APK; 'pwa' = installed home-screen web app;
// 'web' = a normal browser tab (iOS or Android or desktop).
const CONNECTION_MODE = (() => {
    try {
        if (window.Capacitor && window.Capacitor.isNativePlatform && window.Capacitor.isNativePlatform()) return 'apk';
        const standalone = (window.matchMedia && window.matchMedia('(display-mode: standalone)').matches) || window.navigator.standalone === true;
        if (standalone) return 'pwa';
        return 'web';
    } catch (e) { return 'web'; }
})();
// GitHub-hosted Android APK (direct download). App-store links are placeholders until launch.
const ANDROID_APK_URL = 'https://github.com/Kn1teMare/RaveKandi-build/releases/latest';
const WEB_APP_URL = 'https://ravekandi.web.app';
const DAILY_AI_LIMIT = 5;

const RADIO_STATIONS = [
    { id: 'house',  name: 'Deep House',     genre: 'House',                 url: 'https://ice1.somafm.com/beatblender-128-mp3',  color: '#ff50b4' },
    { id: 'techno', name: 'Techno Trip',    genre: 'Techno / Trance',       url: 'https://ice1.somafm.com/thetrip-128-mp3',      color: '#b464ff' },
    { id: 'edm',    name: 'EDM Mainstage',  genre: 'EDM / Big Room',        url: 'https://ice1.somafm.com/defcon-128-mp3',       color: '#64ffff' },
    { id: 'chill',  name: 'Chill Vibes',    genre: 'Downtempo / Ambient',   url: 'https://ice1.somafm.com/groovesalad-128-mp3',  color: '#b4ff64' },
    { id: 'dnb',    name: 'Bass & DnB',     genre: 'Drum & Bass / Dubstep', url: 'https://ice1.somafm.com/dubstep-128-mp3',      color: '#ffd700' },
    { id: 'idm',    name: 'Glitch Lab',     genre: 'IDM / Glitch',          url: 'https://ice1.somafm.com/cliqhop-128-mp3',      color: '#ff8050' },
    { id: 'space',  name: 'Space Station',  genre: 'Spaced-Out Beats',      url: 'https://ice1.somafm.com/spacestation-128-mp3', color: '#80ffff' },
    { id: 'lush',   name: 'Lush Lounge',    genre: 'Chill Vocal Electronica', url: 'https://ice1.somafm.com/lush-128-mp3',       color: '#ff80bf' },
    { id: 'trap',   name: 'Trap Temple',    genre: 'Trap EDM',              url: 'https://radiorecord.hostingradio.ru/trap96.aacp',    color: '#ff3864' },
    { id: 'edmhh',  name: 'Beat Bodega',    genre: 'EDM Hip-Hop',           url: 'https://ice1.somafm.com/fluid-128-mp3',        color: '#9d4edd' },
    { id: 'top100', name: 'Top 100 EDM',    genre: 'Top Dance Hits',        url: 'https://radiorecord.hostingradio.ru/rr_main96.aacp', color: '#00f5d4' },
    { id: 'hardstyle', name: 'Hardstyle HQ', genre: 'Hardstyle / Hardcore',  url: 'https://radiorecord.hostingradio.ru/hardstyle96.aacp', color: '#ff2079' },
    { id: 'psy',    name: 'Psytrance',      genre: 'Psy / Goa Trance',      url: 'https://radiorecord.hostingradio.ru/goa96.aacp',     color: '#39ff14' },
    { id: 'future', name: 'Future House',   genre: 'Future / Bass House',   url: 'https://radiorecord.hostingradio.ru/fbass96.aacp',    color: '#7b2fff' },
    { id: 'trance2',name: 'Trance Mission', genre: 'Uplifting Trance',      url: 'https://radiorecord.hostingradio.ru/tm96.aacp',       color: '#00bfff' },
];
// V42.19 Phase 4: curated well-known YouTube genre live-streams / playlists. YouTube
// can't be piped through the <audio> EQ player, so these open the stream on YouTube
// in a new tab (full visuals + chat). Surfaced in the radio modal as a separate list.
const YOUTUBE_STATIONS = [
    { id: 'yt_lofi_edm', name: 'EDM / Future Bass Mix', genre: 'YouTube · Future Bass', url: 'https://www.youtube.com/results?search_query=future+bass+mix+2025', color: '#ff50b4' },
    { id: 'yt_house',    name: 'House & Tech House Mix', genre: 'YouTube · House',       url: 'https://www.youtube.com/results?search_query=tech+house+mix+2025', color: '#b464ff' },
    { id: 'yt_techno',   name: 'Techno Livestream',      genre: 'YouTube · Techno',      url: 'https://www.youtube.com/results?search_query=techno+livestream', color: '#64ffff' },
    { id: 'yt_trance',   name: 'Trance Classics Mix',    genre: 'YouTube · Trance',      url: 'https://www.youtube.com/results?search_query=trance+mix+2025', color: '#00bfff' },
    { id: 'yt_dubstep',  name: 'Dubstep / Riddim Mix',   genre: 'YouTube · Dubstep',     url: 'https://www.youtube.com/results?search_query=dubstep+mix+2025', color: '#ffd700' },
    { id: 'yt_hardstyle',name: 'Hardstyle Mix',          genre: 'YouTube · Hardstyle',   url: 'https://www.youtube.com/results?search_query=hardstyle+mix+2025', color: '#ff2079' },
    { id: 'yt_dnb',      name: 'Drum & Bass Mix',        genre: 'YouTube · DnB',         url: 'https://www.youtube.com/results?search_query=drum+and+bass+mix+2025', color: '#39ff14' },
    { id: 'yt_festival', name: 'Festival Sets (Tomorrowland etc.)', genre: 'YouTube · Live Sets', url: 'https://www.youtube.com/results?search_query=tomorrowland+2025+mainstage', color: '#ff8050' },
];

const NEON_COLORS = { 'primaryGlow': 'rgb(255, 80, 180)', 'accentGlow': 'rgb(100, 255, 255)', 'purpleGlow': 'rgb(180, 100, 255)', 'limeGlow': 'rgb(180, 255, 100)', 'goldGlow': 'rgb(255, 215, 0)' };
const DEFAULT_INVENTORY = [
    { id: 'b_neon_pink', name: 'Neon Pink', type: 'bead', cost: 0.02, sell: 0.05, image: 'https://placehold.co/50x50/ff00ff/ffffff?text=Pink' },
    { id: 'b_neon_green', name: 'Slime Green', type: 'bead', cost: 0.02, sell: 0.05, image: 'https://placehold.co/50x50/00ff00/000000?text=Green' },
    { id: 'b_black', name: 'Midnight Blk', type: 'bead', cost: 0.02, sell: 0.05, image: 'https://placehold.co/50x50/000000/ffffff?text=Blk' },
    { id: 'b_letter', name: 'Letter Block', type: 'letter', cost: 0.10, sell: 0.25, image: 'https://placehold.co/50x50/eeeeee/000000?text=ABC' },
    { id: 'c_star', name: 'Holo Star', type: 'charm', cost: 0.50, sell: 1.25, image: 'https://placehold.co/50x50/ffff00/000000?text=Star' },
    { id: 's_elastic', name: 'Clear Cord', type: 'string', cost: 0.20, sell: 0.50, image: 'https://placehold.co/50x50/ffffff/000000?text=Cord' },
];
const NOTIFICATION_TYPES = [{ id: 'promos', label: 'Promos' }, { id: 'app_updates', label: 'App Updates' }, { id: 'merch', label: 'Merch Drops' }, { id: 'discounts', label: 'Discounts' }, { id: 'projects', label: 'Project Updates' }];
const ACHIEVEMENT_TIERS = [
    // Creator / status
    { id: 'kandi_creator', name: 'Official Creator', tier: 1, metric: 'isKandiCreator', threshold: 1, icon: Hammer, desc: "Get approved as a Verified Creator." },
    { id: 'top_creator', name: 'Crowned Creator', tier: 1, metric: 'topCreatorUnlocked', threshold: 1, icon: Crown, desc: "Reach #1 on the Creator Points leaderboard. The badge is yours forever." },
    // Listing / collection
    { id: 'collector_1', name: 'Kandi Collector', tier: 1, metric: 'totalItems', threshold: 5, icon: Package, desc: "List 5 unique Kandi items." },
    { id: 'collector_2', name: 'Kandi Curator', tier: 1, metric: 'totalItems', threshold: 25, icon: Package, desc: "List 25 unique Kandi items." },
    { id: 'collector_3', name: 'Kandi Hoarder', tier: 1, metric: 'totalItems', threshold: 100, icon: Package, desc: "List 100 unique Kandi items." },
    // Sales value
    { id: 'sales_1', name: 'Hustler (Iron)', tier: 1, metric: 'totalSalesValue', threshold: 100, icon: DollarSign, desc: "Reach $100 in total sales." },
    { id: 'sales_2', name: 'Hustler (Bronze)', tier: 1, metric: 'totalSalesValue', threshold: 500, icon: DollarSign, desc: "Reach $500 in total sales." },
    { id: 'sales_3', name: 'Hustler (Silver)', tier: 1, metric: 'totalSalesValue', threshold: 1000, icon: DollarSign, desc: "Reach $1,000 in total sales." },
    { id: 'sales_4', name: 'Hustler (Gold)', tier: 1, metric: 'totalSalesValue', threshold: 5000, icon: DollarSign, desc: "Reach $5,000 in total sales." },
    { id: 'sales_5', name: 'Kandi Tycoon', tier: 1, metric: 'totalSalesValue', threshold: 10000, icon: TrendingUp, desc: "Reach $10,000 in total sales." },
    // Items sold (count)
    { id: 'sold_1', name: 'First Sale', tier: 1, metric: 'itemsSold', threshold: 1, icon: Tag, desc: "Sell your very first item." },
    { id: 'sold_2', name: 'Shopkeeper', tier: 1, metric: 'itemsSold', threshold: 25, icon: Tag, desc: "Sell 25 items." },
    { id: 'sold_3', name: 'Kandi Merchant', tier: 1, metric: 'itemsSold', threshold: 100, icon: Tag, desc: "Sell 100 items." },
    // Buying
    { id: 'buy_1', name: 'First Haul', tier: 1, metric: 'itemsBought', threshold: 1, icon: ShoppingBag, desc: "Buy your first item." },
    { id: 'buy_2', name: 'Supporter', tier: 1, metric: 'itemsBought', threshold: 10, icon: ShoppingBag, desc: "Buy 10 items from the community." },
    { id: 'buy_3', name: 'Patron of PLUR', tier: 1, metric: 'itemsBought', threshold: 50, icon: ShoppingBag, desc: "Buy 50 items." },
    { id: 'spent_1', name: 'Big Spender', tier: 1, metric: 'totalBoughtValue', threshold: 500, icon: CreditCard, desc: "Spend $500 supporting other ravers." },
    // Likes / comments / social
    { id: 'social_1', name: 'Vibe Spreader', tier: 1, metric: 'socialInteractions', threshold: 10, icon: MessageSquare, desc: "Interact with the community 10 times." },
    { id: 'social_2', name: 'Social Butterfly', tier: 1, metric: 'socialInteractions', threshold: 50, icon: MessageSquare, desc: "Interact with the community 50 times." },
    { id: 'likes_1', name: 'Crowd Favorite', tier: 1, metric: 'totalLikes', threshold: 25, icon: Heart, desc: "Receive 25 likes across your posts." },
    { id: 'likes_2', name: 'Kandi Famous', tier: 1, metric: 'totalLikes', threshold: 100, icon: Heart, desc: "Receive 100 likes across your posts." },
    { id: 'comments_1', name: 'Conversation Starter', tier: 1, metric: 'totalComments', threshold: 25, icon: MessageSquare, desc: "Receive 25 comments across your posts." },
    // Referrals
    { id: 'ref_1', name: 'PLUR Ambassador', tier: 1, metric: 'referrals', threshold: 1, icon: Users, desc: "Bring 1 new friend to RaveKandi." },
    { id: 'biolink', name: 'Link in Bio Hero', tier: 1, metric: 'bioLinkAdded', threshold: 1, icon: Link, desc: "Add your RaveKandi invite link to your social bio." },
    { id: 'ref_2', name: 'Recruiter', tier: 1, metric: 'referrals', threshold: 10, icon: Users, desc: "Refer 10 ravers." },
    { id: 'ref_3', name: 'Rave Evangelist', tier: 1, metric: 'referrals', threshold: 50, icon: Users, desc: "Refer 50 ravers." },
    // Trades
    { id: 'trade_1', name: 'Trader', tier: 1, metric: 'completedTrades', threshold: 1, icon: Gift, desc: "Complete your first trade." },
    { id: 'trade_2', name: 'Trade Master', tier: 1, metric: 'completedTrades', threshold: 25, icon: Gift, desc: "Complete 25 trades." },
    // Radio listening
    { id: 'radio_1', name: 'Tuned In', tier: 1, metric: 'radioMinutes', threshold: 60, icon: Radio, desc: "Listen to Rave Radio for 1 hour." },
    { id: 'radio_2', name: 'Dancefloor Devotee', tier: 1, metric: 'radioMinutes', threshold: 600, icon: Radio, desc: "Listen to Rave Radio for 10 hours." },
    // Vibe Tribe — friends
    { id: 'friend_1', name: 'First Connection', tier: 1, metric: 'friendsCount', threshold: 1, icon: UserPlus, desc: "Add your first friend." },
    { id: 'friend_2', name: 'Squad Forming', tier: 1, metric: 'friendsCount', threshold: 5, icon: Users, desc: "Reach 5 friends." },
    { id: 'friend_3', name: 'Social Butterfly', tier: 2, metric: 'friendsCount', threshold: 25, icon: Users, desc: "Reach 25 friends." },
    { id: 'friend_4', name: 'PLUR Network', tier: 3, metric: 'friendsCount', threshold: 100, icon: Users, desc: "Reach 100 friends." },
    // Vibe Tribe — tribes & chat
    { id: 'tribe_1', name: 'Tribe Founder', tier: 1, metric: 'tribesJoined', threshold: 1, icon: Star, desc: "Create or join your first Vibe Tribe." },
    { id: 'tribe_3', name: 'Multi-Tribe', tier: 2, metric: 'tribesJoined', threshold: 3, icon: Star, desc: "Be part of 3 Vibe Tribes at once." },
    { id: 'tribe_big_5', name: 'Growing Tribe', tier: 2, metric: 'biggestTribe', threshold: 5, icon: Users, desc: "Be in a tribe with 5+ members." },
    { id: 'tribe_big_10', name: 'Massive Movement', tier: 3, metric: 'biggestTribe', threshold: 10, icon: Users, desc: "Be in a tribe with 10+ members." },
    { id: 'tribe_msg_50', name: 'Tribe Chatter', tier: 1, metric: 'tribeMessages', threshold: 50, icon: MessageSquare, desc: "Send 50 messages in tribe group chats." },
    { id: 'tribe_msg_500', name: 'Tribe Voice', tier: 2, metric: 'tribeMessages', threshold: 500, icon: MessageSquare, desc: "Send 500 messages in tribe group chats." },
    // Activity / loyalty
    { id: 'active_1', name: 'Regular', tier: 1, metric: 'activeMinutes', threshold: 300, icon: Activity, desc: "Spend 5 active hours in the app." },
    { id: 'active_2', name: 'Always Raving', tier: 1, metric: 'activeMinutes', threshold: 3000, icon: Activity, desc: "Spend 50 active hours in the app." },
    // VIP features
    { id: 'banner_5', name: 'Marquee Mogul', tier: 1, metric: 'bannerPosts', threshold: 5, icon: Zap, desc: "Post 5 banner messages on the live marquee." },
    { id: 'boost_5', name: 'Spotlight Seeker', tier: 1, metric: 'boostsUsed', threshold: 5, icon: TrendingUp, desc: "Boost your posts 5 times." },
    { id: 'video_1', name: 'Festival Filmmaker', tier: 1, metric: 'videosPosted', threshold: 1, icon: Video, desc: "Feature a festival clip in the Spotlight." },
    { id: 'video_5', name: 'Content Creator', tier: 1, metric: 'videosPosted', threshold: 5, icon: Video, desc: "Feature 5 festival clips." },
    // Meta
    { id: 'ach_5', name: 'Achiever', tier: 1, metric: 'achievementsUnlocked', threshold: 5, icon: Award, desc: "Unlock 5 achievements." },
    { id: 'ach_15', name: 'Completionist', tier: 1, metric: 'achievementsUnlocked', threshold: 15, icon: Award, desc: "Unlock 15 achievements." },
];
const NOTIF_INAPP_TYPES = [{id:'message',label:'Direct Messages'},{id:'friendreq',label:'Friend Requests'},{id:'comment',label:'Comments'},{id:'like',label:'Likes'},{id:'cart',label:'Cart Adds'},{id:'sold',label:'Item Sold'},{id:'diy',label:'DIY / Requests'},{id:'queue',label:'Creator Queue'},{id:'achievement',label:'Achievements'},{id:'referral',label:'Referrals'},{id:'ticket',label:'Ticket Replies'},{id:'admin',label:'Admin Alerts'}];

// V42.10: launch rework — RevShare now pays up to 25% of the app's commission.
const REFERRAL_TIERS = [
    { min: 1, max: 4, badge: 'Neon Pink', sharePct: 2, color: 'text-pink-500' },
    { min: 5, max: 9, badge: 'Slime Green', sharePct: 3.5, color: 'text-lime-400' },
    { min: 10, max: 24, badge: 'Liquid Metal', sharePct: 5, color: 'text-cyan-400' },
    { min: 25, max: 49, badge: 'Holographic', sharePct: 7, color: 'text-purple-400' },
    { min: 50, max: 99, badge: 'Laser Core', sharePct: 9, color: 'text-yellow-400' },
    { min: 100, max: 249, badge: 'Plasma', sharePct: 11.5, color: 'text-red-500' },
    { min: 250, max: 499, badge: 'Supernova', sharePct: 14, color: 'text-orange-400' },
    { min: 500, max: 999, badge: 'Dark Matter', sharePct: 17, color: 'text-gray-400' },
    { min: 1000, max: 2499, badge: 'PLUR God', sharePct: 20, color: 'text-white' },
    { min: 2500, max: 4999, badge: 'Cosmic Forge', sharePct: 22.5, color: 'text-fuchsia-400' },
    { min: 5000, max: 999999, badge: 'Eternal Rave', sharePct: 25, color: 'text-amber-300' }
];
export const getReferralTier = (count) => { return REFERRAL_TIERS.find(t => count >= t.min && count <= t.max) || { badge: 'None', sharePct: 0, color: 'text-white/30' }; };

// V62: Radio chat constants. Each in-app station has its own chat channel keyed by station id;
// 'global' is the shared all-stations room (default).
const CHAT_GLOBAL_ID = 'global';
// Hard list of slurs to block (NOT profanity — profanity is allowed). Kept intentionally
// minimal and focused on hate speech. Leetspeak/spacing bypasses are normalized before match.
const CHAT_BLOCKED_TERMS = ['nigger','nigga','faggot','fag','retard','chink','spic','kike','wetback','tranny','coon','gook','beaner','dyke'];
// Detect links / contact handles so non-VIP users can't drop them (anti-spam).
const looksLikeLink = (text) => {
    const t = (text || '').toLowerCase();
    if (/https?:\/\//.test(t) || /www\./.test(t)) return true;
    // domain.tld with common TLDs, including spaced/dotted bypasses like "site dot com"
    if (/\b[a-z0-9-]+\.(com|net|org|io|gg|me|co|tv|app|link|xyz|store|shop|info|biz|ly|to|cc)\b/.test(t)) return true;
    if (/[a-z0-9-]+\s*(dot|\(dot\)|\[dot\])\s*(com|net|org|io|gg|me|co|tv|app)/.test(t)) return true;
    // social handles / "dm me on X"
    if (/@[a-z0-9_.]{3,}/.test(t) && /(insta|ig|snap|tele|telegram|whatsapp|wa|cashapp|venmo|paypal|onlyfans|of|disc)/.test(t)) return true;
    return false;
};
// Normalize leetspeak + separators so "n i g g e r" / "n1gg3r" are caught.
const normalizeForFilter = (text) => (text || '').toLowerCase()
    .replace(/[0]/g, 'o').replace(/[1!|]/g, 'i').replace(/[3]/g, 'e').replace(/[4@]/g, 'a').replace(/[5$]/g, 's').replace(/[7]/g, 't')
    .replace(/[^a-z]/g, '');
const chatModerate = (text, { isVIP }) => {
    const raw = (text || '').trim();
    if (!raw) return { ok: false, reason: 'empty' };
    const norm = normalizeForFilter(raw);
    for (const term of CHAT_BLOCKED_TERMS) { if (norm.includes(normalizeForFilter(term))) return { ok: false, reason: 'hate', flagged: true }; }
    // Links: blocked for everyone in the normal message path (VIPs share links via the
    // dedicated "share social link" action, which is rate-limited separately).
    if (looksLikeLink(raw)) return { ok: false, reason: 'link', flagged: true };
    return { ok: true };
};
// Today's date key for per-day share caps.
const todayKey = () => { const d = new Date(); return d.getFullYear() + '-' + (d.getMonth()+1) + '-' + d.getDate(); };


const Volume = ({size, color}) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2"><path d="M11 5L6 9H2v6h4l5 4V5zM19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"/></svg>;
const SOCIAL_PLATFORMS = [
    { id: 'instagram', name: 'Instagram', icon: Instagram, color: '#E1306C', baseUrl: 'instagram.com/' }, { id: 'twitter', name: 'X / Twitter', icon: Twitter, color: '#1DA1F2', baseUrl: 'twitter.com/' }, { id: 'tiktok', name: 'TikTok', icon: MusicIcon, color: '#00F2EA', baseUrl: 'tiktok.com/@' }, { id: 'snapchat', name: 'Snapchat', icon: Ghost, color: '#FFFC00', baseUrl: 'snapchat.com/add/' }, { id: 'soundcloud', name: 'SoundCloud', icon: Volume, color: '#FF5500', baseUrl: 'soundcloud.com/' }, { id: 'youtube', name: 'YouTube', icon: Youtube, color: '#FF0000', baseUrl: 'youtube.com/@' }, { id: 'twitch', name: 'Twitch', icon: Twitch, color: '#9146FF', baseUrl: 'twitch.tv/' }, { id: 'telegram', name: 'Telegram', icon: MessageSquare, color: '#0088cc', baseUrl: 't.me/' }, { id: 'whatsapp', name: 'WhatsApp', icon: Phone, color: '#25D366', baseUrl: 'wa.me/' }, { id: 'radiate', name: 'Radiate', icon: Activity, color: '#ff00ff', baseUrl: 'radiate.app/' },
    { id: 'onlyfans', name: 'OnlyFans', icon: Heart, color: '#00AFF0', baseUrl: 'onlyfans.com/' },
    { id: 'fansly', name: 'Fansly', icon: Heart, color: '#1DA1F2', baseUrl: 'fansly.com/' }
];
const ITEM_CATEGORIES = {
    'Bead': ['Pony', 'Perler/Fuse', 'Glass', 'Letter/Alphabet', 'Seed', 'Neon', 'Glow-in-Dark', 'Metallic', 'Wood', 'Acrylic', 'Rhinestone', 'Pearl'],
    'String/Cord': ['Elastic', 'Stretch Magic', 'Nylon', 'Hemp', 'Fabric', 'Tiger Tail Wire', 'Memory Wire', 'Leather Cord'],
    'Charm': ['Plastic', 'Metal', 'Enamel', 'Resin', 'Glow', 'Letter Charm', 'Bell'],
    'Fabric': ['Cotton', 'Polyester', 'Spandex/Lycra', 'Nylon', 'Mesh/Fishnet', 'Velvet', 'Sequin', 'Holographic', 'Faux Fur', 'Fleece', 'Satin', 'Lace', 'Denim', 'Leather/Faux', 'Chiffon', 'Organza'],
    'Clothing': ['Top', 'Bra/Bralette', 'Bodysuit', 'Crop Top', 'Shorts', 'Skirt', 'Tutu', 'Leggings', 'Bottoms', 'Hoodie', 'Jacket', 'Dress', 'Romper', 'Set/Outfit'],
    'Hat/Headwear': ['Bucket Hat', 'Cap', 'Beanie', 'Cowboy Hat', 'Visor', 'Headband', 'Hair Clip', 'Flower Crown', 'Bandana'],
    'Accessory': ['Sunglasses', 'Goggles', 'Gloves/Fluffies', 'Leg Warmers', 'Arm Sleeves', 'Boot Covers', 'Belt', 'Harness', 'Bag/Purse', 'Pasties', 'Wings', 'Pin/Button', 'Patch', 'Keychain'],
    'Plushie/Toy': ['Mini Plush', 'Backpack Plush', 'Keychain Plush', 'Clip-On', 'Blacklight Plush'],
    'Trinket': ['Alien Head', 'Mushroom', 'Doll', 'Star', 'Heart', 'Smiley', 'Dice', 'Skull', 'Bear', 'Lightning Bolt'],
    'Supplies': ['Needle', 'Scissors', 'Glue/Adhesive', 'Clasp', 'Jump Ring', 'Storage', 'Tool Kit'],
    'Other': ['Custom']
};
const ITEM_SIZES = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'Huge'];
EOF

# Block 5
cat << 'EOF' >> src/App.js
const getTextGlowStyle = (color = 'primaryGlow') => ({ textShadow: `0 0 10px ${NEON_COLORS[color]}, 0 0 20px ${NEON_COLORS[color]}`, fontFamily: '"Inter", sans-serif' });

// V42.22 Phase 7: VIP Font Selector — fonts (system + safe web stacks) and text effects.
const RK_FONTS = [
    { id: 'default', name: 'Default', stack: '"Inter", sans-serif' },
    { id: 'mono', name: 'Mono', stack: '"Courier New", monospace' },
    { id: 'serif', name: 'Elegant Serif', stack: 'Georgia, "Times New Roman", serif' },
    { id: 'round', name: 'Rounded', stack: '"Trebuchet MS", "Segoe UI", sans-serif' },
    { id: 'wide', name: 'Wide Impact', stack: '"Arial Black", Impact, sans-serif' },
    { id: 'hand', name: 'Handwritten', stack: '"Comic Sans MS", "Bradley Hand", cursive' },
    { id: 'slab', name: 'Bold Slab', stack: '"Rockwell", "Courier New", serif' },
    { id: 'condensed', name: 'Condensed', stack: '"Arial Narrow", "Helvetica Neue", sans-serif' },
    { id: 'palatino', name: 'Classic Book', stack: '"Palatino Linotype", "Book Antiqua", Palatino, serif' },
    { id: 'tahoma', name: 'Clean Sans', stack: 'Tahoma, Verdana, Geneva, sans-serif' },
    { id: 'copper', name: 'Engraved Caps', stack: '"Copperplate", "Copperplate Gothic Light", fantasy' },
    { id: 'lucida', name: 'Soft Script', stack: '"Lucida Handwriting", "Segoe Script", cursive' },
    { id: 'gill', name: 'Modern Humanist', stack: '"Gill Sans", "Gill Sans MT", "Segoe UI", sans-serif' },
    { id: 'garamond', name: 'Refined Serif', stack: 'Garamond, "Hoefler Text", "Times New Roman", serif' },
];
const RK_FX = [
    { id: 'none', name: 'None' },
    { id: 'pastel', name: 'Pastel Gradient' },
    { id: 'metallic', name: 'Metallic' },
    { id: 'flowmetal', name: 'Flowing Metal' },
    { id: 'shimmer', name: 'Shimmering' },
    { id: 'iridescent', name: 'Iridescent' },
    { id: 'trippy', name: 'Trippy' },
    { id: 'chromatic', name: 'Chromatic' },
    { id: 'gold', name: 'Gold Foil' },
    { id: 'holo', name: 'Holographic' },
    { id: 'neon', name: 'Neon Glow' },
    { id: 'flow', name: 'Custom Flow (2-color)' },
    { id: 'shimmer2', name: 'Custom Shimmer (2-color)' },
    { id: 'gradient', name: 'Custom Gradient' },
    { id: 'solid', name: 'Solid Color' },
];
// Effects that read the user's chosen colors (--rkfx-c / --rkfx-c2).
const RK_FX_USES_C = ['neon', 'solid'];
const RK_FX_USES_C2 = ['gradient', 'flow', 'shimmer2'];
// Build inline style + className from a saved textStyle object {font, fx, c, c2, bright}.
// Brightness is capped 60–100% to prevent unreadable over-bright text.
const getUserTextStyle = (ts) => {
    if (!ts || typeof ts !== 'object') return { style: {}, className: '' };
    const font = RK_FONTS.find(f => f.id === ts.font);
    const bright = Math.max(60, Math.min(100, ts.bright || 100));
    const style = {};
    if (font && font.id !== 'default') style.fontFamily = font.stack;
    if (bright !== 100) style.filter = 'brightness(' + (bright / 100) + ')';
    if (ts.c) { style['--rkfx-c'] = ts.c; }
    if (ts.c2) { style['--rkfx-c2'] = ts.c2; }
    if (ts.fx === 'solid' && ts.c) style.color = ts.c;
    const className = (ts.fx && ts.fx !== 'none' && ts.fx !== 'solid') ? ('rkfx-' + ts.fx) : '';
    return { style, className };
};
const getBoxGlowStyle = (color = 'accentGlow') => ({ boxShadow: `0 0 8px ${NEON_COLORS[color]}, 0 0 15px ${NEON_COLORS[color]} inset`, borderColor: NEON_COLORS[color] });
const getBulkDiscount = (qty) => { if (qty >= 100) return 0.20; if (qty >= 50) return 0.15; if (qty >= 25) return 0.10; if (qty >= 10) return 0.05; return 0; };
// V37.12: fairness window — higher price/complexity gives the requested Creator more time
export const getIdleWindowHours = (price = 0, parts = 0) => {
    let h = 24;
    if (price >= 25 || parts >= 10) h = 48;
    if (price >= 75 || parts >= 20) h = 72;
    return h;
};

// V42.09: banner link safety — banners may only link to verified social platforms.
// Structural checks block shorteners, redirect chains, IP hosts and embedded credentials.
// (Following redirects isn't possible client-side, hence the strict allowlist approach.)
const SAFE_SOCIAL_HOSTS = ['instagram.com','tiktok.com','twitter.com','x.com','youtube.com','youtu.be','facebook.com','twitch.tv','soundcloud.com','spotify.com','open.spotify.com','discord.gg','discord.com','linktr.ee','threads.net','snapchat.com','reddit.com','t.me','wa.me','radiate.app','onlyfans.com','fansly.com'];
const BLOCKED_SHORTENERS = ['bit.ly','tinyurl.com','t.co','goo.gl','rb.gy','cutt.ly','is.gd','shorturl.at','ow.ly','rebrand.ly'];
// V42.14: parse a festival-clip URL into an embeddable player.
// Supports YouTube (incl. Shorts), TikTok, Instagram Reels/posts. No file
// hosting — we embed the platform's own player, so nothing is stored on our end.
const parseVideoLink = (raw) => {
    try {
        let s = (raw || '').trim();
        if (!s) return { ok: false, reason: 'Paste a link to your clip first.' };
        if (!/^https?:\/\//i.test(s)) s = 'https://' + s;
        const u = new URL(s);
        if (u.protocol !== 'https:') return { ok: false, reason: 'Only https:// links are allowed.' };
        const host = u.hostname.toLowerCase().replace(/^www\./, '');

        // YouTube (watch, youtu.be, shorts, embed)
        if (host === 'youtube.com' || host === 'm.youtube.com' || host === 'youtu.be' || host === 'youtube-nocookie.com') {
            let id = '';
            if (host === 'youtu.be') id = u.pathname.slice(1).split('/')[0];
            else if (u.pathname.startsWith('/shorts/')) id = u.pathname.split('/')[2];
            else if (u.pathname.startsWith('/embed/')) id = u.pathname.split('/')[2];
            else id = u.searchParams.get('v') || '';
            if (!/^[A-Za-z0-9_-]{6,15}$/.test(id)) return { ok: false, reason: 'Could not read that YouTube video ID.' };
            return { ok: true, platform: 'youtube', embedUrl: 'https://www.youtube-nocookie.com/embed/' + id + '?autoplay=1&mute=1&playsinline=1&rel=0', watchUrl: 'https://youtu.be/' + id };
        }
        // TikTok
        if (host === 'tiktok.com' || host === 'vm.tiktok.com') {
            const m = u.pathname.match(/\/video\/(\d+)/);
            if (m) return { ok: true, platform: 'tiktok', embedUrl: 'https://www.tiktok.com/embed/v2/' + m[1], watchUrl: s };
            // short vm.tiktok.com links can't be resolved client-side; accept as link-only
            return { ok: true, platform: 'tiktok', embedUrl: null, watchUrl: s };
        }
        // Instagram reels / posts
        if (host === 'instagram.com') {
            const m = u.pathname.match(/\/(reel|reels|p|tv)\/([A-Za-z0-9_-]+)/);
            if (m) return { ok: true, platform: 'instagram', embedUrl: 'https://www.instagram.com/' + (m[1] === 'reels' ? 'reel' : m[1]) + '/' + m[2] + '/embed', watchUrl: s };
            return { ok: false, reason: 'Use a direct Instagram Reel or post link.' };
        }
        // Facebook videos, reels, and fb.watch — embedded via Facebook's video plugin player.
        if (host === 'facebook.com' || host === 'm.facebook.com' || host === 'fb.watch' || host === 'fb.com') {
            const isVid = host === 'fb.watch' || /\/(videos|reel|watch|story\.php|share\/v|share\/r)/.test(u.pathname) || u.searchParams.get('v');
            if (isVid) return { ok: true, platform: 'facebook', embedUrl: 'https://www.facebook.com/plugins/video.php?href=' + encodeURIComponent(s) + '&autoplay=1&mute=1&width=560', watchUrl: s };
            return { ok: false, reason: 'Use a direct Facebook video or Reel link.' };
        }
        return { ok: false, reason: 'Only YouTube, TikTok, Instagram, and Facebook clip links are supported.' };
    } catch (e) { return { ok: false, reason: 'That does not look like a valid link.' }; }
};

const validateSocialLink = (raw) => {
    try {
        let s = (raw || '').trim();
        if (!s) return { ok: false, reason: 'Empty link.' };
        if (!/^https?:\/\//i.test(s)) s = 'https://' + s;
        const u = new URL(s);
        if (u.protocol !== 'https:') return { ok: false, reason: 'Only https:// links are allowed.' };
        if (u.username || u.password) return { ok: false, reason: 'Links with embedded credentials are blocked.' };
        const host = u.hostname.toLowerCase().replace(/^www\./, '');
        if (/^\d+\.\d+\.\d+\.\d+$/.test(host)) return { ok: false, reason: 'Raw IP links are blocked.' };
        if (BLOCKED_SHORTENERS.some(b => host === b || host.endsWith('.' + b))) return { ok: false, reason: 'Link shorteners are blocked — they can hide redirects to scam sites.' };
        const allowed = SAFE_SOCIAL_HOSTS.some(h => host === h || host.endsWith('.' + h));
        if (!allowed) return { ok: false, reason: 'Banners may only link to verified social platforms (Instagram, TikTok, X, YouTube, Twitch, SoundCloud, etc).' };
        const qs = (u.search + u.hash).toLowerCase();
        if (qs.includes('http%3a') || qs.includes('http://') || qs.includes('https://') || qs.includes('url=') || qs.includes('redirect')) return { ok: false, reason: 'Links containing redirect parameters are blocked.' };
        return { ok: true, clean: u.toString() };
    } catch (e) { return { ok: false, reason: 'That does not look like a valid link.' } }
};

// V37.13: simple chat encryption (per owner spec: lightweight for Alpha, upgradeable later).
// Message text is XOR-ciphered with a key derived from both participant UIDs, then base64'd
// before it ever leaves the device — stored ciphertext is unreadable at a glance.
const rkKey = (a, b) => { const s = [a, b].sort().join('|') + '|rkV1'; let h = 0; for (let i = 0; i < s.length; i++) { h = ((h << 5) - h + s.charCodeAt(i)) | 0; } return Math.abs(h).toString(36) + s.length; };
const rkEnc = (text, key) => { try { let out = ''; for (let i = 0; i < text.length; i++) { out += String.fromCharCode(text.charCodeAt(i) ^ key.charCodeAt(i % key.length)); } return btoa(unescape(encodeURIComponent(out))); } catch (e) { try { return btoa(text); } catch (e2) { return text; } } };
const rkDec = (b64, key) => { try { const raw = decodeURIComponent(escape(atob(b64))); let out = ''; for (let i = 0; i < raw.length; i++) { out += String.fromCharCode(raw.charCodeAt(i) ^ key.charCodeAt(i % key.length)); } return out; } catch (e) { return '[unreadable]'; } };

// V47 Vibe Tribe: friend system. Friends are mutual uid arrays on each user doc.
export const sendFriendRequest = async (fromUid, fromName, fromPublicUid, toUid) => {
    if (!fromUid || !toUid || fromUid === toUid) return;
    // Persist the outgoing request on the sender's own doc so the button state survives a
    // refresh and can be cancelled. Then notify the recipient.
    await setDoc(doc(db, 'artifacts', appId, 'users', fromUid), { sentFriendReqs: arrayUnion(toUid) }, { merge: true });
    await pushNotif(toUid, 'friendreq', '🤝 @' + (fromName || 'A raver') + ' wants to add you as a friend! Tap to accept.', fromUid);
};
// Cancel/unsend a pending outgoing friend request. Removes it from the sender's doc and best-
// effort deletes the pending notification on the recipient's side.
export const cancelFriendRequest = async (fromUid, toUid) => {
    if (!fromUid || !toUid) return;
    await setDoc(doc(db, 'artifacts', appId, 'users', fromUid), { sentFriendReqs: arrayRemove(toUid) }, { merge: true });
    try {
        const q = query(collection(db, 'artifacts', appId, 'users', toUid, 'notifications'), where('type', '==', 'friendreq'), where('refId', '==', fromUid));
        const snap = await getDocs(q);
        snap.forEach(d => deleteDoc(d.ref).catch(() => {}));
    } catch (e) {}
};
export const acceptFriend = async (myUid, otherUid) => {
    if (!myUid || !otherUid) return;
    const a = doc(db, 'artifacts', appId, 'users', myUid);
    const b = doc(db, 'artifacts', appId, 'users', otherUid);
    await setDoc(a, { friends: arrayUnion(otherUid) }, { merge: true });
    await setDoc(b, { friends: arrayUnion(myUid) }, { merge: true });
    // Clear any pending request both directions now that they're friends.
    await setDoc(a, { sentFriendReqs: arrayRemove(otherUid) }, { merge: true }).catch(() => {});
    await setDoc(b, { sentFriendReqs: arrayRemove(myUid) }, { merge: true }).catch(() => {});
};
// V47: Obliterate — mutual chat deletion. Either user can request; a 24h countdown starts.
// If BOTH accept, the whole thread + messages are wiped. If the timer ends with only one
// acceptance, it auto-deletes anyway (the requester's intent stands).
export const requestObliterate = async (tid, byUid, otherUid, byName) => {
    const tRef = doc(db, 'artifacts', appId, 'public', 'data', 'threads', tid);
    const deadline = Date.now() + 86400000;
    await setDoc(tRef, { obliterate: { requestedBy: byUid, deadline, accepted: { [byUid]: true } } }, { merge: true });
    await pushNotif(otherUid, 'message', '💥 @' + (byName || 'A raver') + ' started OBLITERATE — this chat self-destructs in 24h. Open the chat to agree, or it deletes when the timer ends.', null);
};
export const acceptObliterate = async (tid, myUid) => {
    const tRef = doc(db, 'artifacts', appId, 'public', 'data', 'threads', tid);
    await setDoc(tRef, { obliterate: { accepted: { [myUid]: true } } }, { merge: true });
};
export const cancelObliterate = async (tid) => {
    const tRef = doc(db, 'artifacts', appId, 'public', 'data', 'threads', tid);
    await updateDoc(tRef, { obliterate: deleteField() }).catch(()=>{});
};
export const performObliterate = async (tid) => {
    try {
        const msgsSnap = await getDocs(collection(db, 'artifacts', appId, 'public', 'data', 'threads', tid, 'messages'));
        const batch = writeBatch(db);
        msgsSnap.docs.forEach(d => batch.delete(d.ref));
        await batch.commit();
        await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'threads', tid));
    } catch (e) { console.log('obliterate', e); }
};

// V53.2 Vibe Tribe groups: friends form a named group with a shared chat. New members need
// a 2/3 vote of existing members to join. Tribes live at public/data/tribes/{tribeId}.
export const createTribe = async (creatorUid, creatorName, tribeName) => {
    if (!creatorUid || !tribeName || !tribeName.trim()) throw new Error('Name required');
    const ref = await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tribes'), {
        name: tribeName.trim().slice(0, 40),
        creatorUid,
        members: [creatorUid],
        memberNames: { [creatorUid]: creatorName || 'Raver' },
        createdAt: Date.now(),
        memberCount: 1,
        pendingVotes: {} // { candidateUid: { name, votes: [uid,...], needed: N } }
    });
    return ref.id;
};
// Propose a friend to join. Records the proposer's vote immediately.
export const proposeToTribe = async (tribeId, candidateUid, candidateName, proposerUid) => {
    const ref = doc(db, 'artifacts', appId, 'public', 'data', 'tribes', tribeId);
    const snap = await getDoc(ref);
    if (!snap.exists()) throw new Error('Tribe not found');
    const t = snap.data();
    if ((t.members || []).includes(candidateUid)) throw new Error('Already a member');
    const memberCount = (t.members || []).length;
    const needed = Math.ceil((memberCount * 2) / 3); // 2/3 of existing members
    const pending = { ...(t.pendingVotes || {}) };
    pending[candidateUid] = { name: candidateName || 'Raver', votes: [proposerUid], needed };
    await updateDoc(ref, { pendingVotes: pending });
    // notify other members to vote
    (t.members || []).filter(m => m !== proposerUid).forEach(m => pushNotif(m, 'friendreq', '🗳️ Vote: should @' + (candidateName || 'a raver') + ' join your "' + t.name + '" Vibe Tribe? Open Vibe Tribe to vote.', tribeId));
    return needed;
};
// Cast a vote; if the threshold is met, the candidate is added + joins the group chat.
export const voteForTribeMember = async (tribeId, candidateUid, voterUid) => {
    const ref = doc(db, 'artifacts', appId, 'public', 'data', 'tribes', tribeId);
    const snap = await getDoc(ref);
    if (!snap.exists()) throw new Error('Tribe not found');
    const t = snap.data();
    const pending = { ...(t.pendingVotes || {}) };
    const entry = pending[candidateUid];
    if (!entry) throw new Error('No pending vote for this raver');
    if (!entry.votes.includes(voterUid)) entry.votes.push(voterUid);
    if (entry.votes.length >= entry.needed) {
        // approved — add member
        const newMembers = [...(t.members || []), candidateUid];
        const newNames = { ...(t.memberNames || {}), [candidateUid]: entry.name };
        delete pending[candidateUid];
        await updateDoc(ref, { members: newMembers, memberNames: newNames, memberCount: newMembers.length, pendingVotes: pending });
        pushNotif(candidateUid, 'friendreq', '🎉 You were voted into the "' + t.name + '" Vibe Tribe! Open Vibe Tribe to see your group chat.', tribeId);
        return 'approved';
    } else {
        pending[candidateUid] = entry;
        await updateDoc(ref, { pendingVotes: pending });
        return 'voted';
    }
};
export const leaveTribe = async (tribeId, myUid) => {
    const ref = doc(db, 'artifacts', appId, 'public', 'data', 'tribes', tribeId);
    const snap = await getDoc(ref);
    if (!snap.exists()) return;
    const t = snap.data();
    const newMembers = (t.members || []).filter(m => m !== myUid);
    const newNames = { ...(t.memberNames || {}) }; delete newNames[myUid];
    if (newMembers.length === 0) { await deleteDoc(ref); return; }
    await updateDoc(ref, { members: newMembers, memberNames: newNames, memberCount: newMembers.length });
};
// Send a message to the tribe group chat (stored as a subcollection).
export const sendTribeMessage = async (tribeId, fromUid, fromName, text, badgeObj, extra) => {
    if (!text || !text.trim()) return;
    await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tribes', tribeId, 'messages'), {
        sender: fromUid, senderName: fromName || 'Raver', text: text.trim().slice(0, 1000), at: Date.now(), badge: badgeObj || null,
        style: (extra && extra.style) || null, photoURL: (extra && extra.photoURL) || '', publicUid: (extra && extra.publicUid) || fromUid
    });
    // track for achievements (best-effort)
    try { await setDoc(doc(db, 'artifacts', appId, 'users', fromUid), { tribeMessages: increment(1) }, { merge: true }); } catch (e) {}
};

export const removeFriend = async (myUid, otherUid) => {
    if (!myUid || !otherUid) return;
    await setDoc(doc(db, 'artifacts', appId, 'users', myUid), { friends: arrayRemove(otherUid) }, { merge: true });
    await setDoc(doc(db, 'artifacts', appId, 'users', otherUid), { friends: arrayRemove(myUid) }, { merge: true });
};

export const pushNotif = async (toUid, type, text, refId = null) => {
    if (!toUid || toUid === 'guest') return;
    try { await addDoc(collection(db, 'artifacts', appId, 'users', toUid, 'notifications'), { type, text, refId, read: false, at: Date.now() }); } catch (e) {}
};

export const sendDirectMessage = async (fromUid, fromName, toUid, toName, text, styleObj = null, badgeObj = null) => {
    const tid = [fromUid, toUid].sort().join('_');
    const key = rkKey(fromUid, toUid);
    const enc = rkEnc(text, key);
    const tRef = doc(db, 'artifacts', appId, 'public', 'data', 'threads', tid);
    await setDoc(tRef, { participants: [fromUid, toUid].sort(), names: { [fromUid]: fromName || 'Raver', [toUid]: toName || 'Raver' }, lastMessage: enc, lastAt: Date.now(), lastSender: fromUid, unread: { [toUid]: increment(1) } }, { merge: true });
    await addDoc(collection(tRef, 'messages'), { sender: fromUid, text: enc, at: Date.now(), ts: styleObj || null, badge: badgeObj || null });
    // V47: respect recipient's message-notification preference
    try { const rSnap = await getDoc(doc(db, 'artifacts', appId, 'users', toUid)); if (!rSnap.exists() || rSnap.data().msgNotifs !== false) pushNotif(toUid, 'message', (fromName || 'Someone') + ' sent you a message', tid); }
    catch (e) { pushNotif(toUid, 'message', (fromName || 'Someone') + ' sent you a message', tid); }
    return tid;
};

export const ensureUserExists = async (uid, customName = null, referrerUid = null) => {
    if (!uid) return;
    const userRef = doc(db, 'artifacts', appId, 'users', uid);
    try {
        // STEP 1 — create the user's OWN document. This is the only write that must
        // succeed for an account to exist, and it only touches the user's own doc
        // (which the rules always allow them to create). Nothing else can block it.
        const existing = await getDoc(userRef);
        if (existing.exists()) return; // already set up
        // Best-effort: read the global counter for a nice sequential default name.
        // If we can't read it, fall back to a timestamp-based name — never block.
        let currentCount = 0;
        try { const gs = await getDoc(doc(db, 'artifacts', appId, 'global', 'stats')); if (gs.exists()) currentCount = gs.data().userCount || 0; } catch (e) {}
        const newUsername = customName || `Raver${String(currentCount).padStart(2, '0')}`;
        await setDoc(userRef, {
            displayName: newUsername, publicUid: uid, publicUidChanged: false, pastPublicUids: [],
            usernameChangesLeft: 3, pastUsernames: [], joined: Date.now(), items: [], totalSalesValue: 0, totalBoughtValue: 0,
            itemsSold: 0, itemsBought: 0, totalLikes: 0, totalComments: 0, badgesCollected: 0,
            referrals: 0, completedTrades: 0, socialInteractions: 0, aiUsageCount: 0, lastAiReset: 0,
            referredBy: referrerUid || null, totalRevShareEarned: 0, customCommissionRate: null,
            isVIP: false, customBackground: null, showPing: true, featuredBadge: null, customRevSharePct: null, bannedUntil: null, textStyle: null, msgTextStyle: null, friends: [], msgPrivacy: 'all', msgNotifs: true
        });

        // STEP 2 — best-effort side writes. Each is isolated so a permissions error on
        // ANY of them can never undo the account that was just created above.
        try { const gsRef = doc(db, 'artifacts', appId, 'global', 'stats'); const gs = await getDoc(gsRef); if (gs.exists()) await updateDoc(gsRef, { userCount: increment(1) }); else await setDoc(gsRef, { userCount: currentCount + 1 }); } catch (e) { console.log('stats bump skipped', e); }

        if (referrerUid) {
            try {
                const refRef = doc(db, 'artifacts', appId, 'users', referrerUid);
                const refDoc = await getDoc(refRef);
                if (refDoc.exists()) {
                    await updateDoc(refRef, { referrals: (refDoc.data().referrals || 0) + 1 });
                    try { await setDoc(doc(db, 'artifacts', appId, 'users', referrerUid, 'myReferrals', uid), { uid, displayName: newUsername, earnedFromThisUser: 0, timestamp: Date.now() }); } catch (e) {}
                    pushNotif(referrerUid, 'referral', '🎉 ' + newUsername + ' just joined RaveKandi using your code! +1 referral');
                }
            } catch (e) { console.log('referral credit skipped', e); }
        }
    } catch (e) { console.error("User Creation Error", e); throw e; }
};

// V42.16: handles images (canvas-compressed) AND videos (read as-is). Previously
// fed videos into new Image() whose onload never fires -> upload hung forever at
// "Processing Media". Now resolves for both, never hangs (img errors reject), and
// rejects oversized media that would blow past Firestore's ~1MB document limit.
const MAX_MEDIA_BYTES = 900000; // ~0.9MB base64 ceiling for a Firestore doc field
const compressImage = (file, onProgress) => new Promise((resolve, reject) => {
    const isVideo = file.type.startsWith('video/');
    if (isVideo) {
        // Videos can't be canvas-compressed. Base64-inlining video into Firestore is
        // not viable (size), so reject with a clear, actionable message.
        return reject(new Error('Video uploads on posts aren\'t supported yet — they\'re too large to store. Share festival video clips via the homepage Festival Spotlight (YouTube/TikTok/Instagram link) instead, and use an image here.'));
    }
    const reader = new FileReader();
    reader.onprogress = (data) => { if (data.lengthComputable && onProgress) onProgress(parseInt(((data.loaded / data.total) * 50), 10)); };
    reader.onerror = () => reject(new Error('Could not read that file. Try a different image (JPG or PNG).'));
    reader.onload = (e) => {
        if (onProgress) onProgress(60);
        const img = new Image();
        img.onerror = () => reject(new Error('That image format isn\'t supported. iPhone HEIC photos often fail — save as JPG or take a screenshot, then upload that.'));
        img.onload = () => {
            try {
                if (onProgress) onProgress(80);
                const cvs = document.createElement('canvas');
                const scale = Math.min(1, 800 / img.width);
                cvs.width = img.width * scale; cvs.height = img.height * scale;
                cvs.getContext('2d').drawImage(img, 0, 0, cvs.width, cvs.height);
                let q = 0.6, result = cvs.toDataURL('image/jpeg', q);
                while (result.length > MAX_MEDIA_BYTES && q > 0.25) { q -= 0.1; result = cvs.toDataURL('image/jpeg', q); }
                if (result.length > MAX_MEDIA_BYTES) return reject(new Error('That image is too large even after compression — please use a smaller one.'));
                if (onProgress) onProgress(100);
                resolve(result);
            } catch (err) { reject(err); }
        };
        img.src = e.target.result;
    };
    reader.readAsDataURL(file);
});

// V50: universal rave-creation analyzer. Handles ANY rave-scene item (kandi, clothing,
// jewelry, accessories, equipment, stickers, etc.). Returns a full cost/time/difficulty
// breakdown including materials with fabric detection, a creation fee scaled by difficulty,
// and a suggested sale price with a healthy profit margin. Text-only (image generation is
// disabled for now — see UI note).
const generateCustomKandi = async (prompt, onProgress = () => {}) => {
    try {
        const safePrompt = encodeURIComponent(prompt.substring(0, 300));
        // A detailed instruction so the model classifies the item and returns rich structured data.
        const instruction = encodeURIComponent(
            "You are a master maker for the rave and festival scene — you make kandi, clothing, jewelry, accessories, equipment, stickers and more. " +
            "Analyze the user's requested creation and return ONLY a JSON object with NO MARKDOWN. " +
            "Determine the item category, the materials and fabrics needed (with realistic quantities and a rough per-unit material cost in USD), " +
            "the difficulty (1-10), the estimated hands-on creation time, and a fair total material cost. " +
            'Format exactly: {"item_category":"e.g. Clothing/Kandi/Jewelry/Accessory/Equipment/Sticker","visual_description":"vivid 1-2 sentence description","materials":[{"name":"material or fabric","qty":"amount","unit_cost_usd":2.5}],"primary_fabric":"main fabric if applicable or N/A","difficulty_1_to_10":6,"estimated_time_hours":2.5,"total_material_cost_usd":18.0,"skill_notes":"short note on what makes it easy/hard"}'
        );
        const textUrl = `https://text.pollinations.ai/prompt/${instruction}.%20The%20user%20wants:%20${safePrompt}`;

        onProgress(15);
        let rawText = '';
        for (let tAttempt = 0; tAttempt < 4; tAttempt++) {
            onProgress(15 + tAttempt * 18);
            try {
                const response = await fetch(textUrl, { cache: 'no-store' });
                if (response.ok) { rawText = await response.text(); if (rawText && rawText.length > 5) break; }
            } catch (tErr) { console.log('AI analysis attempt ' + (tAttempt + 1) + ' failed.'); }
            await new Promise(r => setTimeout(r, 3500));
        }
        if (!rawText) throw new Error("ANALYSIS_FAILED");

        let analysis;
        try {
            const cleanText = rawText.replace(/```json/g, '').replace(/```/g, '').trim();
            const jsonMatch = cleanText.match(/\{[\s\S]*\}/);
            analysis = JSON.parse(jsonMatch ? jsonMatch[0] : cleanText);
        } catch (parseError) {
            console.warn("AI returned malformed JSON. Using structural fallback.", rawText);
            analysis = {
                item_category: "Custom",
                visual_description: prompt.substring(0, 150),
                materials: [{ name: "Assorted materials", qty: "as needed", unit_cost_usd: 1.5 }],
                primary_fabric: "N/A",
                difficulty_1_to_10: 5,
                estimated_time_hours: 2,
                total_material_cost_usd: 12,
                skill_notes: "Estimate based on a moderate build."
            };
        }

        // V37.14: pre-fetch with 6 retries (~60s budget) and progress reporting.
        // Pollinations generates on first request and can take a full minute while queued.
        onProgress(32);
        let displayUrl = imageUrl;
        let permanentData = '';
        for (let attempt = 0; attempt < 6; attempt++) {
            onProgress(Math.min(90, 36 + attempt * 9));
            try {
                const imgResp = await fetch(imageUrl, { cache: 'no-store' });
                if (imgResp.ok) {
                    const blob = await imgResp.blob();
                    if (blob && blob.size > 2000) {
                        // V42.28: read to a PERMANENT base64 data URL — stored in our DB so the
                        // image loads forever and never re-hits flaky/expiring Pollinations URLs.
                        try { permanentData = await new Promise((resolve, reject) => { const fr = new FileReader(); fr.onloadend = () => resolve(fr.result); fr.onerror = reject; fr.readAsDataURL(blob); }); } catch (e) { permanentData = ''; }
                        displayUrl = permanentData || URL.createObjectURL(blob);
                        break;
                    }
                }
            } catch (imgErr) { console.log('AI image attempt ' + (attempt + 1) + ' failed, retrying...'); }
            await new Promise(r => setTimeout(r, 8000));
        }
        onProgress(95);

        // ---- Cost model ----
        const diff = Math.max(1, Math.min(10, parseInt(analysis.difficulty_1_to_10) || 5));
        const timeHrs = Math.max(0.25, parseFloat(analysis.estimated_time_hours) || 1.5);
        // Material cost: prefer the model's total; otherwise sum the per-material unit costs.
        let materialCost = parseFloat(analysis.total_material_cost_usd) || 0;
        if (!materialCost && Array.isArray(analysis.materials)) {
            materialCost = analysis.materials.reduce((sum, m) => sum + (parseFloat(m.unit_cost_usd) || 0), 0);
        }
        if (!materialCost) materialCost = 8;
        // Creation/labor fee: a base hourly that scales UP with difficulty (harder = more per hour),
        // so complex builds earn heavy margins. ~$12/hr at diff 1 up to ~$30/hr at diff 10.
        const hourlyRate = 12 + (diff - 1) * 2;
        const creationFee = timeHrs * hourlyRate;
        // Difficulty surcharge for very complex pieces (extra profit room).
        const complexitySurcharge = diff >= 7 ? materialCost * (diff - 6) * 0.15 : 0;
        const subtotal = materialCost + creationFee + complexitySurcharge;
        // Healthy profit margin on top.
        let suggestedPrice = subtotal * PROFIT_MARGIN;
        if (suggestedPrice < 5) suggestedPrice = 5;

        return {
            ...analysis,
            difficulty: diff,
            estimated_time_hours: timeHrs,
            material_cost: materialCost.toFixed(2),
            creation_fee: creationFee.toFixed(2),
            complexity_surcharge: complexitySurcharge.toFixed(2),
            estimated_cost: suggestedPrice.toFixed(2), // suggested SALE price
            // no image in this version
            permanentImage: '', imageUrl: '', displayUrl: ''
        };
    } catch (e) { if (e.message === 'ANALYSIS_FAILED') throw e; throw new Error("AI Analysis Failed: " + e.message); }
};

const getDisplayAchievements = (profile) => {
    const stats = {
        totalItems: profile?.items?.length || profile?.itemsSold || 0,
        totalSalesValue: profile?.totalSalesValue || 0, totalBoughtValue: profile?.totalBoughtValue || 0,
        itemsSold: profile?.itemsSold || 0, itemsBought: profile?.itemsBought || 0,
        totalLikes: profile?.totalLikes || 0, totalComments: profile?.totalComments || 0,
        isKandiCreator: profile?.isKandiCreator?1:0, socialInteractions: profile?.socialInteractions||0, bioLinkAdded: profile?.bioLinkAdded?1:0,
        referrals: profile?.referrals||0, completedTrades: profile?.completedTrades||0,
        radioMinutes: profile?.radioMinutes||0, activeMinutes: profile?.activeMinutes||0,
        topCreatorUnlocked: profile?.topCreatorUnlocked?1:0, bannerPosts: profile?.bannerPosts||0,
        boostsUsed: profile?.boostsUsed||0, videosPosted: profile?.videosPosted||0,
        achievementsUnlocked: profile?.achievementsUnlocked||0,
        friendsCount: (profile?.friends || []).length,
        tribesJoined: profile?.tribesJoined||0, tribeMessages: profile?.tribeMessages||0, biggestTribe: profile?.biggestTribe||0
    };
    return ACHIEVEMENT_TIERS.map(ach => ({ ...ach, unlocked: (stats[ach.metric]||0) >= ach.threshold }));
};
EOF

# Block 6
cat << 'EOF' >> src/App.js
const LoadingBar = ({ progress = 100, className = '' }) => (
    <div className={`w-full h-1 bg-gray-800 rounded-full overflow-hidden mt-2 ${className}`}>
        <div className="h-full bg-gradient-to-r from-pink-500 via-purple-500 to-cyan-500 transition-all duration-300 ease-out" style={{ width: `${progress}%` }}></div>
    </div>
);

const MultiSelectDropdown = ({ options, selected, onChange }) => {
    const [open, setOpen] = useState(false);
    return (
        <div className="relative">
            <div onClick={() => setOpen(!open)} className="bg-white/10 border border-white/20 rounded p-1 text-[10px] h-7 cursor-pointer flex justify-between items-center overflow-hidden">
                <span className="truncate">{selected.length ? selected.join(', ') : 'All Types'}</span>
                <ChevronDown size={10}/>
            </div>
            {open && <div className="absolute top-full left-0 w-full bg-black border border-white/20 z-50 max-h-40 overflow-y-auto mt-1 rounded shadow-xl">
                {options.map(o => (
                    <div key={o} onClick={() => selected.includes(o) ? onChange(selected.filter(x => x !== o)) : onChange([...selected, o])} className="p-2 text-[10px] flex items-center gap-2 hover:bg-white/10 cursor-pointer">
                        <div className={`w-3 h-3 rounded border flex items-center justify-center ${selected.includes(o) ? 'bg-pink-500 border-pink-500' : 'border-white/30'}`}>{selected.includes(o) && <Check size={8}/>}</div>
                        {o}
                    </div>
                ))}
            </div>}
        </div>
    );
};

const Card = ({ children, className = '', glow = 'accentGlow' }) => ( <div className={`bg-white/5 backdrop-blur-sm p-4 rounded-xl border-2 border-opacity-30 transition-all duration-300 ${className}`} style={getBoxGlowStyle(glow)}>{children}</div> );

const Button = ({ children, onClick, disabled, className = '', color = 'primary', type = 'button' }) => {
    let c = NEON_COLORS[`${color}Glow`] || NEON_COLORS.primaryGlow;
    return ( <button type={type} onClick={onClick} disabled={disabled} className={`px-4 py-2 font-bold rounded-lg uppercase tracking-wider transition-all active:scale-95 ${disabled ? 'opacity-50 cursor-not-allowed' : 'hover:scale-[1.02]'} ${className}`} style={{ backgroundColor: 'rgba(0,0,0,0.3)', color: 'white', border: `2px solid ${c}`, boxShadow: `0 0 5px ${c}, 0 0 15px ${c} inset`, textShadow: `0 0 3px ${c}` }}>{children}</button> );
};

const Input = ({ label, value, onChange, type = 'text', options, className, placeholder, maxLength, disabled, autoComplete, name }) => { const ac = autoComplete || 'off'; const noFill = ac === 'off' ? { autoCorrect: 'off', autoCapitalize: 'off', spellCheck: false, 'data-lpignore': 'true', 'data-form-type': 'other' } : {}; return ( <div className={`mb-4 ${className}`}>{label && <label className="block text-sm font-bold mb-1" style={getTextGlowStyle('purpleGlow')}>{label}</label>}{type === 'select' ? (<select disabled={disabled} value={value} onChange={e => onChange(e.target.value)} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none text-white"><option value="">Select</option>{options.map(o => <option key={o} value={o} className="text-black">{o}</option>)}</select>) : type === 'textarea' ? (<textarea disabled={disabled} value={value} onChange={e => onChange(e.target.value)} rows="3" maxLength={maxLength} autoComplete={ac} {...noFill} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none" placeholder={placeholder}/>) : (<input name={name} autoComplete={ac} {...noFill} disabled={disabled} type={type} value={value} onChange={e => onChange(e.target.value)} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none" placeholder={placeholder}/>)}</div> ); };

const Modal = ({ isOpen, onClose, title, children, zClass = 'z-50', wide = false }) => { if (!isOpen) return null; return createPortal( <div className={"fixed inset-0 bg-black/90 overflow-y-auto " + zClass} onClick={(e) => e.stopPropagation()}><div className="flex min-h-full items-center justify-center p-4"><Card className={(wide ? "max-w-2xl" : "max-w-md") + " w-full my-4"} glow="primaryGlow"><div className="flex justify-between items-center mb-4 border-b border-white/20 pb-2"><h3 className="text-xl font-bold" style={getTextGlowStyle('primaryGlow')}>{title}</h3><button onClick={onClose}><XCircle/></button></div>{children}</Card></div></div>, document.body ); };

// V47 Vibe Tribe: add-friend / friend-status button usable on cards, profiles, search,
// and the messenger. Resolves the target's real uid (cards sometimes only have publicUid).
const AddFriendButton = ({ myProfile, myUid, targetUid, targetName, size = 'sm', className = '', showHint = false }) => {
    const [busy, setBusy] = useState(false);
    if (!myUid || !targetUid || targetUid === myUid || (myProfile?.publicUid && targetUid === myProfile.publicUid)) return null;
    const isFriend = (myProfile?.friends || []).includes(targetUid);
    // Pending state is read from the sender's own profile (persists across refresh).
    const pending = (myProfile?.sentFriendReqs || []).includes(targetUid);
    const pad = size === 'lg' ? 'text-xs py-1.5 px-3' : 'text-[9px] py-1 px-2';
    const icon = size==='lg'?14:11;
    if (isFriend) return <span className={`inline-flex items-center gap-1 rounded-full bg-lime-500/20 text-lime-300 border border-lime-400/40 font-bold ${pad} ${className}`}><Check size={icon}/> Friends</span>;
    const onClick = async (e) => {
        e.stopPropagation();
        if (busy) return; setBusy(true);
        try {
            if (pending) { await cancelFriendRequest(myUid, targetUid); }
            else { await sendFriendRequest(myUid, myProfile?.displayName || 'Raver', myProfile?.publicUid, targetUid); }
        } catch (err) {}
        setBusy(false);
    };
    return (
        <span className={`inline-flex flex-col items-center ${className}`}>
            <button onClick={onClick} disabled={busy}
                className={`inline-flex items-center gap-1 rounded-full font-bold transition active:scale-95 ${pending ? 'bg-white/10 text-white/60 border border-white/20' : 'bg-pink-600/30 text-pink-200 border border-pink-400/40 hover:bg-pink-600/50'} ${pad} ${size==='lg'?'w-full justify-center':''}`}>
                {pending ? <Clock size={icon}/> : <UserPlus size={icon}/>} {pending ? 'Request Sent' : 'Add Friend'}
            </button>
            {showHint && pending && <span className="text-[8px] text-white/40 mt-1">Tap the button to unsend request</span>}
        </span>
    );
};

// V42.29 Stage A: compact star rating shown above usernames. Reads ratingSum/ratingCount
// off a user/profile object. Renders nothing if the user has no ratings yet.
const UserRating = ({ sum, count, size = 'sm', center = false }) => {
    const c = count || 0;
    if (c <= 0) return null;
    const avg = (sum || 0) / c;
    const full = Math.round(avg);
    const txt = size === 'lg' ? 'text-sm' : 'text-[10px]';
    return (
        <div className={`flex items-center gap-1 ${center ? 'justify-center' : ''}`}>
            <span className={`${txt} tracking-tight`} style={{ color: '#ffd24a' }}>{'★'.repeat(full)}{'☆'.repeat(Math.max(0,5-full))}</span>
            <span className={`${txt} opacity-60`}>{avg.toFixed(1)} ({c})</span>
        </div>
    );
};

const MediaCarousel = ({ media, fallback }) => {
    const [idx, setIdx] = useState(0);
    const [zoom, setZoom] = useState(false);
    if (!media || media.length === 0) return <img src={fallback} onError={(e)=>{ if(e.target.src.indexOf('placehold')<0) e.target.src='https://placehold.co/400x300/1a0033/ff50b4?text=RaveKandi'; }} className="w-full h-full object-cover" />;
    const current = media[idx];
    return (
        <div className="relative group w-full h-full bg-black overflow-hidden flex items-center justify-center">
            {current.type === 'video' ? (
                <video src={current.url} controls autoPlay muted loop className="max-w-full max-h-full object-contain" />
            ) : (
                <img src={current.url} onClick={() => setZoom(true)} onError={(e)=>{ if(e.target.src.indexOf('placehold')<0) e.target.src='https://placehold.co/400x300/1a0033/ff50b4?text=RaveKandi'; }} className="max-w-full max-h-full object-contain cursor-zoom-in" />
            )}
            {current.type !== 'video' && <div className="absolute top-1.5 right-1.5 z-20 bg-black/60 rounded-full px-2 py-0.5 flex items-center gap-1 pointer-events-none opacity-80"><Maximize2 size={9} className="text-white"/><span className="text-[8px] text-white font-bold">tap to expand</span></div>}
            {zoom && current.type !== 'video' && (
                <div onClick={(e) => { e.stopPropagation(); setZoom(false); }} className="fixed inset-0 z-[100] bg-black/95 flex items-center justify-center p-4" style={{ touchAction: 'none' }}>
                    <button onClick={(e) => { e.stopPropagation(); setZoom(false); }} className="absolute top-4 right-4 z-[101] bg-white/10 rounded-full p-2 text-white hover:bg-white/20"><X size={24}/></button>
                    <img src={current.url} className="max-w-full max-h-full object-contain" onClick={(e) => e.stopPropagation()} />
                    {media.length > 1 && (
                        <>
                            <button onClick={(e)=>{e.stopPropagation(); setIdx((idx - 1 + media.length) % media.length);}} className="absolute left-3 top-1/2 -translate-y-1/2 z-[101] bg-white/10 rounded-full p-2 text-white hover:bg-white/20"><ChevronLeft size={28}/></button>
                            <button onClick={(e)=>{e.stopPropagation(); setIdx((idx + 1) % media.length);}} className="absolute right-3 top-1/2 -translate-y-1/2 z-[101] bg-white/10 rounded-full p-2 text-white hover:bg-white/20"><ChevronRight size={28}/></button>
                        </>
                    )}
                    <p className="absolute bottom-4 left-0 w-full text-center text-white/50 text-[10px]">Tap anywhere to close</p>
                </div>
            )}
            {media.length > 1 && (
                <>
                    <button onClick={(e)=>{e.stopPropagation(); setIdx((idx - 1 + media.length) % media.length);}} className="absolute left-1 top-1/2 -translate-y-1/2 z-20 bg-black/60 rounded-full p-1 text-white/80 hover:text-white"><ChevronLeft size={18}/></button>
                    <button onClick={(e)=>{e.stopPropagation(); setIdx((idx + 1) % media.length);}} className="absolute right-1 top-1/2 -translate-y-1/2 z-20 bg-black/60 rounded-full p-1 text-white/80 hover:text-white"><ChevronRight size={18}/></button>
                    <div className="absolute bottom-2 left-0 w-full flex justify-center gap-1 z-20">
                        {media.map((_, i) => <button key={i} onClick={(e)=>{e.stopPropagation(); setIdx(i);}} className={`w-2 h-2 rounded-full ${i===idx ? 'bg-pink-500' : 'bg-white/50'}`} />)}
                    </div>
                </>
            )}
        </div>
    );
};
EOF

# Block 7
cat << 'EOF' >> src/App.js
const CommentModal = ({ item, user, profile, isOpen, onClose, onViewProfile }) => {
    const [comment, setComment] = useState('');
    const [comments, setComments] = useState(item?.comments || []);
    useEffect(() => { setComments(item?.comments || []); }, [item]);
    
    const postComment = async () => { 
        if (!comment.trim() || !user?.uid) return; 
        const newComment = { text: comment, user: profile?.displayName || user.displayName || 'Raver', uid: profile?.publicUid || user.uid, badge: profile?.featuredBadge || null, time: Date.now(), ts: profile?.textStyle || null }; 
        await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { comments: arrayUnion(newComment) }); 
        if (item.ownerId && item.ownerId !== user.uid) pushNotif(item.ownerId, 'comment', (profile?.displayName || 'Someone') + ' commented on "' + item.name + '"', item.id);
        setComments([...comments, newComment]); 
        setComment(''); 
    };
    
    if (!isOpen || !item) return null;
    return ( 
        <Modal isOpen={isOpen} onClose={onClose} title="Comments">
            <div className="max-h-60 overflow-y-auto mb-4 space-y-2">
                {comments.map((c, i) => (
                    <div key={i} className="bg-white/5 p-2 rounded text-sm flex items-start justify-between gap-2">
                        <div className="flex-1"><span className="font-bold text-pink-400 cursor-pointer hover:underline" onClick={() => { onClose(); onViewProfile(c.uid); }}>{c.user}</span><BadgeChip badge={c.badge} />: <span className={getUserTextStyle(c.ts).className} style={getUserTextStyle(c.ts).style}>{c.text}</span></div>
                        {profile?.isAdmin && (
                            <div className="flex gap-1 shrink-0">
                                <button onClick={() => adminDeleteComment(item, c)} className="text-red-400 hover:text-red-300 p-0.5" title="Admin: delete comment"><Trash size={12}/></button>
                                <button onClick={() => adminBanUser(c.uid, c.user, 604800000, '7 days')} className="text-orange-400 hover:text-orange-300 p-0.5" title="Admin: ban commenter 7d"><Ban size={12}/></button>
                            </div>
                        )}
                    </div>
                ))}
            </div>
            <div className="flex gap-2">
                <Input value={comment} onChange={setComment} placeholder="Spread PLUR..." className="mb-0 flex-1"/>
                <Button onClick={postComment} color="lime">Post</Button>
            </div>
        </Modal> 
    );
};

const UsernameModal = ({ user, profile, isOpen, onClose }) => {
    const [u, setU] = useState('');
    const [loading, setLoading] = useState(false);
    const changesLeft = profile?.usernameChangesLeft ?? 3;
    const lastChange = profile?.lastUsernameChange || 0;
    const pastNames = profile?.pastUsernames || [];
    const cooldownOver = Date.now() - lastChange > (30 * 24 * 60 * 60 * 1000);
    const canChange = changesLeft > 0 || cooldownOver;
    const daysLeft = Math.ceil((lastChange + (30 * 24 * 60 * 60 * 1000) - Date.now()) / (1000 * 60 * 60 * 24));
    
    const sub = async () => { 
        const nu = (u || '').trim();
        if(!nu || nu.length < 3) return alert("Min 3 characters");
        setLoading(true);
        try {
            let newChangesLeft = changesLeft;
            let newLastChange = lastChange;
            if(changesLeft > 0) { newChangesLeft -= 1; if(newChangesLeft === 0) newLastChange = Date.now(); } 
            else if (cooldownOver) { newLastChange = Date.now(); }

            // V52.0.6: STEP 1 — save the user's OWN name first, on its own, with zero chance
            // of an undefined value. If the account never had a displayName (a broken-signup
            // account), the submitted name simply BECOMES the original — nothing is pushed to
            // history. Every field is coerced to a safe value.
            const hadName = profile && profile.displayName != null && profile.displayName !== '';
            const safePast = (pastNames || []).filter(n => n != null && n !== '');
            const newPastNames = hadName ? [...safePast, profile.displayName] : safePast; // no undefined ever
            const userRef = doc(db, 'artifacts', appId, 'users', user.uid);
            await setDoc(userRef, {
                displayName: nu,
                usernameChangesLeft: (newChangesLeft == null ? 3 : newChangesLeft),
                lastUsernameChange: (newLastChange == null ? 0 : newLastChange),
                pastUsernames: newPastNames,
                publicUid: profile?.publicUid || user.uid
            }, { merge: true });

            // STEP 2 — best-effort cross-app sync (posts, comments, inventory). Sanitized so
            // no undefined can reach Firestore; wrapped so a failure here can NEVER undo the
            // name change that already succeeded above.
            try {
                const batch = writeBatch(db);
                let writes = 0;
                const allPosts = await getDocs(query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems')));
                allPosts.forEach(docSnap => {
                    const data = docSnap.data();
                    const isOwner = data.ownerId === user.uid;
                    const rawComments = Array.isArray(data.comments) ? data.comments : [];
                    const hasMyComment = rawComments.some(c => c && (c.uid === user.uid || c.uid === profile?.publicUid));
                    if (!isOwner && !hasMyComment) return;
                    const upd = {};
                    if (isOwner) upd.ownerName = nu;
                    if (hasMyComment) {
                        // rebuild comments with sanitized objects (no undefined keys)
                        upd.comments = rawComments.map(c => {
                            if (!c) return c;
                            const isMine = c.uid === user.uid || c.uid === profile?.publicUid;
                            const safe = {
                                uid: c.uid ?? null,
                                user: isMine ? nu : (c.user ?? 'Raver'),
                                text: c.text ?? '',
                                time: c.time ?? Date.now()
                            };
                            if (c.badge != null) safe.badge = c.badge;
                            if (c.ts != null) safe.ts = c.ts;
                            return safe;
                        });
                    }
                    batch.update(docSnap.ref, upd); writes++;
                });
                const invs = await getDocs(query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory')));
                invs.forEach(d => { batch.update(d.ref, { ownerName: nu }); writes++; });
                if (writes > 0) await batch.commit();
            } catch (syncErr) { console.log('username cross-sync skipped:', syncErr); }

            alert("Username updated" + (hadName ? " and synced across the app!" : "! Welcome to RaveKandi 🌈")); 
            onClose();
        } catch(e) { alert("Error updating username: " + e.message); } finally { setLoading(false); }
    };

    if(!isOpen || !user?.uid) return null;
    return ( 
        <Modal isOpen={isOpen} onClose={onClose} title="Update Username">
            {canChange ? (
                <div>
                    <div className="bg-yellow-500/20 border border-yellow-500 p-2 rounded text-xs mb-4 text-yellow-200">
                        <AlertTriangle size={12} className="inline mr-1"/> You have <strong>{changesLeft}</strong> fast changes left before a 30-day cooldown triggers.
                    </div>
                    <Input value={u} onChange={setU} placeholder="New Username"/>
                    <Button onClick={sub} disabled={loading} color="lime" className="w-full">{loading ? "Updating All Posts..." : "Update Now"}</Button>
                </div>
            ) : (
                <div className="text-center py-4">
                    <Lock size={32} className="mx-auto text-red-400 mb-2"/>
                    <p className="text-red-400 font-bold">Name Locked</p>
                    <p className="text-xs opacity-70">Next change available in {daysLeft} days.</p>
                    <Button onClick={onClose} color="primary" className="mt-4">Close</Button>
                </div>
            )}
        </Modal> 
    );
};

const PublicProfileModal = ({ uid, onClose }) => {
    const [targ, setTarg] = useState(null);
    const [errMsg, setErrMsg] = useState('');
    useEffect(() => {
        setTarg(null); setErrMsg('');
        if(!uid) return;
        let cancelled = false;
        (async () => {
            // V42.12: direct doc-id lookup first (publicUid usually IS the doc id),
            // then fall back to a publicUid query for users who changed their UID.
            try {
                const direct = await getDoc(doc(db, 'artifacts', appId, 'users', uid));
                if (cancelled) return;
                if (direct.exists()) { setTarg({ ...direct.data(), id: direct.id }); return; }
            } catch (e) { console.log('profile direct load failed', e); }
            try {
                const snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', uid)));
                if (cancelled) return;
                if (!snap.empty) { setTarg({ ...snap.docs[0].data(), id: snap.docs[0].id }); return; }
                setTarg('not_found');
            } catch (e) {
                if (cancelled) return;
                console.log('profile query load failed', e);
                setErrMsg((e && e.message) || 'Unknown error');
                setTarg('error');
            }
        })();
        return () => { cancelled = true; };
    }, [uid]);
    if(!uid) return null;
    return (
        <Modal isOpen={!!uid} onClose={onClose} title={targ === 'not_found' ? "Not Found" : targ === 'error' ? "Connection Issue" : (targ?.displayName ? '@' + targ.displayName : 'Loading...')}>
            {targ === 'not_found' ? <p className="opacity-50 text-center">User no longer exists.</p>
            : targ === 'error' ? <p className="text-red-300 text-xs text-center py-4">Couldn't load this profile.{errMsg ? ' (' + errMsg + ')' : ''} Check your connection and try again.</p>
            : !targ ? <div className="py-6"><LoadingBar className="w-full"/><p className="text-center text-[10px] opacity-50 mt-2">Loading profile...</p></div> : (
                <div className="text-center space-y-4">
                    <img src={targ.photoURL || 'https://placehold.co/100?text=User'} className="w-24 h-24 rounded-full mx-auto object-cover border-2 border-pink-500"/>
                    <div>
                        <UserRating sum={targ.ratingSum} count={targ.ratingCount} center />
                        <p className="font-black text-lg flex items-center justify-center" style={getTextGlowStyle('primaryGlow')}>@{targ.displayName || 'Raver'}</p>
                        {targ.featuredBadge && <div className="flex justify-center mt-0.5"><BadgeChip badge={targ.featuredBadge} /></div>}
                        <p className="text-[9px] font-mono opacity-50">Friend UID: {targ.publicUid || targ.id}</p>
                    </div>
                    <p className="italic opacity-80 bg-white/5 p-2 rounded text-xs">{targ.bio || "No vibe check yet."}</p>
                    {SOCIAL_PLATFORMS.filter(p => targ.socialLinks?.[p.id]).length > 0 && (
                        <div className="flex justify-center gap-4 py-1">
                            {SOCIAL_PLATFORMS.filter(p => targ.socialLinks?.[p.id]).slice(0, 8).map(p => (
                                <button key={p.id} onClick={() => { try { window.open('https://' + p.baseUrl + targ.socialLinks[p.id], '_blank', 'noopener'); } catch (e) {} }} title={p.name} className="hover:scale-125 transition-transform"><p.icon size={18} color={p.color}/></button>
                            ))}
                        </div>
                    )}
                    <div className="grid grid-cols-2 gap-2 text-[10px]">
                        <div className="bg-black/50 p-2 rounded border border-white/10"><p className="text-lime-400 font-bold">{targ.itemsSold || 0}</p><p className="opacity-50 uppercase">Items Sold</p></div>
                        <div className="bg-black/50 p-2 rounded border border-white/10"><p className="text-cyan-400 font-bold">{targ.totalLikes || 0}</p><p className="opacity-50 uppercase">Total Likes</p></div>
                    </div>
                </div>
            )}
        </Modal>
    );
};
EOF

# Block 8
cat << 'EOF' >> src/App.js
const ReferralModal = ({ user, profile, isOpen, onClose }) => {
    const [refs, setRefs] = useState([]);
    const [search, setSearch] = useState('');
    const [retroCode, setRetroCode] = useState('');
    const [loading, setLoading] = useState(false);
    
    useEffect(() => {
        if(!isOpen || !user?.uid) return;
        const q = query(collection(db, 'artifacts', appId, 'users', user.uid, 'myReferrals'), orderBy('timestamp', 'desc'));
        return onSnapshot(q, s => setRefs(s.docs.map(d => ({...d.data(), id: d.id}))));
    }, [isOpen, user]);

    const submitRetroCode = async () => {
        if(!retroCode) return;
        if(retroCode === profile?.publicUid) return alert("You cannot refer yourself.");
        setLoading(true);
        try {
            const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', retroCode));
            const snap = await getDocs(q);
            if (snap.empty) { setLoading(false); return alert("Invalid Referral Code."); }
            const referrerUid = snap.docs[0].id;

            const batch = writeBatch(db);
            batch.update(doc(db, 'artifacts', appId, 'users', user.uid), { referredBy: referrerUid });
            batch.update(doc(db, 'artifacts', appId, 'users', referrerUid), { referrals: increment(1) });
            batch.set(doc(db, 'artifacts', appId, 'users', referrerUid, 'myReferrals', user.uid), {
                uid: user.uid, displayName: profile?.displayName || 'Raver', earnedFromThisUser: 0, timestamp: Date.now()
            });
            await batch.commit();
            pushNotif(referrerUid, 'referral', '🤝 ' + (profile?.displayName || 'A raver') + ' linked you as their referrer! +1 referral');
            alert("Referral code accepted!");
        } catch(e) { alert(e.message); } finally { setLoading(false); }
    };
    
    if(!isOpen) return null;
    const filtered = refs.filter(r => r.displayName?.toLowerCase().includes(search.toLowerCase()) || r.uid?.includes(search));
    
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="My Referrals">
            {!profile?.referredBy && (
                <div className="mb-4 bg-lime-900/20 border border-lime-500/50 p-3 rounded">
                    <p className="text-[10px] font-bold text-lime-400 mb-2">Were you referred by a friend? Enter their UID to link your account!</p>
                    <div className="flex gap-2">
                        <Input value={retroCode} onChange={setRetroCode} placeholder="Friend UID" className="mb-0 flex-1"/>
                        <Button onClick={submitRetroCode} disabled={loading} color="lime" className="text-[10px]">Submit</Button>
                    </div>
                </div>
            )}
            <div className="mb-4"><Input placeholder="Search UID or Name..." value={search} onChange={setSearch} className="mb-0"/></div>
            <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-1">
                {filtered.length === 0 && <p className="text-center opacity-50 py-4 text-xs">No referrals found.</p>}
                {filtered.map((r, i) => (
                    <div key={r.id} className="bg-white/5 p-3 rounded flex justify-between items-center border border-white/10">
                        <div><p className="font-bold text-xs text-pink-400">#{refs.length - i} {r.displayName}</p><p className="text-[10px] opacity-50">UID: {r.uid}</p></div>
                        <div className="text-right"><p className="text-[10px] uppercase opacity-70">Earned</p><p className="font-bold text-lime-400">${(r.earnedFromThisUser || 0).toFixed(2)}</p></div>
                    </div>
                ))}
            </div>
        </Modal>
    )
};

const CreatorApplicationForm = ({ user, onClose }) => {
    const [s, setS] = useState('form');
    const [d, setD] = useState({ name: '', email: '', social: '', portfolio: '', experience: '', yearsRaving: '< 1', yearsCreating: '< 1' });
    const [loading, setLoading] = useState(false);
    const [existingId, setExistingId] = useState(null);

    useEffect(() => {
        if(user?.uid && !user.isAnonymous) {
            getDocs(query(collection(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications'), where('uid', '==', user.uid))).then(snap => {
                if(!snap.empty) {
                    const docData = snap.docs[0];
                    if(docData.data().status === 'pending') { setD(docData.data()); setExistingId(docData.id); }
                    else { setS('success'); }
                }
            });
        }
    }, [user]);

    const sub = async () => { 
        if(user?.isAnonymous) return alert("Please authenticate an account to apply.");
        if(!d.name || !d.email || !user?.uid) return alert("Name and Email are required.");
        setLoading(true);
        try {
            if(existingId) { await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications', existingId), { ...d, updatedAt: Date.now() }); } 
            else { await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications'), { ...d, uid: user.uid, status: 'pending', submittedAt: Date.now() }); try { const adminsSnap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('isAdmin', '==', true))); adminsSnap.forEach(a => pushNotif(a.id, 'admin', '📋 New Creator application from ' + (d.name || 'a raver'))); } catch (e) {} }
            setS('success'); 
        } catch (e) { alert("Error: " + e.message); } finally { setLoading(false); }
    };
    if (!user || user?.isAnonymous) return (
        <Card glow="purpleGlow" className="max-w-md mx-auto mt-8 relative">
            {onClose && <button onClick={onClose} className="absolute top-2 right-2 text-white/50"><XCircle/></button>}
            <h3 className="text-xl font-bold mb-2">Creator Application</h3><p className="text-xs opacity-70">Please authenticate an account to apply.</p>
        </Card>
    );
    if (s === 'success') return (
        <Card glow="limeGlow" className="max-w-md mx-auto mt-8 text-center py-8 relative">
            {onClose && <button onClick={onClose} className="absolute top-2 right-2 text-white/50"><XCircle/></button>}
            <CheckCircle size={48} className="text-lime-400 mx-auto mb-4"/>
            <h3 className="text-xl font-bold mb-2 text-lime-400">Application Sent!</h3>
            <p className="text-xs opacity-70">Our team will review your portfolio and vibe check your socials. You will be notified soon.</p>
            <p className="text-[9px] text-cyan-300 mt-3">Tip: reopen the Apply window anytime to view or edit your submitted form.</p>
        </Card>
    );
    return (
        <Card glow="primaryGlow" className="max-w-md mx-auto text-left relative z-10 bg-black/60 backdrop-blur-md">
            {onClose && <button onClick={onClose} className="absolute top-2 right-2 text-white/50 z-20"><XCircle/></button>}
            <div className="flex items-center gap-3 mb-4 border-b border-white/20 pb-4 pr-6">
                <Hammer className="text-pink-500" size={28}/>
                <div><h3 className="text-xl font-black italic tracking-wider leading-none" style={getTextGlowStyle('primaryGlow')}>{existingId ? 'EDIT APP' : 'BECOME A CREATOR'}</h3><p className="text-[10px] opacity-70 mt-1">Unlock commissions & official drops</p></div>
            </div>
            {existingId && <div className="bg-cyan-900/20 border border-cyan-500/40 rounded p-2 mb-3"><p className="text-[9px] text-cyan-300">📋 This is your <strong>submitted application</strong> — review it or make edits anytime by reopening this Apply window.</p></div>}
            <div className="space-y-1">
                <Input label="Full Name / DJ Name" value={d.name} onChange={v=>setD({...d, name:v})}/>
                <Input label="Contact Email" type="email" value={d.email} onChange={v=>setD({...d, email:v})}/>
                <Input label="Main Social Link (IG/TikTok)" value={d.social} onChange={v=>setD({...d, social:v})}/>
                <Input label="Portfolio Link (Optional)" value={d.portfolio} onChange={v=>setD({...d, portfolio:v})}/>
                <div className="grid grid-cols-2 gap-2">
                    <Input label="Years in Scene" type="select" options={['< 1', '1-2', '3-5', '5-10', '10+']} value={d.yearsRaving} onChange={v=>setD({...d, yearsRaving:v})} />
                    <Input label="Years Crafting" type="select" options={['< 1', '1-2', '3-5', '5-10', '10+']} value={d.yearsCreating} onChange={v=>setD({...d, yearsCreating:v})} />
                </div>
                <Input type="textarea" label="Rave Experience & Kandi Style" value={d.experience} onChange={v=>setD({...d, experience:v})} placeholder="Tell us about your vibe and what you love creating..."/>
                <Button onClick={sub} disabled={loading} color="lime" className="w-full mt-4 shadow-neon-green text-lg py-3">{loading ? "Submitting..." : (existingId ? "Update Application" : "Submit Application")}</Button>
            </div>
        </Card>
    );
};

const KandiCreatorApplicationModal = ({ user, isOpen, onClose }) => { 
    if(!isOpen) return null;
    return ( <Modal isOpen={isOpen} onClose={onClose} title="Apply Now"><CreatorApplicationForm user={user} onClose={onClose} /></Modal> ); 
};

const EditSocialsModal = ({ user, profile, isOpen, onClose }) => {
    const [s, setS] = useState({});
    useEffect(()=>{if(profile?.socialLinks) setS(profile.socialLinks)},[profile]); 
    const sub = async () => { if(!user?.uid) return; await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { socialLinks: s }, { merge: true }); onClose(); };
    if(!isOpen) return null;
    return <Modal isOpen={isOpen} onClose={onClose} title="Socials">{SOCIAL_PLATFORMS.map(p=><div key={p.id} className="flex gap-2 mb-2"><p.icon size={16} color={p.color}/><Input value={s[p.id]||''} onChange={v=>setS({...s,[p.id]:v})} placeholder={`${p.name} Username`} className="mb-0 flex-1"/></div>)}<Button onClick={sub} color="lime">Save</Button></Modal>;
};

const BioModal = ({ user, currentBio, isOpen, onClose }) => {
    const [b, setB] = useState('');
    const [showTooltip, setShowTooltip] = useState(false);
    useEffect(() => { if(isOpen) setB(currentBio || ''); }, [isOpen, currentBio]);
    const sub = async () => { if(!user?.uid) return; await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { bio: b }, { merge: true }); onClose(); };
    if(!isOpen) return null; 
    return ( <Modal isOpen={isOpen} onClose={onClose} title="Bio"><div className="relative"><Input type="textarea" value={b} onChange={v => v.length <= BIO_CHAR_LIMIT && setB(v)} maxLength={BIO_CHAR_LIMIT}/><p className="text-right text-[10px] opacity-50 mb-2">{b.length}/{BIO_CHAR_LIMIT}</p><div className="flex items-center gap-2"><Button onClick={sub} color="lime" className="flex-1">Save</Button><div className="relative"><HelpCircle size={20} className="text-white/50 cursor-pointer" onClick={() => setShowTooltip(!showTooltip)}/>{showTooltip && <div className="absolute bottom-full right-0 mb-2 w-48 bg-black border border-white/20 p-2 rounded text-[10px] z-50">Bio can be anything, but no malicious, racist, or hateful content. This is a PLUR platform.</div>}</div></div></div></Modal> );
};

const VIPCheckoutForm = ({ user, onClose }) => {
    const stripe = useStripe();
    const elements = useElements();
    const [loading, setLoading] = useState(false);
    const [plan, setPlan] = useState('lifetime');

    const handleVIPSuccess = async (e) => {
        e.preventDefault();
        if (!stripe || !elements) return;
        if (!RK_CFG.checkoutEnabled) return alert(RK_CFG.maintenanceMessage || 'Checkout is temporarily disabled — try again soon!');
        if (RK_CFG.paymentsLive) return alert('Live payments are not wired into this build yet — keep "Payments LIVE" OFF in remote config until real billing ships.');
        setLoading(true);
        setTimeout(async () => {
            try {
                let vipExpires = null;
                if (plan === 'monthly') {
                    const cur = await getDoc(doc(db, 'artifacts', appId, 'users', user.uid));
                    const base = Math.max(Date.now(), cur.data()?.vipExpires || 0);
                    vipExpires = base + 2592000000; // renewals stack +30 days on remaining time
                }
                await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid), { isVIP: true, vipPlan: plan, vipSince: Date.now(), vipExpires });
                alert(plan === 'monthly' ? "VIP Monthly active until " + new Date(vipExpires).toLocaleDateString() + "! Renewing later stacks +30 days." : "VIP Lifetime unlocked! Enjoy 6 Profile Pins, Themes, Banner Messages, Post Boosts & the Font Selector forever.");
            } catch(err) { console.error(err); }
            setLoading(false);
            onClose();
        }, 1500);
    };

    if (RK_CFG.launchPerks) return (
        <div className="text-center space-y-4">
            <Crown size={48} className="mx-auto text-yellow-400 mb-2" />
            <div className="bg-lime-900/25 border-2 border-lime-400/70 rounded-xl p-4 text-left space-y-2">
                <p className="text-sm font-black text-lime-300 uppercase tracking-wide">🎉 Launch Special — VIP is FREE!</p>
                <p className="text-[11px] text-gray-100 leading-relaxed">As a thank-you for being part of the RaveKandi soft launch, <strong>every raver gets full VIP access at no cost</strong> — 6 Profile Pins, Custom Themes, Banner Messages, Post Boosts, the Font Selector, plus no chat cooldown and chat link &amp; collection sharing are unlocked for you right now. (Rave Radio is free for everyone, always!)</p>
                <p className="text-[11px] text-gray-100 leading-relaxed">🪙 Launch perk #2: <strong>seller commission is automatically cut from 20% to just 10%</strong> on every sale for as long as the launch period lasts.</p>
                <p className="text-[11px] text-yellow-200 leading-relaxed">🔒 <strong>Early Adopter Lock-In:</strong> sign up during the launch period and your VIP is <strong>permanent</strong> — you keep 6 Profile Pins, Themes, Banners, Boosts & the Font Selector forever. Your seller commission is also <strong>locked at 10% for life</strong>, even after launch ends and new sellers move to 20%.</p>
                <p className="text-[9px] opacity-60">Enjoy the festival! 💖</p>
            </div>
            <Button type="button" onClick={onClose} color="gold" className="w-full">Awesome — Let's Rave!</Button>
        </div>
    );
    return (
        <form onSubmit={handleVIPSuccess} className="text-center space-y-4">
            <Crown size={48} className="mx-auto text-yellow-400 mb-2" />
            <div className="text-left bg-white/5 p-3 rounded border border-white/10 text-[11px] space-y-1">
                <p className="font-bold text-yellow-400 uppercase text-[10px] tracking-widest mb-1">VIP unlocks:</p>
                <p>📌 6 Profile Pins (free tier gets 3)</p>
                <p>🖼️ Custom App Backgrounds & Themes</p>
                <p>📢 Banner Messages on the live marquee</p>
                <p>⚡ Post Boosts — pin your items to the top of the feed</p>
                <p>🔤 Font Selector for bio, posts & messages</p>
                <p>💬 No cooldown in Rave Radio chat (skip the anti-spam wait)</p>
                <p>🔗 Share your social links in chat (limited per day)</p>
                <p>📦 Share collection items directly in chat</p>
            </div>
            <div className="grid grid-cols-2 gap-2">
                <button type="button" onClick={() => setPlan('monthly')} className={`p-3 rounded-xl border-2 text-left ${plan === 'monthly' ? 'border-yellow-400 bg-yellow-500/10 shadow-[0_0_12px_rgba(250,204,21,0.4)]' : 'border-white/15 bg-white/5'}`}>
                    <p className="font-black text-sm">$4.99<span className="text-[9px] font-normal opacity-60">/month</span></p>
                    <p className="text-[8px] opacity-60 uppercase">Subscription</p>
                </button>
                <button type="button" onClick={() => setPlan('lifetime')} className={`p-3 rounded-xl border-2 text-left relative ${plan === 'lifetime' ? 'border-yellow-400 bg-yellow-500/10 shadow-[0_0_12px_rgba(250,204,21,0.4)]' : 'border-white/15 bg-white/5'}`}>
                    <span className="absolute -top-2 right-1 bg-lime-500 text-black text-[7px] font-black px-1 rounded uppercase">Best Value</span>
                    <p className="font-black text-sm">$20<span className="text-[9px] font-normal opacity-60"> once</span></p>
                    <p className="text-[8px] opacity-60 uppercase">Lifetime</p>
                </button>
            </div>
            <div className="bg-white/10 p-3 rounded border border-white/20 text-left">
                <CardElement options={{style:{base:{color:'#fff'}}}}/>
            </div>
            <Button type="submit" disabled={!stripe || loading} color="gold" className="w-full">
                {loading ? "Processing..." : plan === 'monthly' ? "Subscribe — $4.99/month" : "Pay $20 — Lifetime Access"}
            </Button>
            <p className="text-[8px] opacity-40">Payments are in TEST MODE during Alpha — no real charge occurs.</p>
        </form>
    );
};

const VIPCheckoutModal = ({ user, isOpen, onClose }) => {
    if(!isOpen) return null;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="Unlock VIP Ecosystem">
            <Elements stripe={stripePromise}>
                <VIPCheckoutForm user={user} onClose={onClose} />
            </Elements>
        </Modal>
    );
};

const FontSelectorModal = ({ user, profile, isOpen, onClose, field = 'textStyle', titleLabel = 'Font & Text Style', zClass = '' }) => {
    const saved = (profile && profile[field]) || {};
    const [font, setFont] = useState(saved.font || 'default');
    const [fx, setFx] = useState(saved.fx || 'none');
    const [c, setC] = useState(saved.c || '#ff2db3');
    const [c2, setC2] = useState(saved.c2 || '#2db3ff');
    const [bright, setBright] = useState(saved.bright || 100);
    const [saving, setSaving] = useState(false);
    if (!isOpen) return null;
    const ts = { font, fx, c, c2, bright };
    const prev = getUserTextStyle(ts);
    const save = async () => {
        setSaving(true);
        try { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { [field]: ts }, { merge: true }); onClose(); }
        catch (e) { alert('Could not save: ' + e.message); } finally { setSaving(false); }
    };
    const reset = async () => {
        setSaving(true);
        try { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { [field]: null }, { merge: true }); setFont('default'); setFx('none'); setBright(100); onClose(); }
        catch (e) {} finally { setSaving(false); }
    };
    const needsC = (RK_FX_USES_C.includes(fx) || RK_FX_USES_C2.includes(fx));
    const needsC2 = RK_FX_USES_C2.includes(fx);
    return (
        <Modal isOpen={isOpen} onClose={onClose} title={'🔤 ' + titleLabel} zClass={zClass}>
            <div className="space-y-3">
                <div className="bg-black/60 border-2 border-pink-500/40 rounded-xl p-4 text-center">
                    <p className="text-[9px] uppercase opacity-50 mb-2">Live Preview</p>
                    <p className={'text-2xl font-black ' + prev.className} style={prev.style}>RaveKandi PLUR 🌈</p>
                    <p className={'text-sm mt-1 ' + prev.className} style={prev.style}>The quick brown fox vibes all night</p>
                </div>
                <div>
                    <label className="text-[10px] font-bold text-cyan-400 uppercase block mb-1 flex items-center justify-between"><span>Font</span><span className="text-[8px] opacity-50 normal-case font-normal">scroll ↓</span></label>
                    <div className="grid grid-cols-3 gap-1 max-h-32 overflow-y-auto rk-scroll pr-2 overscroll-contain" style={{ WebkitOverflowScrolling: 'touch' }}>
                        {RK_FONTS.map(f => <button key={f.id} onClick={() => setFont(f.id)} style={{ fontFamily: f.stack }} className={'p-2 rounded text-[10px] border ' + (font === f.id ? 'border-pink-500 bg-pink-900/30' : 'border-white/15 bg-black/40')}>{f.name}</button>)}
                    </div>
                </div>
                <div>
                    <label className="text-[10px] font-bold text-cyan-400 uppercase block mb-1 flex items-center justify-between"><span>Effect</span><span className="text-[8px] opacity-50 normal-case font-normal">scroll ↓</span></label>
                    <div className="grid grid-cols-3 gap-1 max-h-32 overflow-y-auto rk-scroll pr-2 overscroll-contain" style={{ WebkitOverflowScrolling: 'touch' }}>
                        {RK_FX.map(f => {
                            const thumb = getUserTextStyle({ fx: f.id, c, c2 });
                            return <button key={f.id} onClick={() => setFx(f.id)} className={'p-2 rounded text-[10px] border font-black ' + (fx === f.id ? 'border-pink-500 bg-pink-900/30' : 'border-white/15 bg-black/40')}><span className={thumb.className} style={thumb.style}>{f.name}</span></button>;
                        })}
                    </div>
                </div>
                {needsC && (
                    <div className="bg-black/40 border border-cyan-500/20 rounded-lg p-3">
                        <p className="text-[9px] text-cyan-300/80 mb-2">🎨 {needsC2 ? 'This effect flows between your two chosen colors — pick them below.' : 'Pick the color for this effect below.'}</p>
                        <div className="flex items-center gap-3">
                            <label className="text-[10px] font-bold text-cyan-400 uppercase">{needsC2 ? 'Color 1' : 'Color'}</label>
                            <input type="color" value={c} onChange={e => setC(e.target.value)} className="w-12 h-9 rounded bg-transparent border border-white/20"/>
                            {needsC2 && <><label className="text-[10px] font-bold text-cyan-400 uppercase">Color 2</label><input type="color" value={c2} onChange={e => setC2(e.target.value)} className="w-12 h-9 rounded bg-transparent border border-white/20"/></>}
                        </div>
                    </div>
                )}
                <div>
                    <label className="text-[10px] font-bold text-cyan-400 uppercase block mb-1">Brightness ({bright}%)</label>
                    <input type="range" min="60" max="100" value={bright} onChange={e => setBright(parseInt(e.target.value))} className="w-full accent-pink-500"/>
                    <p className="text-[8px] opacity-50">Capped at 60–100% to keep text readable.</p>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <Button onClick={save} disabled={saving} color="lime" className="text-xs">{saving ? 'Saving…' : 'Save Style'}</Button>
                    <Button onClick={reset} disabled={saving} color="accent" className="text-xs">Reset to Default</Button>
                </div>
            </div>
        </Modal>
    );
};

const ThemeSelectorModal = ({ user, profile, isOpen, onClose }) => {
    const [url, setUrl] = useState(profile?.customBackground || '');
    const [uploading, setUploading] = useState(false);
    
    const handleFile = async (e) => {
        const file = e.target.files[0];
        if(!file || !user?.uid) return;
        setUploading(true);
        try {
            const base64 = await compressImage(file, null);
            setUrl(base64);
        } catch(err) { alert("Upload failed."); }
        setUploading(false);
    };

    const saveTheme = async () => {
        await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid), { customBackground: url });
        onClose();
    };

    if(!isOpen) return null;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="Custom Theming">
            <div className="space-y-4">
                <p className="text-xs opacity-70">Personalize your app background. Upload an image, paste an image URL, or paste a hosted <strong>video link</strong> for a live wallpaper.</p>
                <Input value={url} onChange={setUrl} placeholder="https://...image.jpg OR https://...video.mp4" />
                <div className="bg-white/5 p-3 rounded border border-white/10">
                    <label className="text-[10px] font-bold text-pink-400 mb-1 block">Upload Image Background</label>
                    <input type="file" accept="image/*" onChange={handleFile} className="text-[10px] w-full" disabled={uploading}/>
                    {uploading && <p className="text-[10px] text-lime-400 mt-1">Processing...</p>}
                    <p className="text-[8px] opacity-50 mt-1">Image upload only. For a video wallpaper, paste a hosted link above.</p>
                </div>
                <div className="bg-cyan-900/20 border border-cyan-500/30 rounded p-2.5">
                    <p className="text-[10px] text-cyan-200 leading-relaxed mb-1">🎥 <strong>Video live wallpapers:</strong> host your video somewhere (Imgur, Cloudinary, a Discord CDN link, etc.) and paste the direct <strong>.mp4 / .webm</strong> link above — it'll play as an animated background!</p>
                    <p className="text-[8px] opacity-50">Tip: keep videos short and small for smooth looping. The link must end in .mp4 or .webm.</p>
                </div>
                <p className="text-[9px] text-yellow-400 bg-yellow-900/20 border border-yellow-500/30 rounded p-2 text-center font-bold">⚠ You must press SAVE THEME for changes to apply — including after uploading an image or after clearing your theme.</p>
                <div className="flex gap-2">
                    <Button onClick={() => setUrl('')} color="red" className="flex-1">Clear Theme</Button>
                    <Button onClick={saveTheme} color="lime" className="flex-1">Save Theme</Button>
                </div>
            </div>
        </Modal>
    );
};

// V62: VIP collection-item picker. Lists the user's own listed items (feed-card style) and
// posts the chosen one into the radio chat as a 'collection' message. Day-capped.
const ChatCollectionShareModal = ({ user, profile, isOpen, onClose, chanId }) => {
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(false);
    const [notice, setNotice] = useState('');
    const myUid = user?.uid;
    useEffect(() => {
        if (!isOpen || !myUid) return;
        setLoading(true);
        (async () => {
            try {
                const snap = await getDocs(query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('ownerId', '==', myUid)));
                // Only real listed items — exclude DIY requests, open requests, and design concepts.
                const rows = snap.docs.map(d => ({ ...d.data(), id: d.id })).filter(i => !i.isDIYRequest && !i.isRequest && i.status !== 'request' && !i.isDesignConcept);
                setItems(rows);
            } catch (e) { setItems([]); } finally { setLoading(false); }
        })();
    }, [isOpen, myUid]);
    const shareItem = async (it) => {
        const cap = RK_CFG.chatCollectionShareMax || 5;
        const key = 'rk_chat_collshare_' + todayKey();
        let used = 0; try { used = parseInt(localStorage.getItem(key) || '0') || 0; } catch (e) {}
        if (used >= cap) { setNotice('You’ve hit today’s limit of ' + cap + ' collection shares. Resets tomorrow.'); return; }
        try {
            await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'radioChat', chanId, 'messages'), {
                uid: myUid, name: profile?.displayName || 'Raver', publicUid: profile?.publicUid || myUid,
                photoURL: profile?.photoURL || '', badge: profile?.featuredBadge || null,
                kind: 'collection', at: Date.now(),
                item: { id: it.id, name: it.name || 'Item', image: it.mediaUrls?.[0]?.url || it.imageUrl || it.image || '', price: it.price != null ? it.price : null }
            });
            try { localStorage.setItem(key, String(used + 1)); } catch (e) {}
            setNotice('📦 Shared to chat (' + (used + 1) + '/' + cap + ' today)!');
            setTimeout(() => { setNotice(''); onClose(); }, 1200);
        } catch (e) { setNotice('Couldn’t share: ' + e.message); }
    };
    if (!isOpen) return null;
    return (
        <Modal isOpen={isOpen} onClose={onClose} zClass="z-[280]" title="📦 Share a Collection Item">
            {notice && <p className="text-[11px] text-lime-300 bg-lime-900/20 border border-lime-500/30 rounded p-2 mb-2">{notice}</p>}
            <p className="text-[10px] text-white/60 mb-2">Pick an item to drop into the chat. Limited to {RK_CFG.chatCollectionShareMax || 5} shares per day.</p>
            {loading ? <p className="text-center opacity-50 py-8 text-xs animate-pulse">Loading your collection…</p> : items.length === 0 ? (
                <p className="text-center opacity-50 py-8 text-xs">You haven’t listed any items yet. Post something to share it here!</p>
            ) : (
                <div className="grid grid-cols-2 gap-3 max-h-[55vh] overflow-y-auto p-1">
                    {items.map(it => (
                        <button key={it.id} onClick={() => shareItem(it)} className="bg-black/50 border border-white/15 rounded-lg overflow-hidden text-left hover:border-pink-500/60 transition">
                            <div className="h-24 bg-black/60"><img src={it.mediaUrls?.[0]?.url || it.imageUrl || it.image || 'https://placehold.co/120?text=Item'} onError={(e)=>{ if(e.target.src.indexOf('placehold')<0) e.target.src='https://placehold.co/120?text=Item'; }} className="w-full h-full object-cover"/></div>
                            <div className="p-2"><p className="text-[11px] font-bold truncate">{it.name || 'Item'}</p>{it.price != null && <p className="text-[10px] text-lime-300">${Number(it.price).toFixed(2)}</p>}</div>
                        </button>
                    ))}
                </div>
            )}
        </Modal>
    );
};

const RADIO_CHAT_FONT_FIELD = 'chatTextStyle';

// V62: Global/per-station radio chat. View-only preview lives in the player; this modal is the
// full room. Messages: public/data/radioChat/{station}/messages. Presence + typing:
// public/data/radioChat/{station}/presence/{uid}.
const RadioChatModal = ({ user, profile, isOpen, onClose, station, stations, onChangeStation, onViewProfile, onShareCollection }) => {
    const [msgs, setMsgs] = useState([]);
    const [input, setInput] = useState('');
    const [fontOpen, setFontOpen] = useState(false);
    const [cooldown, setCooldown] = useState(0);
    const [typingUsers, setTypingUsers] = useState(0);
    const [activeUsers, setActiveUsers] = useState(0);
    const [notice, setNotice] = useState('');
    const scrollRef = useRef(null);
    const typingTimer = useRef(null);
    const chanId = station?.id || CHAT_GLOBAL_ID;
    const myUid = user?.uid;
    const vip = isEffVIP(profile);
    const chatPath = ['artifacts', appId, 'public', 'data', 'radioChat', chanId, 'messages'];
    const presencePath = ['artifacts', appId, 'public', 'data', 'radioChat', chanId, 'presence'];

    // Live messages (latest 60).
    useEffect(() => {
        if (!isOpen) return;
        const qy = query(collection(db, ...chatPath), orderBy('at', 'desc'), limit(60));
        const unsub = onSnapshot(qy, s => {
            const rows = s.docs.map(d => ({ ...d.data(), id: d.id })).reverse();
            setMsgs(rows);
            setTimeout(() => { if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight; }, 50);
        }, e => console.log('radioChat', e));
        return () => unsub();
    }, [isOpen, chanId]);

    // Presence + typing: heartbeat my presence; count active + typing in the last ~12s.
    useEffect(() => {
        if (!isOpen || !myUid) return;
        const myRef = doc(db, ...presencePath, myUid);
        const beat = async (typing) => { try { await setDoc(myRef, { at: Date.now(), typing: !!typing, name: profile?.displayName || 'Raver' }, { merge: true }); } catch (e) {} };
        beat(false);
        const hb = setInterval(() => beat(false), 8000);
        const qy = query(collection(db, ...presencePath));
        const unsub = onSnapshot(qy, s => {
            const now = Date.now();
            const live = s.docs.map(d => d.data()).filter(p => p.at && (now - p.at) < 12000);
            setActiveUsers(live.length);
            setTypingUsers(live.filter(p => p.typing && (now - p.at) < 6000 && p.name !== (profile?.displayName || 'Raver')).length);
        }, e => console.log('presence', e));
        return () => { clearInterval(hb); unsub(); try { setDoc(myRef, { at: 0, typing: false }, { merge: true }); } catch (e) {} };
    }, [isOpen, chanId, myUid]);

    // Cooldown ticker (non-VIP anti-spam delay).
    useEffect(() => { if (cooldown <= 0) return; const t = setInterval(() => setCooldown(c => Math.max(0, c - 1)), 1000); return () => clearInterval(t); }, [cooldown]);

    const markTyping = () => {
        if (!myUid) return;
        try { setDoc(doc(db, ...presencePath, myUid), { at: Date.now(), typing: true, name: profile?.displayName || 'Raver' }, { merge: true }); } catch (e) {}
        if (typingTimer.current) clearTimeout(typingTimer.current);
        typingTimer.current = setTimeout(() => { try { setDoc(doc(db, ...presencePath, myUid), { typing: false }, { merge: true }); } catch (e) {} }, 4000);
    };

    const send = async () => {
        const text = input.trim();
        if (!text || !myUid || cooldown > 0) return;
        const mod = chatModerate(text, { isVIP: vip });
        if (!mod.ok) {
            if (mod.reason === 'hate') setNotice('🚫 That message contains blocked language and was not sent. Repeated attempts may lead to a ban.');
            else if (mod.reason === 'link') setNotice('🔗 Links aren\u2019t allowed in chat. ' + (vip ? 'Use the "Share Social Link" button below to post one (limited per day).' : 'Spamming or posting links can lead to warnings or a ban.'));
            else setNotice('Message not sent.');
            setTimeout(() => setNotice(''), 4000);
            return;
        }
        try {
            await addDoc(collection(db, ...chatPath), {
                uid: myUid, name: profile?.displayName || 'Raver', publicUid: profile?.publicUid || myUid,
                photoURL: profile?.photoURL || '', badge: profile?.featuredBadge || null,
                style: profile?.[RADIO_CHAT_FONT_FIELD] || profile?.msgTextStyle || null,
                text, at: Date.now(), kind: 'text'
            });
            setInput('');
            if (!vip) { const d = RK_CFG.chatDelaySec || 8; setCooldown(d); }
        } catch (e) { setNotice('Couldn\u2019t send: ' + e.message); setTimeout(() => setNotice(''), 4000); }
    };

    // VIP: share one social link per message, capped per day.
    const shareSocialLink = async () => {
        if (!vip) return;
        const link = (input.trim());
        if (!looksLikeLink(link)) { setNotice('Paste a valid social/profile link first (then tap Share Link).'); setTimeout(() => setNotice(''), 4000); return; }
        const cap = RK_CFG.chatVipShareMax || 5;
        let used = 0; const key = 'rk_chat_linkshare_' + todayKey();
        try { used = parseInt(localStorage.getItem(key) || '0') || 0; } catch (e) {}
        if (used >= cap) { setNotice('You\u2019ve hit today\u2019s limit of ' + cap + ' link shares. Resets tomorrow.'); setTimeout(() => setNotice(''), 4000); return; }
        try {
            await addDoc(collection(db, ...chatPath), {
                uid: myUid, name: profile?.displayName || 'Raver', publicUid: profile?.publicUid || myUid,
                photoURL: profile?.photoURL || '', badge: profile?.featuredBadge || null,
                style: profile?.[RADIO_CHAT_FONT_FIELD] || null, text: link, at: Date.now(), kind: 'link'
            });
            try { localStorage.setItem(key, String(used + 1)); } catch (e) {}
            setInput(''); setNotice('🔗 Link shared (' + (used + 1) + '/' + cap + ' today).'); setTimeout(() => setNotice(''), 3000);
        } catch (e) { setNotice('Couldn\u2019t share: ' + e.message); setTimeout(() => setNotice(''), 4000); }
    };

    if (!isOpen) return null;
    const cap = RK_CFG.chatVipShareMax || 5;

    return createPortal(
        <div className="fixed inset-0 z-[260] bg-black/90 flex items-end sm:items-center justify-center p-2 sm:p-4">
            <div className="bg-[#0f001e] border-2 border-pink-500/40 rounded-2xl w-full max-w-lg flex flex-col shadow-[0_0_30px_rgba(236,72,153,0.35)]" style={{ maxHeight: '92vh' }}>
                {/* Header: station selector + active count + close */}
                <div className="p-3 border-b border-white/15 flex items-center gap-2">
                    <div className="flex-1 min-w-0">
                        <p className="text-[9px] uppercase font-black text-pink-300 tracking-widest">Radio Chat</p>
                        <div className="relative mt-1">
                            <select value={chanId} onChange={e => onChangeStation(e.target.value)} className="w-full appearance-none bg-black border border-white/25 rounded-lg pl-2 pr-7 py-1.5 text-xs font-bold text-cyan-300">
                                <option value={CHAT_GLOBAL_ID}>🌐 Global Chat (all stations)</option>
                                {stations.map(st => <option key={st.id} value={st.id}>{st.name}</option>)}
                            </select>
                            <ChevronDown size={14} className="absolute right-2 top-1/2 -translate-y-1/2 text-white/50 pointer-events-none"/>
                        </div>
                    </div>
                    {/* active-user neon count box */}
                    <div className="shrink-0 text-center px-2 py-1 rounded-lg border border-cyan-400/50 bg-black/50" style={{ boxShadow: '0 0 12px rgba(0,255,255,0.35)' }}>
                        <span className="rkfx-pastel text-xl font-black leading-none">{activeUsers}</span>
                        <p className="text-[7px] uppercase text-white/50 tracking-wide">in chat</p>
                    </div>
                    <button onClick={onClose} className="shrink-0 text-white/70 hover:text-white"><XCircle size={24}/></button>
                </div>

                {/* Anti-spam / rules notice */}
                <div className="px-3 py-1.5 bg-amber-900/15 border-b border-amber-500/20">
                    <p className="text-[8px] text-amber-200/80 leading-tight">No links (VIP link-share only), no hate speech. Spamming leads to warnings → bans. Be excellent to each other. PLUR 🌈</p>
                </div>

                {/* Messages */}
                <div ref={scrollRef} className="flex-1 overflow-y-auto p-3 space-y-2 min-h-[200px]">
                    {msgs.length === 0 && <p className="text-center text-white/40 text-xs py-8">No messages yet — say hi to the {chanId === CHAT_GLOBAL_ID ? 'whole rave' : station?.name + ' crew'}! 🌈</p>}
                    {msgs.map(m => {
                        const ts = getUserTextStyle(m.style);
                        const mine = m.uid === myUid;
                        return (
                            <div key={m.id} className="flex items-start gap-2">
                                <img src={m.photoURL || 'https://placehold.co/32?text=U'} onClick={() => { if (onViewProfile && m.publicUid) { onClose(); onViewProfile(m.publicUid); } }} className="w-8 h-8 rounded-full object-cover border border-pink-500/40 cursor-pointer shrink-0 mt-0.5"/>
                                <div className="flex-1 min-w-0">
                                    <div className="flex items-center gap-1 flex-wrap">
                                        <button onClick={() => { if (onViewProfile && m.publicUid) { onClose(); onViewProfile(m.publicUid); } }} className={`text-[11px] font-black ${mine ? 'text-lime-300' : 'text-cyan-300'} hover:underline`}>@{m.name}</button>
                                        {m.badge && <BadgeChip badge={m.badge} />}
                                    </div>
                                    {m.kind === 'collection' && m.item ? (
                                        <button onClick={() => { if (onViewProfile && m.publicUid) { onClose(); onViewProfile(m.publicUid); } }} className="mt-1 flex items-center gap-2 bg-black/50 border border-pink-500/30 rounded-lg p-2 w-full text-left hover:bg-white/5">
                                            <img src={m.item.image || 'https://placehold.co/48?text=Item'} className="w-12 h-12 rounded object-cover shrink-0"/>
                                            <div className="min-w-0"><p className="text-[11px] font-bold truncate text-pink-200">{m.item.name}</p>{m.item.price != null && <p className="text-[10px] text-lime-300">${Number(m.item.price).toFixed(2)}</p>}<p className="text-[8px] text-white/40">Shared from collection · tap to view</p></div>
                                        </button>
                                    ) : m.kind === 'link' ? (
                                        <a href={m.text} target="_blank" rel="noreferrer" className="text-[12px] text-cyan-400 underline break-all">{m.text}</a>
                                    ) : (
                                        <p className={'text-[13px] break-words ' + (ts.className ? ts.className : 'text-white/90')} style={ts.style && Object.keys(ts.style).length ? ts.style : { color: undefined }}>{m.text}</p>
                                    )}
                                </div>
                            </div>
                        );
                    })}
                </div>

                {/* Typing indicator */}
                <div className="px-3 h-4">{typingUsers > 0 && <p className="text-[9px] text-pink-300/80 italic">{typingUsers} {typingUsers === 1 ? 'raver is' : 'ravers are'} typing…</p>}</div>

                {/* Notice line */}
                {notice && <div className="px-3 pb-1"><p className="text-[10px] text-yellow-300 bg-yellow-900/20 border border-yellow-500/30 rounded p-1.5">{notice}</p></div>}

                {/* Composer */}
                <div className="p-3 border-t border-white/15 space-y-2">
                    <div className="flex items-center gap-2">
                        <button onClick={() => setFontOpen(true)} title="Font & style" className="shrink-0 w-9 h-9 rounded-lg bg-white/10 border border-white/20 flex items-center justify-center text-pink-300 hover:bg-white/20"><Type size={16}/></button>
                        <input value={input} onChange={e => { setInput(e.target.value); markTyping(); }} onKeyDown={e => { if (e.key === 'Enter') send(); }} maxLength={300} placeholder={cooldown > 0 ? ('Wait ' + cooldown + 's…') : 'Message the chat…'} className="flex-1 bg-black border border-white/25 rounded-lg px-3 py-2 text-sm focus:border-pink-500/60 outline-none"/>
                        <button onClick={send} disabled={cooldown > 0 || !input.trim()} className="shrink-0 bg-pink-600 disabled:bg-white/10 disabled:text-white/40 text-white font-black rounded-lg px-4 py-2 text-sm active:scale-95">Send</button>
                    </div>
                    {/* VIP-only actions */}
                    <div className="flex items-center gap-2">
                        {vip ? (
                            <>
                                <Button onClick={shareSocialLink} color="cyan" className="flex-1 text-[10px] flex items-center justify-center gap-1"><Link size={12}/> Share Social Link</Button>
                                <Button onClick={() => { if (onShareCollection) onShareCollection(chanId); }} color="purple" className="flex-1 text-[10px] flex items-center justify-center gap-1"><Package size={12}/> Share Collection Item</Button>
                            </>
                        ) : (
                            <p className="text-[9px] text-white/40 text-center w-full">✨ VIP unlocks link sharing &amp; collection sharing in chat — and no message cooldown.</p>
                        )}
                    </div>
                    {vip && <p className="text-[8px] opacity-40 text-center">Link &amp; collection shares are limited to {cap}/{RK_CFG.chatCollectionShareMax || 5} per day to keep chat clean.</p>}
                </div>
            </div>
            <FontSelectorModal user={user} profile={profile} isOpen={fontOpen} onClose={() => setFontOpen(false)} field={RADIO_CHAT_FONT_FIELD} titleLabel="Chat Font & Style" zClass="z-[280]" />
        </div>, document.body);
};

const EqSlider = ({ label, value, min, max, onChange, suffix }) => (
    <div className="mb-3">
        <div className="flex justify-between text-[10px] font-bold mb-1"><span className="text-cyan-400 uppercase tracking-widest">{label}</span><span className="text-lime-400">{value}{suffix}</span></div>
        <input type="range" min={min} max={max} value={value} onChange={e => onChange(parseInt(e.target.value))} className="w-full accent-pink-500 h-2" />
    </div>
);

const RadioPlayerModal = ({ user, profile, isOpen, onClose, onGoVip, onPlayingChange, onNowPlaying, onViewProfileFromRadio }) => {
    const [consent, setConsent] = useState(() => { try { return localStorage.getItem('rk_audio_consent') === 'true'; } catch(e) { return false; } });
    const [station, setStation] = useState(RADIO_STATIONS[0]);
    const [playing, setPlaying] = useState(false);
    const [status, setStatus] = useState('Select a station and press play.');
    const [radioTab, setRadioTab] = useState('inapp'); // 'inapp' | 'youtube'
    const [volume, setVolume] = useState(80);
    const [bass, setBass] = useState(0);
    const [mid, setMid] = useState(0);
    const [treble, setTreble] = useState(0);
    const [eqActive, setEqActive] = useState(false);
    const [soundOpen, setSoundOpen] = useState(false);      // volume/EQ popup
    const [chatOpen, setChatOpen] = useState(false);        // full chat modal
    const [chatChan, setChatChan] = useState(CHAT_GLOBAL_ID);// selected chat channel
    const [chatPreview, setChatPreview] = useState([]);     // view-only preview msgs
    const [collShareOpen, setCollShareOpen] = useState(false); // collection picker for chat share
    const [stScroll, setStScroll] = useState({ thumb: 40, top: 0 }); // station list scroll indicator
    const [bgAudio, setBgAudio] = useState(() => { try { return localStorage.getItem('rk_bg_audio') !== 'off'; } catch (e) { return true; } });
    const stationListRef = useRef(null);

    const audioRef = useRef(null);
    const ctxRef = useRef(null);
    const bassRef = useRef(null);
    const midRef = useRef(null);
    const trebleRef = useRef(null);
    const gainRef = useRef(null);

    const initEq = () => {
        if (ctxRef.current || !audioRef.current) return;
        try {
            const Ctx = window.AudioContext || window.webkitAudioContext;
            const ctx = new Ctx();
            const srcNode = ctx.createMediaElementSource(audioRef.current);
            const b = ctx.createBiquadFilter(); b.type = 'lowshelf'; b.frequency.value = 200;
            const m = ctx.createBiquadFilter(); m.type = 'peaking'; m.frequency.value = 1000; m.Q.value = 1;
            const t = ctx.createBiquadFilter(); t.type = 'highshelf'; t.frequency.value = 3000;
            const g = ctx.createGain();
            srcNode.connect(b); b.connect(m); m.connect(t); t.connect(g); g.connect(ctx.destination);
            ctxRef.current = ctx; bassRef.current = b; midRef.current = m; trebleRef.current = t; gainRef.current = g;
            setEqActive(true);
        } catch (e) { console.log('EQ unavailable, falling back to basic volume.', e); }
    };

    useEffect(() => { if (audioRef.current) audioRef.current.volume = volume / 100; }, [volume]);
    useEffect(() => { if (bassRef.current) bassRef.current.gain.value = bass; }, [bass]);
    useEffect(() => { if (midRef.current) midRef.current.gain.value = mid; }, [mid]);
    useEffect(() => { if (trebleRef.current) trebleRef.current.gain.value = treble; }, [treble]);
    useEffect(() => { if (onPlayingChange) onPlayingChange(playing); }, [playing]);

    // V63: background playback control. When ON (default), set MediaSession metadata so the OS
    // keeps the stream alive with lock-screen controls; when OFF, pause the moment the app is
    // hidden so audio only plays in-app.
    useEffect(() => {
        const onVis = () => {
            if (document.hidden && !bgAudio && audioRef.current && playing) {
                audioRef.current.pause(); setPlaying(false); setStatus('Paused (background audio is off)');
            }
        };
        document.addEventListener('visibilitychange', onVis);
        return () => document.removeEventListener('visibilitychange', onVis);
    }, [bgAudio, playing]);

    useEffect(() => {
        try {
            if ('mediaSession' in navigator && playing && station) {
                navigator.mediaSession.metadata = new window.MediaMetadata({ title: station.name, artist: 'RaveKandi Radio', album: station.genre || 'Rave Radio' });
                navigator.mediaSession.setActionHandler('play', () => { try { audioRef.current && audioRef.current.play(); setPlaying(true); } catch (e) {} });
                navigator.mediaSession.setActionHandler('pause', () => { try { audioRef.current && audioRef.current.pause(); setPlaying(false); } catch (e) {} });
            }
        } catch (e) {}
    }, [playing, station]);

    // V62: view-only chat preview inside the player (latest 5 of the selected channel).
    useEffect(() => {
        if (!isOpen) return;
        const qy = query(collection(db, 'artifacts', appId, 'public', 'data', 'radioChat', chatChan, 'messages'), orderBy('at', 'desc'), limit(5));
        const unsub = onSnapshot(qy, s => setChatPreview(s.docs.map(d => ({ ...d.data(), id: d.id })).reverse()), e => console.log('chatPreview', e));
        return () => unsub();
    }, [isOpen, chatChan]);

    // V37.11: now-playing song polling. SomaFM exposes a public JSON now-playing API;
    // other stations report as a live stream (no track metadata available).
    useEffect(() => {
        if (!onNowPlaying) return;
        if (!playing || !station) { onNowPlaying(null); return; }
        let alive = true;
        const isSoma = station.url.includes('somafm.com/');
        const channel = isSoma ? station.url.split('somafm.com/')[1].split('-')[0] : null;
        const pull = async () => {
            let song = '';
            if (channel) {
                try {
                    const r = await fetch('https://somafm.com/songs/' + channel + '.json', { cache: 'no-store' });
                    if (r.ok) { const j = await r.json(); const s0 = j.songs && j.songs[0]; if (s0) song = (s0.artist ? s0.artist + ' — ' : '') + (s0.title || ''); }
                } catch (e) {}
            }
            if (alive) onNowPlaying({ name: station.name, song: song || 'Live Stream', color: station.color });
        };
        pull();
        const int = setInterval(pull, 25000);
        return () => { alive = false; clearInterval(int); };
    }, [playing, station]);

    // V37.13: top-listener tracking — buffer listening minutes locally; the App's 6h
    // activity sync flushes them to the profile alongside active time.
    useEffect(() => {
        if (!playing || !user?.uid || user.isAnonymous) return;
        const k = 'rk_radio_buf_' + user.uid;
        const t = setInterval(() => { try { localStorage.setItem(k, String((parseInt(localStorage.getItem(k) || '0') || 0) + 1)); } catch (e) {} }, 60000);
        return () => clearInterval(t);
    }, [playing, user]);

    const grantPermission = () => {
        try { localStorage.setItem('rk_audio_consent', 'true'); } catch(e) {}
        setConsent(true);
        initEq();
        if (ctxRef.current && ctxRef.current.state === 'suspended') ctxRef.current.resume();
        setStatus('Audio enabled. Pick a station!');
    };

    const playStation = async (st) => {
        const a = audioRef.current; if (!a) return;
        setStation(st); setStatus('Connecting to ' + st.name + '...');
        try {
            initEq();
            if (ctxRef.current && ctxRef.current.state === 'suspended') await ctxRef.current.resume();
            a.src = st.url; a.load();
            await a.play();
            setPlaying(true); setStatus('LIVE: ' + st.name + ' — ' + st.genre);
        } catch (e) { setPlaying(false); setStatus('Stream failed. Check connection or try another station.'); }
    };

    const togglePlay = () => {
        const a = audioRef.current; if (!a) return;
        if (playing) { a.pause(); setPlaying(false); setStatus('Paused: ' + station.name); }
        else { playStation(station); }
    };

    return (
        <>
            <audio ref={audioRef} crossOrigin="anonymous" playsInline preload="none" onError={() => { if (playing) { setPlaying(false); setStatus('Station unreachable. Try another.'); } }} />
            {isOpen && (
                <div className="fixed inset-0 bg-black/90 z-[200] flex items-center justify-center p-4 overflow-y-auto">
                    <Card className="max-w-md w-full my-8 bg-[#0f001e]/95" glow="purpleGlow">
                        <div className="flex justify-between items-center mb-4 border-b border-white/20 pb-2">
                            <h3 className="text-xl font-black italic flex items-center gap-2" style={getTextGlowStyle('purpleGlow')}><Radio size={20}/> RAVE RADIO</h3>
                            <button onClick={onClose}><XCircle/></button>
                        </div>
                        {!consent ? (
                            <div className="text-center py-6 space-y-4">
                                <div className="flex justify-center"><Volume size={48} color="#64ffff"/></div>
                                <p className="text-sm text-white font-bold">RaveKandi needs permission to play audio on this device.</p>
                                <p className="text-xs text-white/60">This enables the live radio streams and the equalizer controls.</p>
                                <Button onClick={grantPermission} color="lime" className="w-full">Allow Audio Playback</Button>
                            </div>
                        ) : (
                            <div className="space-y-4">
                                <div className="bg-black/60 border border-white/10 rounded p-2 text-center">
                                    <p className="text-[10px] font-mono truncate" style={{ color: station.color }}>{status}</p>
                                </div>
                                <div className="flex gap-1 bg-black/40 rounded-lg p-1">
                                    <button onClick={() => setRadioTab('inapp')} className={`flex-1 text-[10px] font-black uppercase tracking-wide py-1.5 rounded ${radioTab==='inapp' ? 'bg-pink-600 text-white' : 'text-white/50'}`}>📻 In-App Stations</button>
                                    <button onClick={() => setRadioTab('youtube')} className={`flex-1 text-[10px] font-black uppercase tracking-wide py-1.5 rounded flex items-center justify-center gap-1 ${radioTab==='youtube' ? 'bg-red-600 text-white' : 'text-white/50'}`}><Youtube size={11}/> YouTube</button>
                                </div>
                                {radioTab === 'inapp' ? (
                                    <div className="relative border-2 border-pink-500/60 rounded-xl bg-black/40 p-2" style={{ boxShadow: '0 0 12px rgba(236,72,153,0.6), inset 0 0 12px rgba(0,0,0,0.5)' }}>
                                        <p className="text-[8px] uppercase font-bold text-pink-300/70 mb-1 px-1 flex items-center justify-between"><span>📻 Pick a station — scroll for more</span><ChevronDown size={11} className="animate-bounce"/></p>
                                        <div ref={stationListRef} onScroll={(e) => { const el = e.target; const max = el.scrollHeight - el.clientHeight; const thumb = Math.max(15, (el.clientHeight / el.scrollHeight) * 100); const top = max > 0 ? (el.scrollTop / max) * (100 - thumb) : 0; setStScroll({ thumb, top }); }} className="grid grid-cols-2 gap-2 max-h-44 overflow-y-auto pr-3 rk-scrollbox">
                                            {RADIO_STATIONS.map(st => (
                                                <button key={st.id} onClick={() => playStation(st)} className={'p-2 rounded-lg border text-left transition-all ' + (station.id === st.id ? 'bg-white/10' : 'bg-black/40 hover:bg-white/5')} style={{ borderColor: station.id === st.id ? st.color : 'rgba(255,255,255,0.15)', boxShadow: station.id === st.id ? '0 0 10px ' + st.color : 'none' }}>
                                                    <p className="text-xs font-black" style={{ color: st.color }}>{st.name}</p>
                                                    <p className="text-[8px] text-white/60 uppercase">{st.genre}</p>
                                                </button>
                                            ))}
                                        </div>
                                        {/* visible scroll-wheel track on the right — thumb tracks scroll position */}
                                        <div className="absolute right-1 top-7 bottom-2 w-1.5 rounded-full bg-white/10 pointer-events-none">
                                            <div className="w-full rounded-full bg-pink-500/70 transition-all duration-75" style={{ height: stScroll.thumb + '%', marginTop: stScroll.top + '%' }}/>
                                        </div>
                                    </div>
                                ) : (
                                    <div>
                                        <p className="text-[8px] opacity-50 mb-2">Full DJ sets & livestreams with visuals — opens in YouTube (keeps playing in the background).</p>
                                        <div className="grid grid-cols-2 gap-2 max-h-48 overflow-y-auto pr-1">
                                            {YOUTUBE_STATIONS.map(st => (
                                                <button key={st.id} onClick={() => { try { window.open(st.url, '_blank', 'noopener'); } catch (e) {} }} className="p-2 rounded-lg border border-white/15 bg-black/40 hover:bg-white/5 text-left transition-all">
                                                    <p className="text-xs font-black flex items-center gap-1" style={{ color: st.color }}><Youtube size={10}/> {st.name}</p>
                                                    <p className="text-[8px] text-white/60 uppercase">{st.genre}</p>
                                                </button>
                                            ))}
                                        </div>
                                    </div>
                                )}
                                <div className="flex justify-center">
                                    <button onClick={togglePlay} className="w-16 h-16 rounded-full border-2 flex items-center justify-center transition-transform active:scale-90 bg-black/50" style={{ borderColor: station.color, boxShadow: '0 0 15px ' + station.color, color: station.color }}>
                                        {playing ? <span className="font-black text-[10px] tracking-widest">PAUSE</span> : <Play size={28} fill="currentColor"/>}
                                    </button>
                                </div>

                                {/* V62: view-only chat preview + tap-to-join. In-app music chat only. */}
                                <div>
                                    <p className="text-[9px] text-center text-pink-300/80 font-bold uppercase tracking-wide mb-1">💬 Tap below to join the live chat</p>
                                    <button onClick={() => setChatOpen(true)} className="w-full bg-black/60 border-2 border-cyan-400/60 rounded-xl p-2.5 text-left hover:border-cyan-400 transition" style={{ minHeight: '92px', boxShadow: '0 0 12px rgba(34,211,238,0.5)' }}>
                                        {chatPreview.length === 0 ? (
                                            <p className="text-[11px] text-white/40 text-center py-5">No messages yet — be the first to vibe in chat! 🌈</p>
                                        ) : (
                                            <div className="space-y-1">
                                                {chatPreview.map(m => (
                                                    <p key={m.id} className="text-[11px] truncate"><span className="font-black text-cyan-300">@{m.name}:</span> <span className="text-white/80">{m.kind === 'collection' ? '📦 shared a collection item' : m.kind === 'link' ? '🔗 shared a link' : m.text}</span></p>
                                                ))}
                                            </div>
                                        )}
                                        <p className="text-[8px] text-pink-400/70 text-center mt-1 font-bold">Tap to open chat →</p>
                                    </button>
                                </div>

                                {/* Sound (volume + EQ) button opens a popup */}
                                <button onClick={() => setSoundOpen(true)} className="w-full bg-white/5 border-2 border-purple-400/60 rounded-xl py-2.5 flex items-center justify-center gap-2 text-sm font-bold text-cyan-300 hover:bg-white/10 transition" style={{ boxShadow: '0 0 12px rgba(168,85,247,0.5)' }}><Volume size={18}/> Volume &amp; Sound Controls</button>
                                <p className="text-[8px] text-center text-white/40">Live streams powered by SomaFM.com</p>
                            </div>
                        )}
                    </Card>
                </div>
            )}

            {/* V62: Volume + in-depth sound controls popup */}
            <Modal isOpen={soundOpen} onClose={() => setSoundOpen(false)} zClass="z-[240]" title="🔊 Volume & Sound">
                <div className="space-y-1">
                    <EqSlider label="Volume" value={volume} min={0} max={100} onChange={setVolume} suffix="%" />
                    <div className="border-t border-white/10 my-2 pt-2">
                        <p className="text-[10px] uppercase font-black text-pink-300 tracking-widest mb-2">3-Band Equalizer</p>
                        <EqSlider label="Bass" value={bass} min={-12} max={12} onChange={setBass} suffix=" dB" />
                        <EqSlider label="Mid" value={mid} min={-12} max={12} onChange={setMid} suffix=" dB" />
                        <EqSlider label="Treble" value={treble} min={-12} max={12} onChange={setTreble} suffix=" dB" />
                    </div>
                    <div className="border-t border-white/10 my-2 pt-2">
                        <p className="text-[10px] uppercase font-black text-cyan-300 tracking-widest mb-2">Presets</p>
                        <div className="grid grid-cols-3 gap-2">
                            <button onClick={() => { setBass(0); setMid(0); setTreble(0); }} className="text-[10px] py-2 rounded bg-white/10 border border-white/20 font-bold hover:bg-white/20">Flat</button>
                            <button onClick={() => { setBass(8); setMid(-2); setTreble(3); }} className="text-[10px] py-2 rounded bg-pink-900/30 border border-pink-500/40 font-bold hover:bg-pink-900/50">Bass Boost</button>
                            <button onClick={() => { setBass(5); setMid(2); setTreble(6); }} className="text-[10px] py-2 rounded bg-cyan-900/30 border border-cyan-500/40 font-bold hover:bg-cyan-900/50">Club</button>
                            <button onClick={() => { setBass(-2); setMid(4); setTreble(2); }} className="text-[10px] py-2 rounded bg-purple-900/30 border border-purple-500/40 font-bold hover:bg-purple-900/50">Vocal</button>
                            <button onClick={() => { setBass(6); setMid(0); setTreble(8); }} className="text-[10px] py-2 rounded bg-lime-900/30 border border-lime-500/40 font-bold hover:bg-lime-900/50">Crisp</button>
                            <button onClick={() => { setBass(10); setMid(3); setTreble(10); }} className="text-[10px] py-2 rounded bg-yellow-900/30 border border-yellow-500/40 font-bold hover:bg-yellow-900/50">Festival</button>
                        </div>
                    </div>
                    {!eqActive && <p className="text-[8px] text-yellow-400/80 text-center mt-1">EQ activates once playback starts.</p>}
                    <div className="border-t border-white/10 my-2 pt-2">
                        <button onClick={() => { const next = !bgAudio; setBgAudio(next); try { localStorage.setItem('rk_bg_audio', next ? 'on' : 'off'); } catch (e) {} }} className="w-full flex justify-between items-center bg-white/5 p-2.5 rounded-lg border border-white/10">
                            <span className="text-[11px] font-bold flex items-center gap-2"><Radio size={14}/> Play in Background</span>
                            {bgAudio ? <CheckSquare size={18} className="text-lime-400"/> : <Square size={18} className="text-white/30"/>}
                        </button>
                        <p className="text-[8px] opacity-60 mt-1 leading-relaxed">When ON, the radio keeps playing when you leave the app or lock your screen. <span className="text-yellow-300">If OFF, the radio will NOT play in the background — it stops when you leave the app.</span></p>
                    </div>
                    <p className="text-[8px] text-center text-white/40 mt-1">Tip: Bass Boost &amp; Festival hit hardest with headphones or a speaker.</p>
                </div>
            </Modal>

            {/* V62: Full radio chat */}
            <RadioChatModal user={user} profile={profile} isOpen={chatOpen} onClose={() => setChatOpen(false)} station={chatChan === CHAT_GLOBAL_ID ? null : RADIO_STATIONS.find(s => s.id === chatChan)} stations={RADIO_STATIONS} onChangeStation={(id) => setChatChan(id)} onViewProfile={onViewProfileFromRadio} onShareCollection={() => setCollShareOpen(true)} />

            {/* V62: collection-item picker for chat sharing (VIP) */}
            <ChatCollectionShareModal user={user} profile={profile} isOpen={collShareOpen} onClose={() => setCollShareOpen(false)} chanId={chatChan} />
        </>
    );
};

const BadgeChip = ({ badge }) => {
    if (!badge || !badge.id) return null;
    const ach = ACHIEVEMENT_TIERS.find(a => a.id === badge.id);
    if (!ach) return null;
    const Icon = ach.icon;
    return (
        <span className="inline-flex items-center gap-0.5 bg-yellow-500/10 border border-yellow-400/40 text-yellow-300 text-[8px] font-bold px-1 py-0.5 rounded-full ml-1 align-middle uppercase tracking-wide">
            <Icon size={8}/> {badge.name || ach.name}
        </span>
    );
};

const StatDetailModal = ({ statKey, uid, profile, isOpen, onClose, onViewProfile }) => {
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(false);
    const META = {
        sold:    { title: '🏷️ Items Sold', empty: "No items sold yet." },
        bought:  { title: '🛍️ Items Bought', empty: "No purchases yet." },
        salesVal:{ title: '💸 Total Sales Value', empty: "No sales yet." },
        boughtVal:{ title: '💳 Total Spent', empty: "No purchases yet." },
        likes:   { title: '❤️ Likes Received', empty: "No liked posts yet." },
        comments:{ title: '💬 Comments Received', empty: "No commented posts yet." },
    };
    useEffect(() => {
        if (!isOpen || !uid) return;
        const needsItems = ['sold','bought','salesVal','boughtVal','likes','comments'].includes(statKey);
        if (!needsItems) { setItems([]); return; }
        setLoading(true);
        (async () => {
            try {
                let q;
                if (statKey === 'bought' || statKey === 'boughtVal') {
                    q = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('buyers', 'array-contains', uid));
                } else {
                    q = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('ownerId', '==', uid));
                }
                const snap = await getDocs(q);
                let rows = snap.docs.map(d => ({ ...d.data(), id: d.id }));
                if (statKey === 'sold' || statKey === 'salesVal') rows = rows.filter(i => (i.purchaseCount || 0) > 0);
                if (statKey === 'likes') rows = rows.filter(i => (i.likes?.length || 0) > 0).sort((a,b)=>(b.likes?.length||0)-(a.likes?.length||0));
                if (statKey === 'comments') rows = rows.filter(i => (i.comments?.length || 0) > 0).sort((a,b)=>(b.comments?.length||0)-(a.comments?.length||0));
                setItems(rows);
            } catch (e) { console.log('stat detail load', e); setItems([]); } finally { setLoading(false); }
        })();
    }, [isOpen, uid, statKey]);
    if (!isOpen) return null;
    const meta = META[statKey] || { title: 'Details', empty: 'Nothing here.' };
    const badge = (i) => statKey === 'likes' ? `❤️ ${i.likes?.length||0}` : statKey === 'comments' ? `💬 ${i.comments?.length||0}` : `$${Number(i.price||0).toFixed(2)}`;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title={meta.title}>
            {loading ? <p className="text-center opacity-50 py-10 text-xs animate-pulse">Loading…</p> : (
                <div className="grid grid-cols-2 gap-3 max-h-[60vh] overflow-y-auto p-1">
                    {items.length === 0 && <p className="col-span-2 text-center opacity-50 py-10 text-xs">{meta.empty}</p>}
                    {items.map(i => (
                        <div key={i.id} className="bg-white/5 p-2 rounded-lg border border-white/10 flex flex-col">
                            <img src={i.mediaUrls?.[0]?.url || i.imageUrl || i.image || 'https://placehold.co/100?text=Kandi'} className="w-full h-24 object-cover rounded mb-2"/>
                            <p className="font-bold text-[10px] truncate">{i.name || 'Item'}</p>
                            <div className="flex justify-between items-center mt-1 border-t border-white/10 pt-1">
                                <span className="text-[10px] text-lime-400 font-bold">{badge(i)}</span>
                                {(statKey === 'sold' || statKey === 'salesVal') && <span className="text-[8px] opacity-50">×{i.purchaseCount||0}</span>}
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </Modal>
    );
};

const AchievementsModal = ({ profile, isOpen, onClose, editable, userUid }) => {
    const [saving, setSaving] = useState(false);
    if (!isOpen) return null;
    const all = getDisplayAchievements(profile);
    const unlocked = all.filter(a => a.unlocked);
    const top = profile?.topAchievements || [];
    const toggleTop = async (ach) => {
        if (!editable) return;
        if (!ach.unlocked) return alert("Locked — complete the requirement first to feature it.");
        let next = top.includes(ach.id) ? top.filter(x => x !== ach.id) : [...top, ach.id];
        if (next.length > 5) return alert("You can feature up to 5 achievements. Tap one to remove it first.");
        setSaving(true);
        try { await setDoc(doc(db, 'artifacts', appId, 'users', userUid), { topAchievements: next }, { merge: true }); }
        catch (e) { alert('Could not save: ' + e.message); } finally { setSaving(false); }
    };
    return (
        <Modal isOpen={isOpen} onClose={onClose} title={`🏅 Achievements (${unlocked.length}/${all.length})`}>
            <div className="space-y-2 max-h-[65vh] overflow-y-auto pr-1">
                {editable && <p className="text-[10px] text-cyan-300 bg-cyan-900/20 border border-cyan-500/30 rounded p-2">Tap the ⭐ on any unlocked achievement to feature it on your profile (up to 5).</p>}
                {all.map((ach, idx) => {
                    const isTop = top.includes(ach.id);
                    return (
                        <div key={idx} className={`flex items-center p-3 rounded-lg border transition-all ${ach.unlocked ? 'border-lime-500/50 bg-lime-900/10' : 'border-white/5 bg-black/40 opacity-40 grayscale'}`}>
                            <ach.icon size={24} className={`mr-3 shrink-0 ${ach.unlocked ? 'text-lime-400' : 'text-white'}`} />
                            <div className="flex-1 min-w-0">
                                <div className="flex justify-between items-center gap-2">
                                    <p className="font-bold text-sm truncate">{ach.name}</p>
                                    <p className={`text-[8px] font-black uppercase px-1.5 py-0.5 rounded shrink-0 ${ach.unlocked ? 'bg-lime-500 text-black' : 'bg-white/10 text-white'}`}>{ach.unlocked ? 'Unlocked' : 'Locked'}</p>
                                </div>
                                <p className="text-[10px] opacity-70 mt-0.5">{ach.desc}</p>
                            </div>
                            {editable && ach.unlocked && (
                                <button disabled={saving} onClick={() => toggleTop(ach)} className="ml-2 shrink-0 p-1" title="Feature on profile">
                                    <Star size={20} className={isTop ? 'text-yellow-400' : 'text-white/30'} fill={isTop ? 'currentColor' : 'none'} />
                                </button>
                            )}
                        </div>
                    );
                })}
            </div>
        </Modal>
    );
};

const AchievementsCard = ({ profile, editable = false, userUid }) => {
    const [open, setOpen] = useState(false);
    const all = getDisplayAchievements(profile);
    const unlocked = all.filter(a => a.unlocked);
    const top = profile?.topAchievements || [];
    // chosen top-5 if set, else first 5 unlocked, else show locked teasers
    let featured = all.filter(a => top.includes(a.id) && a.unlocked).slice(0, 5);
    if (featured.length === 0) featured = unlocked.slice(0, 5);
    const display = featured.length > 0 ? featured : all.slice(0, 5);
    return (
        <>
            <AchievementsModal profile={profile} isOpen={open} onClose={() => setOpen(false)} editable={editable} userUid={userUid} />
            <Card glow="goldGlow" className="cursor-pointer hover:bg-white/10 transition-colors" >
                <div onClick={() => setOpen(true)}>
                    <div className="flex justify-between items-center mb-4">
                        <h3 className="font-bold text-lg underline decoration-yellow-500/50">Achievements</h3>
                        <span className="text-[10px] text-cyan-400">{unlocked.length}/{all.length} · tap to view all</span>
                    </div>
                    <div className="space-y-3">
                        {display.map((ach, idx) => (
                            <div key={idx} className={`flex items-center p-3 rounded-lg border transition-all ${ach.unlocked ? 'border-lime-500/50 bg-lime-900/10' : 'border-white/5 bg-black/40 opacity-40 grayscale'}`}>
                                <ach.icon size={24} className={`mr-3 shrink-0 ${ach.unlocked ? 'text-lime-400' : 'text-white'}`} />
                                <div className="flex-1 min-w-0">
                                    <div className="flex justify-between items-center gap-2">
                                        <p className="font-bold text-sm truncate">{ach.name}</p>
                                        {(profile?.topAchievements || []).includes(ach.id) && ach.unlocked && <Star size={12} className="text-yellow-400 shrink-0" fill="currentColor"/>}
                                    </div>
                                    <p className="text-[10px] opacity-70 mt-0.5">{ach.desc}</p>
                                </div>
                            </div>
                        ))}
                    </div>
                    <p className="text-center text-[10px] text-yellow-300/70 mt-3">{editable ? 'Tap to view all & choose your featured 5 ⭐' : 'Tap to view all achievements'}</p>
                </div>
            </Card>
        </>
    );
};

const BadgeSelectorModal = ({ user, profile, isOpen, onClose }) => {
    const [saving, setSaving] = useState(false);
    if (!isOpen) return null;
    const all = getDisplayAchievements(profile);
    const selectBadge = async (ach) => {
        if (!ach.unlocked) return alert("Badge locked. Complete the requirement to unlock it.");
        setSaving(true);
        try {
            const next = profile?.featuredBadge?.id === ach.id ? null : { id: ach.id, name: ach.name };
            await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { featuredBadge: next }, { merge: true });
            alert(next ? '"' + ach.name + '" is now displayed next to your name!' : "Featured badge removed.");
        } catch (e) { alert(e.message); } finally { setSaving(false); }
    };
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="My Badges">
            <p className="text-xs text-gray-100 mb-3">Tap an unlocked badge to feature it next to your name on comments, feed posts, and your profile. Tap it again to remove it.</p>
            <div className="space-y-2 max-h-[55vh] overflow-y-auto pr-1">
                {all.map((ach, i) => {
                    const isFeatured = profile?.featuredBadge?.id === ach.id;
                    return (
                        <button key={i} disabled={saving} onClick={() => selectBadge(ach)} className={`w-full flex items-center p-3 rounded-lg border text-left transition-all ${isFeatured ? 'border-yellow-400 bg-yellow-500/10 shadow-[0_0_10px_rgba(250,204,21,0.4)]' : ach.unlocked ? 'border-lime-500/50 bg-lime-900/10 hover:bg-lime-900/30' : 'border-white/5 bg-black/40 opacity-40 grayscale'}`}>
                            <ach.icon size={22} className={`mr-3 shrink-0 ${isFeatured ? 'text-yellow-400' : ach.unlocked ? 'text-lime-400' : 'text-white'}`}/>
                            <div className="flex-1">
                                <p className="font-bold text-sm flex items-center gap-2">{ach.name} {isFeatured && <span className="text-[8px] bg-yellow-400 text-black px-1 rounded font-black uppercase">Featured</span>}</p>
                                <p className="text-[10px] opacity-70">{ach.desc}</p>
                            </div>
                            <span className={`text-[8px] font-black uppercase px-1 rounded ${ach.unlocked ? 'bg-lime-500 text-black' : 'bg-white/10 text-white'}`}>{ach.unlocked ? 'Owned' : 'Locked'}</span>
                        </button>
                    );
                })}
            </div>
        </Modal>
    );
};

const RevShareShareModal = ({ user, profile, isOpen, onClose }) => {
    const [showTiers, setShowTiers] = useState(false);
    if (!isOpen) return null;
    const code = profile?.publicUid || user?.uid || '';
    const shareUrl = buildShareUrl({ ref: code });
    const shareText = 'Join me on RaveKandi! Tap my link and your referral is auto-applied — we both earn RevShare on the marketplace. PLUR! ' + shareUrl;
    const doCopy = () => { try { navigator.clipboard.writeText(code); alert("Friend UID copied!"); } catch(e) { alert(code); } };
    const doCopyLink = () => { try { navigator.clipboard.writeText(buildShareUrl({ ref: code })); alert("Invite link copied! Anyone who opens it gets your referral auto-applied. Put it in your IG/Telegram bio to maximize RevShare."); } catch(e) { alert(buildShareUrl({ ref: code })); } };
    const addToInstagramBio = () => {
        const link = buildShareUrl({ ref: code });
        try { navigator.clipboard.writeText(link); } catch (e) {}
        alert("✅ Your invite link is COPIED!\n\nInstagram will open next — go to Edit Profile → Links (or paste it into your Bio) → paste & save.\n\nThen tap \"I added it!\" back here to claim your Link in Bio Hero badge. 🏅");
        // Best effort: open Instagram's profile-edit. Mobile deep link first, then web.
        setTimeout(() => { try { window.open('instagram://user?username=', '_blank'); } catch (e) {} try { window.open('https://www.instagram.com/accounts/edit/', '_blank', 'noopener'); } catch (e) {} }, 400);
    };
    const attestBioLink = async () => {
        if (profile?.bioLinkAdded) { alert("You've already claimed this badge — thanks for repping RaveKandi! 💖"); return; }
        try {
            await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { bioLinkAdded: true, bioLinkAt: Date.now() }, { merge: true });
            alert("🏅 'Link in Bio Hero' badge unlocked — thank you for spreading the PLUR! Keep that link up to keep earning RevShare from everyone who joins through it.");
        } catch (e) { alert("Couldn't save: " + e.message); }
    };
    const doShare = async () => {
        try { await navigator.share({ title: 'RaveKandi RevShare', text: shareText, url: shareUrl }); }
        catch (e) { try { navigator.clipboard.writeText(shareText); alert("Invite link copied! Paste it anywhere."); } catch(e2) {} }
    };
    const doStory = async () => {
        try { await navigator.share({ title: 'RaveKandi', text: shareText + ' #RaveKandi #PLUR', url: shareUrl }); }
        catch (e) { try { navigator.clipboard.writeText(shareText + ' #RaveKandi #PLUR'); alert("Story caption + link copied! Open your social app and paste it into a new Story."); } catch(e2) {} }
    };
    const refCount = profile?.referrals || 0;
    const tier = getReferralTier(refCount);
    const pct = profile?.customRevSharePct ?? tier.sharePct;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="RevShare Program">
            <div className="space-y-4">
                <div className="bg-lime-900/20 border border-lime-500/40 p-3 rounded text-sm text-gray-100 leading-relaxed">
                    Share your Friend UID. When friends sign up with it, you earn a percentage of the app's commission on <strong>everything they buy — for life</strong>. More referrals = higher tier = bigger cut, up to <strong>25% of the commission</strong> at Eternal Rave.
                </div>
                <div className="bg-black/60 border border-white/20 rounded p-3 text-center">
                    <p className="text-[10px] uppercase opacity-60 mb-1">Your Friend UID</p>
                    <p className="font-mono text-2xl font-black text-lime-400 break-all">{code}</p>
                    <div className="flex items-center justify-center gap-2 mt-2 flex-wrap">
                        <span className={`text-sm font-black ${tier.color}`}>{tier.badge} Tier</span>
                        <span className="text-[10px] text-cyan-400">· {pct}% RevShare · {refCount} referral{refCount === 1 ? '' : 's'}</span>
                    </div>
                </div>
                <Button onClick={doCopyLink} color="lime" className="w-full text-xs flex items-center justify-center gap-2 mb-1"><Link size={16}/> Copy My Invite Link</Button>
                <div className="grid grid-cols-3 gap-2">
                    <Button onClick={doCopy} color="cyan" className="text-[10px] flex flex-col items-center gap-1 py-3"><Copy size={16}/> Copy UID</Button>
                    <Button onClick={doShare} color="purple" className="text-[10px] flex flex-col items-center gap-1 py-3"><Share2 size={16}/> Share</Button>
                    <Button onClick={doStory} color="primary" className="text-[10px] flex flex-col items-center gap-1 py-3"><Camera size={16}/> Story</Button>
                </div>
                <Button onClick={() => setShowTiers(true)} color="accent" className="w-full text-xs flex items-center justify-center gap-2"><Award size={16}/> RevShare Tiers &amp; Benefits</Button>
                <div className="bg-gradient-to-r from-pink-900/30 to-purple-900/30 border border-pink-500/40 rounded-lg p-3 space-y-2">
                    <p className="text-[11px] font-black text-pink-300 uppercase tracking-wide flex items-center gap-1"><Link size={13}/> Earn the "Link in Bio Hero" badge 🏅</p>
                    <p className="text-[10px] text-gray-100 leading-relaxed">Add your invite link to your Instagram bio. Everyone who taps it gets your referral <strong>auto-applied</strong> on signup — passive RevShare forever. Two taps:</p>
                    <Button onClick={addToInstagramBio} color="primary" className="w-full text-xs flex items-center justify-center gap-2"><Instagram size={15}/> Copy Link & Open Instagram</Button>
                    <Button onClick={attestBioLink} color={profile?.bioLinkAdded ? 'cyan' : 'lime'} className="w-full text-xs flex items-center justify-center gap-2">{profile?.bioLinkAdded ? '✅ Badge Claimed' : "I added it! — Claim my badge 🏅"}</Button>
                    <p className="text-[8px] opacity-50 leading-relaxed">Telegram works too — paste the link into your Telegram bio. Keep the link up to keep earning.</p>
                </div>
                <p className="text-[9px] text-center opacity-50">Share opens your phone's share sheet — send to any app, DM, or post straight to your Story.</p>
            </div>
            <Modal isOpen={showTiers} onClose={() => setShowTiers(false)} zClass="z-[120]" title="RevShare Tiers & Benefits">
                <div className="space-y-3">
                    <p className="text-sm text-gray-100 leading-relaxed">Every friend who signs up with your Friend UID earns you a cut of the app's commission on <strong>everything they buy — forever</strong>. The more ravers you bring, the higher your tier climbs and the bigger your cut, all the way to <strong className="text-amber-300">25%</strong>.</p>
                    <div className="bg-black/50 p-3 rounded border border-white/10 max-h-[55vh] overflow-y-auto">
                        <table className="w-full text-xs">
                            <thead><tr className="text-left text-lime-400 border-b border-white/20"><th className="pb-1">Tier</th><th className="pb-1">Referrals</th><th className="pb-1">RevShare</th></tr></thead>
                            <tbody>
                                {REFERRAL_TIERS.map(t => {
                                    const isCurrent = refCount >= t.min && refCount <= t.max && !profile?.customRevSharePct;
                                    return (
                                        <tr key={t.badge} className={`border-b border-white/5 ${isCurrent ? 'bg-white/10' : ''}`}>
                                            <td className={`py-1.5 font-bold ${t.color}`}>{t.badge}{isCurrent && <span className="text-[8px] text-white/70 ml-1">← YOU</span>}</td>
                                            <td className="py-1.5">{t.min.toLocaleString()}-{t.max >= 999999 ? '∞' : t.max.toLocaleString()}</td>
                                            <td className="py-1.5 text-lime-300 font-bold">{t.sharePct}%</td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>
                    <div className="bg-cyan-900/20 p-3 rounded text-xs border border-cyan-500/30">
                        <span className="font-bold text-cyan-400 block mb-1">How it works</span>
                        <p className="text-gray-100 leading-relaxed">Your RevShare % is a share of RaveKandi's commission — it never comes out of your friend's pocket or your own sales. It stacks across every referred raver, and it's paid for life. Climb the tiers by inviting more of your rave fam!</p>
                    </div>
                </div>
            </Modal>
        </Modal>
    );
};

const TicketModal = ({ user, profile, isOpen, onClose }) => {
    const [category, setCategory] = useState('Bug Report');
    const [subject, setSubject] = useState('');
    const [message, setMessage] = useState('');
    const [sending, setSending] = useState(false);
    if (!isOpen) return null;
    const submit = async () => {
        if (!subject.trim() || !message.trim()) return alert("Please fill out the subject and details.");
        setSending(true);
        try {
            await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tickets'), {
                uid: user?.uid || 'guest', username: profile?.displayName || 'Guest', publicUid: profile?.publicUid || '',
                category, subject: subject.trim(), message: message.trim(), status: 'open', createdAt: Date.now(), appVersion: 'V63.03.04'
            });
            try { const adminsSnap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('isAdmin', '==', true))); adminsSnap.forEach(a => pushNotif(a.id, 'admin', '🎫 New ' + category + ' ticket: ' + subject.trim())); } catch (e) {}
            alert("Ticket submitted! The team will review it soon. Thank you for helping improve RaveKandi!");
            setSubject(''); setMessage(''); onClose();
        } catch (e) { alert("Could not submit: " + e.message); } finally { setSending(false); }
    };
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="Help & Bug Reports">
            <Input label="Category" type="select" options={['Bug Report', 'Error / Crash', 'Help Request', 'Feedback / Idea', 'Payment Issue', 'Account Issue']} value={category} onChange={setCategory}/>
            <Input label="Subject" value={subject} onChange={setSubject} placeholder="Short summary..." maxLength={80}/>
            <Input label="Details" type="textarea" value={message} onChange={setMessage} placeholder="What happened? What did you expect? Steps to reproduce..."/>
            <Button onClick={submit} disabled={sending} color="lime" className="w-full">{sending ? "Sending..." : "Submit Ticket"}</Button>
        </Modal>
    );
};

const PingBar = ({ show }) => {
    const [ping, setPing] = useState(null);
    const [offline, setOffline] = useState(!navigator.onLine);
    useEffect(() => {
        let alive = true;
        const measure = async () => {
            const t0 = performance.now();
            try {
                await fetch('https://www.gstatic.com/generate_204?_=' + Date.now(), { mode: 'no-cors', cache: 'no-store' });
                if (alive) { setPing(Math.round(performance.now() - t0)); setOffline(false); }
            } catch (e) { if (alive) setOffline(true); }
        };
        measure();
        const int = setInterval(measure, 10000);
        const goOff = () => setOffline(true);
        const goOn = () => { setOffline(false); measure(); };
        window.addEventListener('offline', goOff);
        window.addEventListener('online', goOn);
        return () => { alive = false; clearInterval(int); window.removeEventListener('offline', goOff); window.removeEventListener('online', goOn); };
    }, []);
    return (
        <>
            {offline && (
                <div className="fixed bottom-6 left-0 w-full z-[60] flex justify-center pointer-events-none">
                    <span className="rk-ghost-flash text-xs font-black uppercase tracking-[0.3em]" style={{ color: '#ffd1f7', textShadow: '0 0 12px #d8b4fe, 0 0 24px #a5f3fc' }}>Connection Lost — Offline Mode</span>
                </div>
            )}
            {show && !offline && ping !== null && (
                <span className={`font-mono ${ping < 120 ? 'text-lime-400' : ping < 300 ? 'text-yellow-400' : 'text-red-400'}`}>PING {ping}ms</span>
            )}
            {show && offline && <span className="font-mono text-red-400">OFFLINE</span>}
            {(!show || (ping === null && !offline)) && <span className="w-14"></span>}
        </>
    );
};

const NOTIF_ICONS = { message: Mail, friendreq: UserPlus, comment: MessageSquare, like: Heart, cart: ShoppingCart, sold: DollarSign, diy: Hammer, queue: Briefcase, achievement: Award, referral: Users, ticket: HelpCircle, admin: Shield };

const MessengerModal = ({ user, profile, isOpen, onClose, threads, notifs, initialTarget, onConsumeTarget, onNotifNav, onViewProfile }) => {
    const [msgFontOpen, setMsgFontOpen] = useState(false);
    const [tab, setTab] = useState('msgs');
    const [activeThread, setActiveThread] = useState(null);
    const [activeName, setActiveName] = useState('');
    const [activeOtherUid, setActiveOtherUid] = useState(null); // V42.12: real other-UID (UIDs contain underscores — never split the thread id)
    const [msgs, setMsgs] = useState([]);
    const [input, setInput] = useState('');
    const [term, setTerm] = useState('');
    const [sortMode, setSortMode] = useState('recent');
    const [notifFilter, setNotifFilter] = useState('all');
    const [searchHit, setSearchHit] = useState(null);
    const [sending, setSending] = useState(false);
    const [threadDoc, setThreadDoc] = useState(null);
    const [obTick, setObTick] = useState(Date.now());
    const [showMsgSettings, setShowMsgSettings] = useState(false);

    const myUid = user?.uid;
    const otherOf = (t) => (t.participants || []).find(p => p !== myUid) || myUid;

    // live messages for the open thread
    useEffect(() => {
        if (!isOpen || !activeThread) { setMsgs([]); return; }
        const q = query(collection(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread, 'messages'), orderBy('at', 'asc'));
        const unsub = onSnapshot(q, s => setMsgs(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('msgs', e));
        // mark thread read
        setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread), { unread: { [myUid]: 0 } }, { merge: true }).catch(()=>{});
        // subscribe to the thread doc for obliterate state
        const unsubDoc = onSnapshot(doc(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread), d => setThreadDoc(d.exists() ? { ...d.data(), id: d.id } : null), e => {});
        return () => { unsub(); unsubDoc(); };
    }, [isOpen, activeThread]);

    // Obliterate countdown ticker + auto-fire when the deadline passes.
    useEffect(() => {
        if (!threadDoc?.obliterate?.deadline) return;
        const iv = setInterval(() => {
            setObTick(Date.now());
            if (Date.now() >= threadDoc.obliterate.deadline) { clearInterval(iv); performObliterate(activeThread).then(() => { setActiveThread(null); setActiveOtherUid(null); setThreadDoc(null); }); }
        }, 1000);
        return () => clearInterval(iv);
    }, [threadDoc, activeThread]);

    // If BOTH users have accepted obliterate, fire immediately (don't wait for the timer).
    useEffect(() => {
        const ob = threadDoc?.obliterate;
        if (ob && ob.accepted && activeOtherUid && ob.accepted[myUid] && ob.accepted[activeOtherUid]) {
            performObliterate(activeThread).then(() => { setActiveThread(null); setActiveOtherUid(null); setThreadDoc(null); });
        }
    }, [threadDoc, activeOtherUid]);

    // mark notifications read when viewing the alerts tab
    useEffect(() => {
        if (!isOpen || tab !== 'alerts' || !myUid) return;
        const unreadOnes = notifs.filter(n => !n.read);
        if (unreadOnes.length === 0) return;
        const batch = writeBatch(db);
        unreadOnes.forEach(n => batch.update(doc(db, 'artifacts', appId, 'users', myUid, 'notifications', n.id), { read: true }));
        batch.commit().catch(()=>{});
    }, [isOpen, tab, notifs]);

    // V42.10: deep-link straight into a thread (e.g. "Message the Admin" on the homepage)
    useEffect(() => {
        if (isOpen && initialTarget?.uid && myUid) {
            const tid = [myUid, initialTarget.uid].sort().join('_');
            setActiveThread(tid); setActiveName(initialTarget.name || 'Raver'); setActiveOtherUid(initialTarget.uid); setTab('msgs');
            if (onConsumeTarget) onConsumeTarget();
        }
    }, [isOpen, initialTarget]);

    // user search — fuzzy: exact UID/name first, then PARTIAL match on name/UID/nickname.
    const runSearch = async (tv, loud) => {
        const t = (tv || '').trim();
        setSearchHit(null);
        if (t.length < 2) { if (loud) alert('Type part of a Friend UID or username first.'); return; }
        const norm = (s) => (s || '').toString().toLowerCase().replace(/[^a-z0-9]/g, '');
        const nt = norm(t);
        try {
            // exact first (fast path)
            let snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', t)));
            if (snap.empty) snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('displayName', '==', t)));
            if (!snap.empty && snap.docs[0].id !== myUid) { setSearchHit({ ...snap.docs[0].data(), id: snap.docs[0].id }); return; }
            // fuzzy fallback — scan recent users
            const dir = await getDocs(query(collection(db, 'artifacts', appId, 'users'), orderBy('joined', 'desc'), limit(200)));
            const hits = dir.docs.map(d => ({ ...d.data(), id: d.id })).filter(u => u.id !== myUid && (norm(u.displayName).includes(nt) || norm(u.publicUid).includes(nt) || norm(u.nickname).includes(nt))).slice(0, 8);
            if (hits.length > 0) setSearchHit(hits.length === 1 ? hits[0] : hits);
            else if (loud) alert('No raver found matching "' + t + '".');
        } catch (e) { if (loud) alert('Search failed: ' + e.message); }
    };
    useEffect(() => {
        if (!isOpen || tab !== 'msgs' || term.trim().length < 3) { setSearchHit(null); return; }
        const h = setTimeout(() => runSearch(term, false), 600);
        return () => clearTimeout(h);
    }, [term, isOpen, tab]);

    if (!isOpen) return null;

    const openThreadWith = async (otherUid, otherName) => {
        // V47: respect the recipient's privacy setting before starting a chat.
        try {
            const tSnap = await getDoc(doc(db, 'artifacts', appId, 'users', otherUid));
            if (tSnap.exists()) {
                const tp = tSnap.data();
                const priv = tp.msgPrivacy || 'all';
                const theyHaveMe = (tp.friends || []).includes(myUid);
                if (priv === 'none' && !theyHaveMe) { alert('@' + (otherName || 'This raver') + ' isn\'t accepting messages right now.'); return; }
                if (priv === 'friends' && !theyHaveMe) { alert('@' + (otherName || 'This raver') + ' only accepts messages from their Vibe Tribe. Send a friend request first!'); return; }
            }
        } catch (e) {}
        openThreadResolved(otherUid, otherName);
    };
    const openThreadResolved = (otherUid, otherName) => {
        const tid = [myUid, otherUid].sort().join('_');
        setActiveThread(tid); setActiveName(otherName || 'Raver'); setActiveOtherUid(otherUid); setTerm(''); setSearchHit(null);
    };

    const send = async () => {
        if (!input.trim() || !activeThread || sending) return;
        setSending(true);
        try {
            if (!activeOtherUid) { alert('Could not resolve the recipient — reopen the conversation and try again.'); setSending(false); return; }
            await sendDirectMessage(myUid, profile?.displayName || 'Raver', activeOtherUid, activeName, input.trim(), profile?.msgTextStyle || profile?.textStyle || null, profile?.featuredBadge || null);
            setInput('');
        } catch (e) { alert('Send failed: ' + e.message); } finally { setSending(false); }
    };

    const delMsg = async (m) => {
        if (!window.confirm('Permanently delete this message? It cannot be stored or restored once gone.')) return;
        try { await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread, 'messages', m.id)); } catch (e) { alert(e.message); }
    };

    const delThread = async () => {
        if (!window.confirm('Permanently delete this ENTIRE chat log for both users? Messages cannot be restored.')) return;
        try {
            const snap = await getDocs(collection(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread, 'messages'));
            const batch = writeBatch(db);
            snap.docs.slice(0, 450).forEach(d => batch.delete(d.ref));
            batch.delete(doc(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread));
            await batch.commit();
            setActiveThread(null); setActiveOtherUid(null);
        } catch (e) { alert(e.message); }
    };

    const toggleFav = async (t) => {
        const cur = t.favorites?.[myUid] === true;
        await setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'threads', t.id), { favorites: { [myUid]: !cur } }, { merge: true }).catch(()=>{});
    };

    const lTerm = term.toLowerCase();
    let list = threads.filter(t => { const nm = (t.names?.[otherOf(t)] || '').toLowerCase(); return !lTerm || nm.includes(lTerm) || otherOf(t).toLowerCase().includes(lTerm); });
    if (sortMode === 'favorites') list = list.filter(t => t.favorites?.[myUid]);
    if (sortMode === 'unread') list = list.filter(t => (t.unread?.[myUid] || 0) > 0);
    if (sortMode === 'read') list = list.filter(t => (t.unread?.[myUid] || 0) === 0);
    if (sortMode === 'friends') list = list.filter(t => (profile?.friends || []).includes(otherOf(t)));
    list = list.sort((a, b) => ((b.favorites?.[myUid] ? 1 : 0) - (a.favorites?.[myUid] ? 1 : 0)) || ((b.lastAt || 0) - (a.lastAt || 0)));

    const visNotifs = notifs.filter(n => (profile?.inAppNotifs?.[n.type] !== false) && (notifFilter === 'all' || n.type === notifFilter));
    const unreadAlertCount = notifs.filter(n => !n.read).length;
    const threadKey = activeOtherUid ? rkKey(myUid, activeOtherUid) : null;

    return createPortal(
        <div className="fixed inset-0 bg-black/90 z-[70] overflow-y-auto" onClick={(e) => e.stopPropagation()}>
            <div className="flex min-h-full items-center justify-center p-2 sm:p-4">
                <Card className="max-w-2xl w-full my-2 flex flex-col min-h-[85vh]" glow="purpleGlow">
                    <div className="flex justify-between items-center mb-3 border-b border-white/20 pb-3">
                        <h3 className="text-2xl font-black uppercase italic tracking-widest" style={getTextGlowStyle('purpleGlow')}>Messenger</h3>
                        <button onClick={() => { setActiveThread(null); setActiveOtherUid(null); onClose(); }}><XCircle size={28}/></button>
                    </div>

                    {!activeThread && (
                        <div className="flex gap-2 mb-3">
                            <button onClick={() => setTab('msgs')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${tab==='msgs' ? 'bg-purple-600 text-white' : 'bg-white/5 text-white/50'}`}>Messages</button>
                            <button onClick={() => setTab('alerts')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${tab==='alerts' ? 'bg-pink-600 text-white' : 'bg-white/5 text-white/50'}`}>Notifications{unreadAlertCount > 0 ? ' (' + unreadAlertCount + ')' : ''}</button>
                        </div>
                    )}

                    {tab === 'msgs' && !activeThread && (<>
                        <div className="flex gap-2 mb-2">
                            <Input value={term} onChange={setTerm} placeholder="Search Friend UID or Username..." className="mb-0 flex-1"/>
                            <Button onClick={() => runSearch(term, true)} color="cyan" className="px-3"><Search size={14}/></Button>
                            <button onClick={() => setShowMsgSettings(!showMsgSettings)} className="bg-black border border-white/20 rounded px-2 text-cyan-400" title="Message privacy"><Settings size={14}/></button>
                        </div>
                        <div className="flex gap-1 mb-2 flex-wrap">
                            {[{k:'recent',l:'Recent'},{k:'favorites',l:'⭐ Favorites'},{k:'unread',l:'Unread'},{k:'read',l:'Read'},{k:'friends',l:'🤝 Tribe'}].map(f => (
                                <button key={f.k} onClick={() => setSortMode(f.k)} className={`text-[9px] font-bold px-2 py-1 rounded-full border ${sortMode===f.k ? 'bg-cyan-600 text-black border-cyan-400' : 'bg-white/5 text-white/60 border-white/15'}`}>{f.l}</button>
                            ))}
                        </div>
                        {showMsgSettings && (
                            <div className="bg-black/60 border border-cyan-500/30 rounded-lg p-3 mb-3 space-y-3">
                                <p className="text-[10px] font-black uppercase text-cyan-400">Message Privacy</p>
                                <div>
                                    <label className="text-[9px] opacity-70 block mb-1">Who can message you?</label>
                                    <div className="flex gap-1">
                                        {[{k:'all',l:'Everyone'},{k:'friends',l:'Tribe Only'},{k:'none',l:'No One'}].map(o => (
                                            <button key={o.k} onClick={() => setDoc(doc(db, 'artifacts', appId, 'users', myUid), { msgPrivacy: o.k }, { merge: true })} className={`flex-1 text-[9px] font-bold py-1.5 rounded border ${(profile?.msgPrivacy||'all')===o.k ? 'bg-pink-600 text-white border-pink-400' : 'bg-white/5 text-white/60 border-white/15'}`}>{o.l}</button>
                                        ))}
                                    </div>
                                </div>
                                <label className="flex items-center justify-between text-[10px]"><span>Message notifications</span>
                                    <button onClick={() => setDoc(doc(db, 'artifacts', appId, 'users', myUid), { msgNotifs: !(profile?.msgNotifs !== false) }, { merge: true })} className={`px-3 py-1 rounded-full text-[9px] font-bold ${profile?.msgNotifs !== false ? 'bg-lime-600 text-black' : 'bg-white/10 text-white/50'}`}>{profile?.msgNotifs !== false ? 'ON' : 'OFF'}</button>
                                </label>
                                <p className="text-[8px] opacity-40">Tribe = your Vibe Tribe friends. Blocked senders simply can't open a chat with you.</p>
                            </div>
                        )}
                        {searchHit && Array.isArray(searchHit) && (
                            <div className="space-y-1 mb-2">
                                <p className="text-[8px] uppercase opacity-50">{searchHit.length} matches — tap to message:</p>
                                {searchHit.map(h => (
                                    <div key={h.id} className="w-full flex items-center gap-2 bg-white/5 border border-white/10 rounded p-2">
                                        <button onClick={() => openThreadWith(h.id, h.displayName)} className="flex items-center gap-2 flex-1 min-w-0 text-left">
                                            <img src={h.photoURL || 'https://placehold.co/40?text=U'} className="w-7 h-7 rounded-full object-cover"/>
                                            <div className="flex-1 min-w-0"><span className="text-[11px] font-bold block truncate">@{h.displayName}</span><span className="text-[8px] font-mono opacity-50 truncate">{h.publicUid || h.id}</span></div>
                                        </button>
                                        <AddFriendButton myProfile={profile} myUid={myUid} targetUid={h.id} targetName={h.displayName} />
                                    </div>
                                ))}
                            </div>
                        )}
                        {searchHit && !Array.isArray(searchHit) && (
                            <button onClick={() => openThreadWith(searchHit.id, searchHit.displayName)} className="w-full flex items-center gap-2 bg-lime-900/20 border border-lime-500/40 rounded p-2 mb-2 text-left">
                                <img src={searchHit.photoURL || 'https://placehold.co/40?text=U'} className="w-8 h-8 rounded-full object-cover"/>
                                <span className="text-xs font-bold flex-1">@{searchHit.displayName}</span>
                                <span className="text-[9px] text-lime-400 font-black uppercase">Start Chat →</span>
                            </button>
                        )}
                        <div className="space-y-2 max-h-[45vh] overflow-y-auto pr-1">
                            {list.length === 0 && <p className="text-center opacity-50 text-xs py-6">No conversations yet. Search a raver above to start one!</p>}
                            {list.map(t => {
                                const other = otherOf(t); const un = t.unread?.[myUid] || 0;
                                const preview = t.lastMessage ? rkDec(t.lastMessage, rkKey(myUid, other)) : '';
                                return (
                                    <div key={t.id} className={`flex items-center gap-3 p-3 rounded-lg border ${un > 0 ? 'bg-purple-900/30 border-purple-400/50' : 'bg-white/5 border-white/10'}`}>
                                        <button onClick={() => toggleFav(t)} className={t.favorites?.[myUid] ? 'text-yellow-400' : 'text-white/20'}><Star size={20} fill={t.favorites?.[myUid] ? 'currentColor' : 'none'}/></button>
                                        <button onClick={() => openThreadWith(other, t.names?.[other])} className="flex-1 min-w-0 text-left">
                                            <p className="text-sm font-bold truncate flex items-center gap-1">@{t.names?.[other] || 'Raver'} {un > 0 && <span className="bg-pink-600 text-white text-[10px] font-black rounded-full px-2 py-0.5">{un}</span>}</p>
                                            <p className="text-xs opacity-50 truncate">{t.lastSender === myUid ? 'You: ' : ''}{preview}</p>
                                        </button>
                                        <span className="text-[9px] opacity-40 shrink-0">{t.lastAt ? new Date(t.lastAt).toLocaleDateString() : ''}</span>
                                    </div>
                                );
                            })}
                        </div>
                        <p className="text-[8px] text-center text-lime-400/70 mt-3">🔒 All chats are encrypted — only you and the recipient can read them.</p>
                    </>)}

                    {tab === 'msgs' && activeThread && (<>
                        <div className="flex items-center justify-between mb-2 bg-white/10 rounded-lg p-3 border border-purple-500/30">
                            <button onClick={() => { setActiveThread(null); setActiveOtherUid(null); }} className="flex items-center gap-1 text-sm text-cyan-400 font-bold"><ChevronLeft size={20}/> Back</button>
                            <button onClick={() => { if (onViewProfile && activeOtherUid) { onClose(); onViewProfile(activeOtherUid); } }} className="text-base font-black truncate px-2 hover:text-pink-300 transition active:scale-95" title="View profile">@{activeName}</button>
                            <div className="flex items-center gap-2 shrink-0">
                                <button onClick={async () => { if (!threadDoc?.obliterate) { if (window.confirm('💥 OBLITERATE this chat?\n\nA 24-hour countdown starts. If BOTH of you agree, it deletes immediately. If the timer runs out, it deletes anyway — gone forever for both.')) { try { await requestObliterate(activeThread, myUid, activeOtherUid, profile?.displayName); } catch (e) {} } } }} className="text-orange-400 hover:text-orange-300" title="Obliterate chat"><Bomb size={16}/></button>
                                <button onClick={delThread} className="text-red-400" title="Delete chat log (your side)"><Trash2 size={18}/></button>
                            </div>
                        </div>
                        {threadDoc?.obliterate?.deadline && (
                            <div className="mb-2 bg-orange-950/60 border border-orange-500/50 rounded-lg p-3">
                                {(() => { const ob = threadDoc.obliterate; const left = Math.max(0, ob.deadline - obTick); const h = Math.floor(left/3600000), m = Math.floor((left%3600000)/60000), s = Math.floor((left%60000)/1000); const iAccepted = ob.accepted?.[myUid]; const theyAccepted = ob.accepted?.[activeOtherUid]; return (
                                    <div>
                                        <p className="text-[11px] font-black text-orange-300 flex items-center gap-1"><Bomb size={12}/> OBLITERATE PENDING — self-destruct in {h}h {m}m {s}s</p>
                                        <p className="text-[9px] text-orange-100 mt-1">{iAccepted ? '✅ You agreed.' : '⏳ You haven\'t agreed yet.'} {theyAccepted ? '✅ They agreed.' : '⏳ Waiting on them.'} If the timer ends, this chat deletes regardless.</p>
                                        <div className="flex gap-2 mt-2">
                                            {!iAccepted && <button onClick={() => acceptObliterate(activeThread, myUid)} className="text-[10px] font-bold bg-orange-600/50 text-orange-100 border border-orange-400/50 rounded px-3 py-1">Agree to Obliterate</button>}
                                            <button onClick={() => cancelObliterate(activeThread)} className="text-[10px] font-bold bg-white/10 text-white/70 rounded px-3 py-1">Cancel</button>
                                        </div>
                                    </div>
                                ); })()}
                            </div>
                        )}
                        <div className="h-[55vh] overflow-y-auto bg-black/40 rounded-lg p-3 space-y-3 flex flex-col">
                            {msgs.length === 0 && <p className="text-center opacity-40 text-sm py-10">No messages yet. Say hi! 👋</p>}
                            {msgs.map(m => {
                                const mine = m.sender === myUid;
                                return (
                                    <div key={m.id} className={`max-w-[82%] ${mine ? 'self-end' : 'self-start'}`}>
                                        {!mine && m.badge && <div className="flex items-center gap-1 mb-0.5 ml-1"><span className="text-[10px] font-bold text-pink-300">@{activeName}</span><BadgeChip badge={m.badge} /></div>}
                                        <div className={`px-4 py-2.5 rounded-2xl text-sm relative group leading-relaxed ${mine ? 'bg-purple-600/70 rounded-br-md' : 'bg-white/15 rounded-bl-md'}`}>
                                            <p className={"whitespace-pre-wrap break-words " + getUserTextStyle(m.ts).className} style={getUserTextStyle(m.ts).style}>{rkDec(m.text, threadKey)}</p>
                                            {mine && <button onClick={() => delMsg(m)} className="absolute -left-6 top-2 text-red-400 opacity-40 hover:opacity-100"><Trash size={14}/></button>}
                                        </div>
                                        <p className={`text-[9px] opacity-40 mt-1 ${mine ? 'text-right' : ''}`}>{new Date(m.at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</p>
                                    </div>
                                );
                            })}
                        </div>
                        <div className="flex gap-2 mt-3">
                            <button onClick={() => { if (!isEffVIP(profile)) { alert('🔤 The Font & Style selector is a VIP perk. Unlock it (plus Themes, Banners & Boosts) — or enjoy it free during launch!'); return; } setMsgFontOpen(true); }} className={"shrink-0 w-10 rounded border flex items-center justify-center " + (isEffVIP(profile) ? "bg-fuchsia-600/30 border-fuchsia-500/40 text-fuchsia-200 hover:bg-fuchsia-600/50" : "bg-white/5 border-white/15 text-white/40")} title={isEffVIP(profile) ? "Message font style (VIP)" : "Message font style — VIP only"}><span className="text-sm font-black">A</span></button>
                            <Input value={input} onChange={setInput} placeholder="Spread PLUR..." className="mb-0 flex-1"/>
                            <Button onClick={send} disabled={sending || !input.trim()} color="purple" className="px-4"><Send size={18}/></Button>
                        </div>
                        <p className="text-[8px] text-center text-lime-400/70 mt-2">🔒 Encrypted · Deleted messages are gone forever for both users.</p>
                        <FontSelectorModal user={user} profile={profile} isOpen={msgFontOpen} onClose={() => setMsgFontOpen(false)} field="msgTextStyle" titleLabel="Message Font & Style" zClass="z-[200]" />
                    </>)}

                    {tab === 'alerts' && (<>
                        <select value={notifFilter} onChange={e => setNotifFilter(e.target.value)} className="bg-black border border-white/20 text-[10px] p-2 rounded w-full mb-2">
                            <option value="all">All Notifications</option>
                            {NOTIF_INAPP_TYPES.map(t => <option key={t.id} value={t.id}>{t.label}</option>)}
                        </select>
                        <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-1">
                            {visNotifs.length === 0 && <p className="text-center opacity-50 text-xs py-6">No notifications here yet.</p>}
                            {visNotifs.map(n => {
                                const Icon = NOTIF_ICONS[n.type] || Bell;
                                return (
                                    <div key={n.id} onClick={() => { try { if (!n.read) setDoc(doc(db, 'artifacts', appId, 'users', myUid, 'notifications', n.id), { read: true }, { merge: true }); } catch (e) {} if (n.type !== 'friendreq' && onNotifNav) onNotifNav(n); }} className={`flex items-start gap-2 p-2 rounded border cursor-pointer hover:brightness-125 transition ${!n.read ? 'bg-pink-900/30 border-pink-500/50' : 'bg-white/5 border-white/10'}`}>
                                        <Icon size={15} className="text-pink-300 shrink-0 mt-0.5"/>
                                        <div className="flex-1 min-w-0">
                                            <p className="text-[12px] text-white font-medium break-words leading-snug">{n.text}</p>
                                            <p className="text-[9px] text-cyan-300/70">{new Date(n.at).toLocaleString()}{n.type !== 'friendreq' && <span className="text-pink-300 ml-1">· tap to view →</span>}</p>
                                            {n.type === 'friendreq' && n.refId && !(profile?.friends || []).includes(n.refId) && (
                                                <div className="flex gap-2 mt-1">
                                                    <button onClick={async () => { try { await acceptFriend(myUid, n.refId); pushNotif(n.refId, 'friendreq', '✅ @' + (profile?.displayName || 'A raver') + ' accepted your friend request! You are now friends.', myUid); } catch (e) {} }} className="text-[9px] font-bold bg-lime-600/40 text-lime-200 border border-lime-400/40 rounded px-2 py-0.5">Accept</button>
                                                </div>
                                            )}
                                            {n.type === 'friendreq' && n.refId && (profile?.friends || []).includes(n.refId) && <p className="text-[8px] text-lime-400 mt-0.5">✅ Friends</p>}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </>)}
                </Card>
            </div>
        </div>, document.body
    );
};

const BannerModal = ({ user, profile, isOpen, onClose, onGoVip }) => {
    const [bTab, setBTab] = useState('post');
    const [bMode, setBMode] = useState('msg');
    const [slots, setSlots] = useState([]);
    const [text, setText] = useState('');
    const [customLink, setCustomLink] = useState('');
    const [chosenLink, setChosenLink] = useState(null);
    const [busy, setBusy] = useState(false);
    const [confirmation, setConfirmation] = useState(null);
    const W = 900000; // 15 minutes

    useEffect(() => {
        if (!isOpen) return;
        return onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'bannerSlots')), s => setSlots(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log(e));
    }, [isOpen]);

    if (!isOpen) return null;

    const todayKey = new Date().toDateString();
    const usedToday = profile?.bannerDay === todayKey ? (profile?.bannerCountToday || 0) : 0;
    const mySocials = SOCIAL_PLATFORMS.filter(p => profile?.socialLinks?.[p.id]);

    const pickSocial = (p) => {
        const url = 'https://' + p.baseUrl + profile.socialLinks[p.id];
        const v = validateSocialLink(url);
        if (!v.ok) return alert(v.reason);
        setChosenLink({ url: v.clean, label: p.name + ': ' + profile.socialLinks[p.id] });
    };
    const useCustomLink = () => {
        const v = validateSocialLink(customLink);
        if (!v.ok) return alert('Link rejected: ' + v.reason);
        setChosenLink({ url: v.clean, label: v.clean.replace('https://', '').slice(0, 50) });
    };

    const submitBanner = async () => {
        if (!RK_CFG.bannersEnabled) return alert('Banner posting is temporarily disabled by the admin team.');
        const isSocial = bMode === 'social';
        if (isSocial && !chosenLink) return alert("Pick one of your saved socials or validate a custom link first.");
        if (!isSocial && !text.trim()) return alert("Type your banner message first.");
        if (usedToday >= 5) return alert("Daily limit reached — 5 banner posts per day (messages and social links combined). Resets at midnight.");
        setBusy(true);
        try {
            const now = Date.now();
            const curStart = Math.floor(now / W) * W;
            const taken = new Set(slots.map(s => s.start));
            let assigned = [];
            if (!taken.has(curStart)) { assigned = [curStart, curStart + W]; } // missed-window rule: remainder + next full block
            else { let s = curStart + W; while (taken.has(s)) s += W; assigned = [s]; }
            const bodyText = isSocial ? ('Follow me → ' + chosenLink.label) : text.trim().slice(0, 90);
            const payload = { uid: user.uid, name: profile?.displayName || 'VIP Raver', ownerPublicUid: profile?.publicUid || user.uid, text: bodyText, type: isSocial ? 'social' : 'message', linkUrl: isSocial ? chosenLink.url : null, postedAt: now };
            for (const st of assigned) { await setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'bannerSlots', String(st)), { ...payload, start: st, end: st + W }); }
            await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { bannerPosts: increment(1), bannerDay: todayKey, bannerCountToday: usedToday + 1 }, { merge: true });
            const startsAt = assigned[0], endsAt = assigned[assigned.length - 1] + W;
            const queueAhead = slots.filter(s => s.start >= Date.now() && s.start < startsAt && s.uid !== user.uid).length;
            setConfirmation({ startsAt, endsAt, queueAhead, live: startsAt <= Date.now() });
            setText(''); setChosenLink(null); setCustomLink('');
        } catch (e) { alert("Banner failed: " + e.message); } finally { setBusy(false); }
    };

    const fmtT = (t) => new Date(t).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    const history = [...slots].sort((a, b) => b.start - a.start);
    const upcoming = slots.filter(s => s.start > Date.now()).sort((a, b) => a.start - b.start);

    return (
        <Modal isOpen={isOpen} onClose={onClose} title="📢 Banner Messages">
            <div className="flex gap-2 mb-3">
                <button onClick={() => setBTab('post')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${bTab === 'post' ? 'bg-cyan-600 text-white' : 'bg-white/5 text-white/50'}`}>Post Banner</button>
                <button onClick={() => setBTab('history')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${bTab === 'history' ? 'bg-purple-600 text-white' : 'bg-white/5 text-white/50'}`}>All Banners</button>
            </div>

            {bTab === 'post' && (!isEffVIP(profile) ? (
                <div className="text-center space-y-3 py-4">
                    <Crown size={36} className="mx-auto text-yellow-400"/>
                    <p className="text-xs opacity-80">Banner Messages are a <strong>VIP subscriber</strong> feature. Put your message — or your social links — in rotation on the live marquee that every raver sees!</p>
                    <Button onClick={() => { onClose(); onGoVip(); }} color="gold" className="w-full">Unlock VIP</Button>
                </div>
            ) : (
                <div className="space-y-3">
                    <div className="bg-white/5 border border-white/10 rounded p-2 text-[9px] text-gray-100 leading-relaxed">
                        <strong className="text-cyan-400">How it works:</strong> Your banner joins the scrolling marquee for a <strong>15-minute window</strong> (windows start on the dot: :00, :15, :30, :45). One banner runs at a time — submissions queue for the next free window; an empty current window grants its remainder <strong>plus</strong> the next full block. You can post a <strong>message OR one of your social links</strong> — each counts as one of your <strong>5 daily posts</strong>. The daily limit resets at <strong>midnight</strong>. Social links are safety-checked and restricted to verified platforms.
                    </div>
                    {confirmation && (
                        <div className="bg-lime-900/30 border border-lime-400/60 rounded p-3 text-center">
                            <p className="text-xs font-bold text-lime-300">{confirmation.live ? '🟢 Your banner is LIVE NOW!' : '✅ Banner queued!'}</p>
                            <p className="text-[10px] mt-1">Window: <strong>{fmtT(confirmation.startsAt)} – {fmtT(confirmation.endsAt)}</strong></p>
                            {!confirmation.live && <p className="text-[9px] opacity-70">Queue position: #{confirmation.queueAhead + 1}</p>}
                        </div>
                    )}
                    <div className="flex gap-2">
                        <button onClick={() => setBMode('msg')} className={`flex-1 py-1.5 rounded-full text-[9px] font-black uppercase ${bMode === 'msg' ? 'bg-cyan-500 text-black' : 'bg-white/5 text-white/50'}`}>💬 Message</button>
                        <button onClick={() => setBMode('social')} className={`flex-1 py-1.5 rounded-full text-[9px] font-black uppercase ${bMode === 'social' ? 'bg-pink-500 text-black' : 'bg-white/5 text-white/50'}`}>🔗 Social Link</button>
                    </div>
                    {bMode === 'msg' ? (
                        <div>
                            <textarea value={text} onChange={e => setText(e.target.value)} maxLength={90} placeholder="Your marquee message (90 chars max)..." className="w-full p-2 rounded bg-white/10 border-2 border-white/30 text-xs h-16"/>
                            <p className="text-[8px] text-right opacity-50">{text.length}/90 · {5 - usedToday} posts left today</p>
                        </div>
                    ) : (
                        <div className="space-y-2">
                            {mySocials.length > 0 && (<>
                                <p className="text-[9px] font-bold text-pink-400 uppercase">Your saved socials:</p>
                                <div className="grid grid-cols-2 gap-1">
                                    {mySocials.map(p => (
                                        <button key={p.id} onClick={() => pickSocial(p)} className={`flex items-center gap-1.5 p-2 rounded border text-left ${chosenLink?.label?.startsWith(p.name) ? 'border-pink-400 bg-pink-900/30' : 'border-white/10 bg-white/5'}`}>
                                            <p.icon size={12} color={p.color}/><span className="text-[9px] font-bold truncate">{p.name}</span>
                                        </button>
                                    ))}
                                </div>
                            </>)}
                            <div className="flex gap-1">
                                <input value={customLink} onChange={e => setCustomLink(e.target.value)} placeholder="…or paste a social link" className="flex-1 p-2 rounded bg-white/10 border-2 border-white/30 text-[10px]"/>
                                <Button onClick={useCustomLink} color="cyan" className="text-[9px] px-2">Check</Button>
                            </div>
                            {chosenLink && <p className="text-[9px] text-lime-300 bg-lime-900/20 border border-lime-500/40 rounded p-1.5">✅ Verified: {chosenLink.label}</p>}
                            <p className="text-[8px] opacity-50 text-right">{5 - usedToday} posts left today</p>
                        </div>
                    )}
                    {upcoming.length > 0 && <p className="text-[8px] opacity-60">⏳ {upcoming.length} banner(s) currently queued — next free window assigned automatically.</p>}
                    <Button onClick={submitBanner} disabled={busy || usedToday >= 5} color="cyan" className="w-full">{busy ? "Posting..." : bMode === 'social' ? "Post Social Link to Marquee" : "Post to Marquee"}</Button>
                </div>
            ))}

            {bTab === 'history' && (
                <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-1">
                    {history.length === 0 && <p className="text-center opacity-50 text-xs py-6">No banners posted yet — be the first!</p>}
                    {history.map(s => (
                        <div key={s.id} className={`bg-white/5 p-2 rounded border ${s.start <= Date.now() && Date.now() < s.end ? 'border-lime-400/60' : 'border-white/10'}`}>
                            <div className="flex justify-between items-center">
                                <span className="text-[10px] font-bold text-cyan-300">@{s.name} {s.type === 'social' && <span className="text-[7px] bg-pink-500/30 text-pink-300 px-1 rounded uppercase">Social</span>}</span>
                                <span className="text-[8px] opacity-50">{new Date(s.start).toLocaleDateString()} {fmtT(s.start)}–{fmtT(s.end)}</span>
                            </div>
                            <p className="text-[11px] text-gray-100 mt-1 break-words">{s.text}</p>
                            {s.start <= Date.now() && Date.now() < s.end && <span className="text-[7px] bg-lime-500 text-black font-black px-1 rounded uppercase">Live Now</span>}
                        </div>
                    ))}
                </div>
            )}
        </Modal>
    );
};

const BoostModal = ({ user, profile, isOpen, onClose, onGoVip, onGoSell }) => {
    const [bTab, setBTab] = useState('boost');
    const [slots, setSlots] = useState([]);
    const [myItems, setMyItems] = useState([]);
    const [pick, setPick] = useState(null);
    const [busy, setBusy] = useState(false);
    const [confirmation, setConfirmation] = useState(null);
    const H = 3600000; // 1 hour

    useEffect(() => {
        if (!isOpen) return;
        const u1 = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'boostSlots')), s => setSlots(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log(e));
        getDocs(query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('ownerId', '==', user.uid)))
            .then(s => setMyItems(s.docs.map(d => ({ ...d.data(), id: d.id })).filter(i => !i.isRequest && !i.isDIYRequest && i.status !== 'request')))
            .catch(() => {});
        return () => u1();
    }, [isOpen, user]);

    if (!isOpen) return null;

    const todayKey = new Date().toDateString();
    const usedToday = profile?.boostDay === todayKey ? (profile?.boostCountToday || 0) : 0;
    const fmtT = (t) => new Date(t).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    const submitBoost = async () => {
        if (!RK_CFG.boostsEnabled) return alert('Post boosting is temporarily disabled by the admin team.');
        if (!pick) return alert("Select one of your posts to boost.");
        if (usedToday >= 3) return alert("Daily limit reached — 3 boosts per day. Resets at midnight.");
        setBusy(true);
        try {
            const now = Date.now();
            let start = Math.ceil(now / H) * H; // boosts start exactly on a fresh hour
            const countAt = (st) => slots.filter(s => s.start === st).length;
            while (countAt(start) >= 5) start += H; // 5 boost lanes per hour, then queue
            const lane = countAt(start);
            await setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'boostSlots', start + '_' + lane), {
                uid: user.uid, name: profile?.displayName || 'VIP Raver', ownerPublicUid: profile?.publicUid || user.uid,
                itemId: pick.id, itemName: pick.name, start, end: start + H, lane, postedAt: now
            });
            await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { boostDay: todayKey, boostCountToday: usedToday + 1, boostsUsed: increment(1) }, { merge: true });
            const queueAhead = slots.filter(s => s.start >= now && s.start < start).length;
            setConfirmation({ start, end: start + H, lane, queueAhead });
            setPick(null);
        } catch (e) { alert("Boost failed: " + e.message); } finally { setBusy(false); }
    };

    const history = [...slots].sort((a, b) => b.start - a.start);

    return (
        <Modal isOpen={isOpen} onClose={onClose} title="⚡ Post Boosts">
            <div className="flex gap-2 mb-3">
                <button onClick={() => setBTab('boost')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${bTab === 'boost' ? 'bg-pink-600 text-white' : 'bg-white/5 text-white/50'}`}>Boost a Post</button>
                <button onClick={() => setBTab('history')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${bTab === 'history' ? 'bg-purple-600 text-white' : 'bg-white/5 text-white/50'}`}>All Boosts</button>
            </div>

            {bTab === 'boost' && (!isEffVIP(profile) ? (
                <div className="text-center space-y-3 py-4">
                    <Crown size={36} className="mx-auto text-yellow-400"/>
                    <p className="text-xs opacity-80">Post Boosts are a <strong>VIP subscriber</strong> feature. Pin your item to the top 5 feed slots for a full hour!</p>
                    <Button onClick={() => { onClose(); onGoVip(); }} color="gold" className="w-full">Unlock VIP</Button>
                </div>
            ) : (
                <div className="space-y-3">
                    <div className="bg-white/5 border border-white/10 rounded p-2 text-[9px] text-gray-100 leading-relaxed">
                        <strong className="text-pink-400">How it works:</strong> Boosted posts get pinned into the <strong>top 5 feed slots</strong> with a ⚡ BOOSTED badge for <strong>1 hour</strong>. Boost windows start exactly on the hour — up to 5 boosts run per hour; extras queue for the next free hour. Limit: <strong>3 boosts/day</strong>.
                    </div>
                    {confirmation && (
                        <div className="bg-lime-900/30 border border-lime-400/60 rounded p-3 text-center">
                            <p className="text-xs font-bold text-lime-300">✅ Boost scheduled!</p>
                            <p className="text-[10px] mt-1">Window: <strong>{fmtT(confirmation.start)} – {fmtT(confirmation.end)}</strong> · Lane {confirmation.lane + 1}/5</p>
                            {confirmation.queueAhead > 0 && <p className="text-[9px] opacity-70">{confirmation.queueAhead} boost(s) scheduled before yours.</p>}
                        </div>
                    )}
                    <p className="text-[9px] font-bold text-pink-400 uppercase">Pick a post ({3 - usedToday} boosts left today):</p>
                    <div className="space-y-1 max-h-[28vh] overflow-y-auto pr-1">
                        {myItems.length === 0 && <p className="text-center opacity-50 text-[10px] py-4">You have no live posts yet.</p>}
                        {myItems.map(i => (
                            <button key={i.id} onClick={() => setPick(i)} className={`w-full flex items-center gap-2 p-2 rounded border text-left ${pick?.id === i.id ? 'border-pink-400 bg-pink-900/30' : 'border-white/10 bg-white/5'}`}>
                                <img src={i.mediaUrls?.[0]?.url || i.imageUrl || 'https://placehold.co/40'} className="w-8 h-8 rounded object-cover"/>
                                <span className="text-[10px] font-bold flex-1 truncate">{i.name}</span>
                                <span className="text-[9px] text-lime-400">${i.price?.toFixed(2)}</span>
                            </button>
                        ))}
                    </div>
                    <button onClick={() => { onClose(); onGoSell(); }} className="w-full text-[9px] text-cyan-400 underline">…or create a new post in the Trade Hub, then come back and boost it</button>
                    <Button onClick={submitBoost} disabled={busy || !pick || usedToday >= 3} color="primary" className="w-full">{busy ? "Scheduling..." : "Boost for 1 Hour ⚡"}</Button>
                </div>
            ))}

            {bTab === 'history' && (
                <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-1">
                    {history.length === 0 && <p className="text-center opacity-50 text-xs py-6">No boosts yet.</p>}
                    {history.map(s => (
                        <div key={s.id} className={`bg-white/5 p-2 rounded border ${s.start <= Date.now() && Date.now() < s.end ? 'border-lime-400/60' : 'border-white/10'}`}>
                            <div className="flex justify-between items-center">
                                <span className="text-[10px] font-bold text-pink-300">@{s.name}</span>
                                <span className="text-[8px] opacity-50">{new Date(s.start).toLocaleDateString()} {fmtT(s.start)}–{fmtT(s.end)}</span>
                            </div>
                            <p className="text-[10px] text-gray-100 mt-1">⚡ Boosted: <strong>{s.itemName}</strong> (lane {(s.lane || 0) + 1})</p>
                            {s.start <= Date.now() && Date.now() < s.end && <span className="text-[7px] bg-lime-500 text-black font-black px-1 rounded uppercase">Live Now</span>}
                        </div>
                    ))}
                </div>
            )}
        </Modal>
    );
};
EOF

# Block 9
cat << 'EOF' >> src/App.js
const MainSettingsModal = ({ user, profile, isOpen, onClose, onReplayTutorial }) => {
    const [txtScale, setTxtScale] = useState(() => { try { return parseFloat(localStorage.getItem('rk_text_scale')) || 1; } catch (e) { return 1; } });
    const applyScale = (v) => { setTxtScale(v); try { localStorage.setItem('rk_text_scale', String(v)); } catch (e) {} window.dispatchEvent(new CustomEvent('rk-text-scale', { detail: v })); };
    const [showTicket, setShowTicket] = useState(false);
    const [phone, setPhone] = useState('');
    const [email, setEmail] = useState(''); 
    const [prefs, setPrefs] = useState({ phone: {}, email: {} });
    const [newUid, setNewUid] = useState('');
    const [loading, setLoading] = useState(false);
    // V53.1: password management
    const [curPass, setCurPass] = useState('');
    const [newPass, setNewPass] = useState('');
    const [newPass2, setNewPass2] = useState('');
    const [pwBusy, setPwBusy] = useState(false);

    // Does this account have a password (email/password provider) yet?
    const hasPassword = !!(user?.providerData || []).find(p => p.providerId === 'password');
    const hasGoogle = !!(user?.providerData || []).find(p => p.providerId === 'google.com');

    useEffect(() => { 
        if(profile?.notificationPreferences) setPrefs(profile.notificationPreferences); 
        if(profile?.phoneNumber) setPhone(profile.phoneNumber); 
        if(user?.email) setEmail(user.email); 
    }, [profile, user]);

    const changePassword = async () => {
        if (user?.isAnonymous) { alert("Guest accounts can't set a password. Create a full account first."); return; }
        if (!newPass || newPass.length < 6) { alert("New password must be at least 6 characters."); return; }
        if (newPass !== newPass2) { alert("The two new-password fields don't match."); return; }
        setPwBusy(true);
        try {
            if (hasPassword) {
                // Existing password → require the current one to re-authenticate, then update.
                if (!curPass) { alert("Enter your current password first."); setPwBusy(false); return; }
                const cred = EmailAuthProvider.credential(user.email, curPass);
                await reauthenticateWithCredential(user, cred);
                await updatePassword(user, newPass);
                alert("✅ Password updated! Use your new password next time you log in.");
            } else {
                // No password yet (e.g. Google account) → LINK an email/password credential so
                // they can ALSO log in with email + password going forward.
                if (!user.email) { alert("Your account has no email on file, so a password can't be added."); setPwBusy(false); return; }
                const cred = EmailAuthProvider.credential(user.email, newPass);
                await linkWithCredential(user, cred);
                alert("✅ Password added! You can now log in with your email (" + user.email + ") and this password, in addition to Google.");
            }
            setCurPass(''); setNewPass(''); setNewPass2('');
        } catch (e) {
            const c = e?.code || '';
            if (c === 'auth/wrong-password' || c === 'auth/invalid-credential') alert("Your current password is incorrect. If you forgot it, log out and use 'Forgot password?'.");
            else if (c === 'auth/requires-recent-login') alert("For security, please log out and back in, then change your password.");
            else if (c === 'auth/email-already-in-use' || c === 'auth/provider-already-linked') alert("This account already has a password set.");
            else if (c === 'auth/weak-password') alert("Please choose a stronger password (at least 6 characters).");
            else alert("Couldn't update password: " + (e.message || c));
        } finally { setPwBusy(false); }
    };
    
    const togglePref = (type, channel) => { setPrefs(prev => ({ ...prev, [channel]: { ...prev[channel], [type]: !prev[channel]?.[type] } })); };
    const handleLogout = async () => { await signOut(auth); onClose(); };
    
    const changeUid = async () => {
        if(!newUid || newUid.length < 5) return alert("UID must be at least 5 characters.");
        if(profile?.publicUidChanged) return alert("UID can only be changed once.");
        if(!window.confirm("Are you sure? This cannot be undone.")) return;
        setLoading(true);
        try {
            const batch = writeBatch(db);
            const userRef = doc(db, 'artifacts', appId, 'users', user.uid);
            const oldUids = profile?.pastPublicUids || [];
            
            batch.update(userRef, { publicUid: newUid, publicUidChanged: true, pastPublicUids: [...oldUids, profile?.publicUid || user.uid] });
            
            const qTrade = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('ownerId', '==', user.uid));
            const posts = await getDocs(qTrade);
            posts.forEach(d => { batch.update(d.ref, { ownerPublicUid: newUid, ownerName: profile.displayName }); });
            
            const qInv = query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'));
            const invs = await getDocs(qInv);
            invs.forEach(doc => { batch.update(doc.ref, { ownerName: profile.displayName }); });
            
            await batch.commit();
            alert("Public UID Permanently Changed.");
        } catch(e) { alert(e.message); } finally { setLoading(false); }
    };

    const saveSettings = async () => { 
        if(!user?.uid) return;
        const updates = { notificationPreferences: prefs }; 
        if(phone) { updates.phoneNumber = phone; await addDoc(collection(db, 'artifacts', appId, 'promo_logs'), { type: 'phone_update', phone, uid: user.uid, timestamp: Date.now() }); } 
        await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), updates, { merge: true });
        if(email && email !== user.email) { try { await updateEmail(user, email); alert("Email Updated!"); } catch(e) { alert("Email Error: " + e.message); } } 
        alert("Settings Saved!");
    };

    if(!isOpen) return null; 
    return ( <Modal isOpen={isOpen} onClose={onClose} title="Settings"><div className="space-y-4 max-h-[60vh] overflow-y-auto pr-1">
        
        <div className="border-b border-white/10 pb-4">
            <h4 className="font-bold text-xs mb-2 text-pink-400">Public UID (Friend Code)</h4>
            {profile?.publicUidChanged ? (
                <p className="text-[10px] opacity-50 bg-black/50 p-2 rounded">Your UID is permanently locked to: <span className="text-lime-400">{profile.publicUid}</span></p>
            ) : (
                <>
                    <Input value={newUid} onChange={setNewUid} placeholder={profile?.publicUid || user?.uid}/>
                    <p className="text-[8px] text-red-400 mb-2">WARNING: You can only change your Public UID ONCE.</p>
                    <Button onClick={changeUid} disabled={loading} color="accent" className="text-[10px]">Set Permanent UID</Button>
                </>
            )}
        </div>

        <div className="border-b border-white/10 pb-4"><h4 className="font-bold text-xs mb-2 text-pink-400">Contact Info</h4><Input value={phone} onChange={setPhone} placeholder="Phone Number" className="mb-2"/><Input value={email} onChange={setEmail} placeholder="Email Address"/></div>

        {!user?.isAnonymous && (
            <div className="border-b border-white/10 pb-4">
                <h4 className="font-bold text-xs mb-2 text-pink-400">🔐 {hasPassword ? 'Change Password' : 'Add a Password'}</h4>
                {!hasPassword && <p className="text-[9px] text-cyan-300 bg-cyan-900/20 border border-cyan-500/30 rounded p-2 mb-2">Your account uses {hasGoogle ? 'Google' : 'social'} sign-in and has no password yet. Add one to also log in with your email{user?.email ? ' (' + user.email + ')' : ''} and a password.</p>}
                {hasPassword && <Input type="password" value={curPass} onChange={setCurPass} placeholder="Current password" className="mb-2"/>}
                <Input type="password" value={newPass} onChange={setNewPass} placeholder={hasPassword ? "New password" : "Choose a password"} className="mb-2"/>
                <Input type="password" value={newPass2} onChange={setNewPass2} placeholder="Confirm new password" className="mb-2"/>
                <Button onClick={changePassword} disabled={pwBusy} color="lime" className="text-[10px] w-full">{pwBusy ? 'Saving…' : (hasPassword ? 'Update Password' : 'Add Password')}</Button>
            </div>
        )}
        <div className="border-b border-white/10 pb-4"><h4 className="font-bold text-xs mb-3 text-cyan-400">Notifications</h4><div className="grid grid-cols-3 gap-2 text-[10px] mb-2 font-bold opacity-70"><span>Type</span><span className="text-center">Phone</span><span className="text-center">Email</span></div>{NOTIFICATION_TYPES.map(type => (<div key={type.id} className="grid grid-cols-3 gap-2 items-center mb-2 text-[10px]"><span className="truncate">{type.label}</span><div className="flex justify-center"><button onClick={() => togglePref(type.id, 'phone')} className={`${prefs.phone?.[type.id] ? 'text-lime-400' : 'text-white/20'}`}>{prefs.phone?.[type.id] ? <CheckSquare size={16}/> : <Square size={16}/>}</button></div><div className="flex justify-center"><button onClick={() => togglePref(type.id, 'email')} className={`${prefs.email?.[type.id] ? 'text-lime-400' : 'text-white/20'}`}>{prefs.email?.[type.id] ? <CheckSquare size={16}/> : <Square size={16}/>}</button></div></div>))}</div>
        <div className="border-b border-white/10 pb-4">
            <h4 className="font-bold text-xs mb-2 text-lime-400">Display</h4>
            <div className="bg-white/5 p-3 rounded border border-white/10 mb-3">
                <div className="flex justify-between items-center mb-2"><span className="text-[11px] font-bold">Text Size</span><span className="text-[11px] font-mono text-lime-400">{Math.round(txtScale * 100)}%</span></div>
                <input type="range" min="0.85" max="1.5" step="0.05" value={txtScale} onChange={e => applyScale(parseFloat(e.target.value))} className="w-full accent-pink-500"/>
                <div className="flex justify-between text-[8px] opacity-50 mt-1"><span>A</span><span className="text-base">A</span></div>
                <p style={{ fontSize: txtScale + 'em' }} className="mt-2 text-center text-gray-200 bg-black/40 rounded p-2 leading-snug">Preview: the quick brown fox 🦊</p>
                {txtScale !== 1 && <button onClick={() => applyScale(1)} className="w-full mt-2 text-[9px] text-cyan-400 underline">Reset to default (100%)</button>}
            </div>
            <button onClick={async () => { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { showPing: profile?.showPing === false ? true : false }, { merge: true }); }} className="w-full flex justify-between items-center bg-white/5 p-2 rounded border border-white/10">
                <span className="text-[10px] font-bold">Show Ping (connection meter)</span>
                {profile?.showPing !== false ? <CheckSquare size={16} className="text-lime-400"/> : <Square size={16} className="text-white/30"/>}
            </button>
            <p className="text-[8px] opacity-50 mt-1">Displays live network latency at the bottom of the screen. On by default for new accounts.</p>
            <button onClick={async () => { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { hideDIYFromOthers: !profile?.hideDIYFromOthers }, { merge: true }); }} className="w-full flex justify-between items-center bg-white/5 p-2 rounded border border-white/10 mt-2">
                <span className="text-[10px] font-bold">Hide my DIY / AI projects from others</span>
                {profile?.hideDIYFromOthers ? <CheckSquare size={16} className="text-lime-400"/> : <Square size={16} className="text-white/30"/>}
            </button>
            <p className="text-[8px] opacity-50 mt-1">When on, your custom DIY builds &amp; AI design concepts stay private — other ravers won't see them in your collection. Your listed items for sale always remain visible.</p>
        </div>

        <div className="border-b border-white/10 pb-4">
            <h4 className="font-bold text-xs mb-3 text-purple-400">In-App Notifications</h4>
            <div className="grid grid-cols-2 gap-2">
                {NOTIF_INAPP_TYPES.filter(t => t.id !== 'admin' || profile?.isAdmin).map(t => (
                    <button key={t.id} onClick={async () => { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { inAppNotifs: { [t.id]: profile?.inAppNotifs?.[t.id] === false ? true : false } }, { merge: true }); }} className="flex justify-between items-center bg-white/5 p-2 rounded border border-white/10 text-[10px]">
                        <span className="truncate mr-1">{t.label}</span>
                        {profile?.inAppNotifs?.[t.id] !== false ? <CheckSquare size={14} className="text-lime-400 shrink-0"/> : <Square size={14} className="text-white/30 shrink-0"/>}
                    </button>
                ))}
            </div>
            <p className="text-[8px] opacity-50 mt-1">Controls which alerts show in your Messenger's Notifications tab. All on by default.</p>
        </div>

        <div className="border-b border-white/10 pb-4 space-y-2">
            <h4 className="font-bold text-xs mb-2 text-yellow-400">Help &amp; Support</h4>
            <Button onClick={() => { if (onReplayTutorial) { onClose(); onReplayTutorial(); } }} color="purple" className="w-full text-[10px] flex items-center justify-center gap-2"><Compass size={14}/> Replay App Tutorial</Button>
            <Button onClick={() => setShowTicket(true)} color="accent" className="w-full text-[10px] flex items-center justify-center gap-2"><HelpCircle size={14}/> Report a Bug / Get Help</Button>
        </div>

        <Button onClick={saveSettings} color="lime" className="w-full text-xs">Save Changes</Button>
        <div className="flex gap-2 mt-4"><Button onClick={handleLogout} color="accent" className="flex-1 text-[10px] bg-red-900/50 border-red-500">{user?.isAnonymous ? "Create Account" : "Log Out"}</Button></div>
        <TicketModal user={user} profile={profile} isOpen={showTicket} onClose={() => setShowTicket(false)}/>
    </div></Modal> );
};
EOF

# Block 10
cat << 'EOF' >> src/App.js
const StripeCheckoutForm = ({ total, onComplete, onCancel }) => {
    const stripe = useStripe();
    const elements = useElements();
    const [loading, setLoading] = useState(false);
    const handlePay = async (e) => {
        e.preventDefault();
        if (!stripe || !elements) return;
        setLoading(true);
        setTimeout(() => {
            alert("Payment Processed Successfully (Test Mode)");
            setLoading(false);
            onComplete();
        }, 2000);
    };
    return (
        <form onSubmit={handlePay} className="space-y-4">
            <div className="bg-white/10 p-3 rounded border border-white/20"><CardElement options={{style:{base:{color:'#fff'}}}}/></div>
            <Button type="submit" disabled={!stripe || loading} color="lime" className="w-full">{loading ? "Processing..." : `Pay $${total.toFixed(2)}`}</Button>
            <Button onClick={onCancel} color="accent" className="w-full">Cancel</Button>
        </form>
    );
};

const CryptoCheckoutForm = ({ total, onComplete, onCancel }) => {
    const solAmount = (total / 150).toFixed(4); 
    const solUri = `solana:${SOLANA_RECEIVER}?amount=${solAmount}&message=RaveKandi+Order`;
    const [showHelp, setShowHelp] = useState(false);
    return (
        <div className="space-y-4 text-center">
            <p className="text-xs text-lime-400 mb-2">Scan with Phantom or Solana Wallet</p>
            <div className="flex justify-center bg-white p-2 rounded inline-block mx-auto">
                <QRCodeCanvas value={solUri} size={150} />
            </div>
            <p className="text-[10px] opacity-70 break-all">{SOLANA_RECEIVER}</p>
            <p className="text-xs font-bold text-pink-400">Total: {solAmount} SOL</p>
            <button onClick={()=>setShowHelp(!showHelp)} className="text-xs text-cyan-400 underline">How do I pay with Crypto?</button>
            {showHelp && (
                <div className="bg-white/5 p-3 rounded text-[10px] text-left border border-cyan-500/30">
                    <p className="font-bold mb-1 text-cyan-400">Recommended Wallets:</p>
                    <ul className="list-disc pl-4 space-y-1 mb-2">
                        <li><a href="https://phantom.app" target="_blank" rel="noreferrer" className="text-pink-400">Phantom</a> (Best for Solana)</li>
                        <li><a href="https://wallet.coinbase.com" target="_blank" rel="noreferrer" className="text-pink-400">Coinbase Wallet</a></li>
                        <li><a href="https://metamask.io" target="_blank" rel="noreferrer" className="text-pink-400">MetaMask</a></li>
                    </ul>
                    <p>Download a wallet, fund it with SOL, and scan the QR code above to pay instantly with zero bank fees.</p>
                </div>
            )}
            <Button onClick={onComplete} color="lime" className="w-full mt-2">I Have Sent The Payment</Button>
            <Button onClick={onCancel} color="accent" className="w-full">Back</Button>
        </div>
    );
};

const ShoppingCartModal = ({ user, items, isOpen, onClose }) => {
    const [cartItems, setCartItems] = useState([]);
    const [selectedIds, setSelectedIds] = useState([]);
    const [qtyMap, setQtyMap] = useState({}); // cart-doc id -> chosen quantity
    // V42.20 Phase 5: effective unit price after bulk-tier discount for a given qty.
    const bulkUnitPrice = (item, qty) => {
        const base = item.price || 0;
        const tiers = (item.bulkTiers && item.bulkTiers.length) ? item.bulkTiers : (item.bulkDiscountQty > 0 ? [{ qty: item.bulkDiscountQty, pct: item.bulkDiscountPct }] : []);
        let pct = 0;
        tiers.forEach(t => { if (qty >= t.qty && t.pct > pct) pct = t.pct; });
        return base * (1 - pct / 100);
    };
    const maxStock = (item) => (item.stockQty !== undefined && item.stockQty !== null) ? Math.max(1, item.stockQty) : 99;
    const getQty = (item) => Math.min(qtyMap[item.id] || 1, maxStock(item));
    const [checkoutMode, setCheckoutMode] = useState('cart');
    
    useEffect(() => {
        if(!isOpen || !user?.uid) return;
        const q = query(collection(db, 'artifacts', appId, 'users', user.uid, 'cart'));
        return onSnapshot(q, s => setCartItems(s.docs.map(d => ({...d.data(), id: d.id}))));
    }, [isOpen, user]);

    // V37.10: live availability — cross-reference each cart entry against the live tradeItems feed
    const getStatus = (entry) => {
        const live = (items || []).find(i => i.id === entry.originalId);
        if (!live || live.status === 'dismissed' || live.removed) return 'cancelled';
        if (live.buyers?.includes(user?.uid)) return 'purchased';
        const stockDefined = live.stockQty !== undefined && live.stockQty !== null;
        if (stockDefined ? live.stockQty <= 0 : (live.purchaseCount || 0) > 0) return 'sold';
        return 'available';
    };
    const enriched = cartItems.map(c => ({ ...c, liveStatus: getStatus(c) }));
    const STATUS_LABELS = { sold: 'UNAVAILABLE FOR PURCHASE: SOLD', cancelled: 'UNAVAILABLE FOR PURCHASE: REMOVED', purchased: 'ALREADY PURCHASED' };
    
    const handleRemove = async (id) => { await deleteDoc(doc(db, 'artifacts', appId, `users/${user.uid}/cart`, id)); setSelectedIds(prev => prev.filter(sid => sid !== id)); };
    const bulkRemove = async (filterKey, label) => {
        const targets = enriched.filter(c => filterKey === 'all' ? true : c.liveStatus === filterKey);
        if (targets.length === 0) return alert("No " + label + " items to remove.");
        if (!window.confirm("Remove " + targets.length + " item(s) from your cart?")) return;
        const batch = writeBatch(db);
        targets.forEach(t => batch.delete(doc(db, 'artifacts', appId, `users/${user.uid}/cart`, t.id)));
        await batch.commit();
        setSelectedIds([]);
    };
    const toggleSelection = (entry) => {
        if (entry.liveStatus !== 'available') return;
        if (selectedIds.includes(entry.id)) setSelectedIds(selectedIds.filter(sid => sid !== entry.id));
        else setSelectedIds([...selectedIds, entry.id]);
    };
    const totalCost = enriched.filter(item => selectedIds.includes(item.id) && item.liveStatus === 'available').reduce((sum, item) => { const q = getQty(item); return sum + bulkUnitPrice(item, q) * q; }, 0);
    
    const startCheckout = () => {
        const blocked = enriched.filter(c => selectedIds.includes(c.id) && c.liveStatus !== 'available');
        if (blocked.length > 0) {
            setSelectedIds(selectedIds.filter(id => !blocked.some(b => b.id === id)));
            return alert("Some selected items just became unavailable and were deselected. Please review your cart.");
        }
        if (selectedIds.length === 0) return;
        setCheckoutMode('select');
    };

    const handleSuccess = async () => {
        if (!RK_CFG.checkoutEnabled) return alert(RK_CFG.maintenanceMessage || 'Checkout is temporarily disabled — try again soon!');
        if (RK_CFG.paymentsLive) return alert('Live payments are not wired into this build yet — the admin team should keep "Payments LIVE" OFF in remote config until real billing ships.');
        try {
            const batch = writeBatch(db);
            let total = 0;
            const buyerRef = doc(db, 'artifacts', appId, 'users', user.uid);
            const buyerSnap = await getDoc(buyerRef);
            const referrerUid = buyerSnap.data()?.referredBy;
            const toBuy = enriched.filter(i => selectedIds.includes(i.id) && i.liveStatus === 'available');

            for (const item of toBuy) {
                total += item.price;
                const itemRef = doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.originalId);
                batch.update(itemRef, { purchaseCount: increment(1), stockQty: increment(-1), buyers: arrayUnion(user.uid) });
                const sellerRef = doc(db, 'artifacts', appId, 'users', item.ownerId);
                batch.update(sellerRef, { itemsSold: increment(1), totalSalesValue: increment(item.price) });
                
                if (referrerUid) {
                    const sellerSnap = await getDoc(sellerRef);
                    const sellerRate = effCommissionRate(sellerSnap.data()?.customCommissionRate, sellerSnap.data()?.lockedCommissionRate);
                    const appCommission = item.price * sellerRate;
                    
                    const refRef = doc(db, 'artifacts', appId, 'users', referrerUid);
                    const refSnap = await getDoc(refRef);
                    if (refSnap.exists()) {
                        const refData = refSnap.data();
                        const tier = getReferralTier(refData?.referrals || 0);
                        const pct = refData?.customRevSharePct ?? tier.sharePct;
                        const revShare = appCommission * (pct / 100);
                        batch.update(refRef, { totalRevShareEarned: increment(revShare) });
                        const refListRef = doc(db, 'artifacts', appId, 'users', referrerUid, 'myReferrals', user.uid);
                        batch.set(refListRef, { earnedFromThisUser: increment(revShare) }, { merge: true });
                    }
                }
                batch.delete(doc(db, 'artifacts', appId, `users/${user.uid}/cart`, item.id));
            }
            batch.update(buyerRef, { itemsBought: increment(toBuy.length), totalBoughtValue: increment(total) });
            await batch.commit();
            toBuy.forEach(it => { if (it.ownerId) pushNotif(it.ownerId, 'sold', '💰 "' + it.name + '" was purchased for $' + (it.price || 0).toFixed(2) + '!', it.originalId); });
            alert("Order Processed Successfully!");
            setSelectedIds([]);
            setCheckoutMode('cart');
            onClose();
        } catch(e) { alert("Checkout Error: " + e.message); }
    };

    if(!isOpen) return null;

    if(checkoutMode === 'select') {
        return (
            <Modal isOpen={isOpen} onClose={() => {setCheckoutMode('cart'); onClose();}} title="Checkout">
                <div className="space-y-4">
                    <div className="bg-black/50 p-3 rounded border border-white/10 text-[10px] opacity-80">
                        <span className="font-bold text-pink-400">Note:</span> Crypto transactions bypass banks offering anonymity and near-zero fees. Standard Card processing (Stripe) requires KYC and includes standard network fees.
                    </div>
                    
                    <div className="bg-lime-900/20 p-2 border-l-2 border-lime-400 text-[10px] mb-2 text-lime-200 opacity-80">
                        <strong>Review System:</strong> Following a successful checkout, you will unlock the ability to rate and leave a permanent review on the original Item Card to help guide the community.
                    </div>

                    <Button onClick={() => setCheckoutMode('stripe')} color="primary" className="w-full flex items-center justify-center gap-2"><CreditCard size={16}/> Pay with Card (Stripe)</Button>
                    <Button onClick={() => setCheckoutMode('crypto')} color="cyan" className="w-full flex items-center justify-center gap-2"><Zap size={16}/> Pay with Crypto (Solana)</Button>
                    <Button onClick={() => setCheckoutMode('cart')} color="accent" className="w-full">Back to Cart</Button>
                </div>
            </Modal>
        )
    }

    if(checkoutMode === 'stripe') {
        return <Modal isOpen={isOpen} onClose={() => {setCheckoutMode('cart'); onClose();}} title="Card Checkout"><Elements stripe={stripePromise}><StripeCheckoutForm total={totalCost} onComplete={handleSuccess} onCancel={()=>setCheckoutMode('select')}/></Elements></Modal>
    }

    if(checkoutMode === 'crypto') {
        return <Modal isOpen={isOpen} onClose={() => {setCheckoutMode('cart'); onClose();}} title="Crypto Checkout"><CryptoCheckoutForm total={totalCost} onComplete={handleSuccess} onCancel={()=>setCheckoutMode('select')}/></Modal>
    }

    return ( 
        <Modal isOpen={isOpen} onClose={onClose} title="Shopping Cart">
            {cartItems.length > 0 && (
                <div className="grid grid-cols-4 gap-1 mb-3">
                    <button onClick={() => bulkRemove('all', 'cart')} className="bg-white/5 hover:bg-red-900/40 border border-white/10 rounded py-1 text-[8px] font-black uppercase">Remove All</button>
                    <button onClick={() => bulkRemove('sold', 'sold')} className="bg-white/5 hover:bg-red-900/40 border border-white/10 rounded py-1 text-[8px] font-black uppercase">Remove Sold</button>
                    <button onClick={() => bulkRemove('cancelled', 'cancelled')} className="bg-white/5 hover:bg-red-900/40 border border-white/10 rounded py-1 text-[8px] font-black uppercase">Remove Cancelled</button>
                    <button onClick={() => bulkRemove('purchased', 'purchased')} className="bg-white/5 hover:bg-red-900/40 border border-white/10 rounded py-1 text-[8px] font-black uppercase">Remove Purchased</button>
                </div>
            )}
            <div className="space-y-4 max-h-[55vh] overflow-y-auto p-1">
                {cartItems.length === 0 && <p className="text-center opacity-50 py-4">Your cart is empty.</p>}
                {enriched.map(item => (
                    <div key={item.id} className={`bg-white/5 p-3 rounded relative ${item.liveStatus !== 'available' ? 'opacity-90' : ''}`}>
                        <div className={`flex items-center gap-3 ${item.liveStatus !== 'available' ? 'grayscale opacity-40 pointer-events-none' : ''}`}>
                            <input type="checkbox" disabled={item.liveStatus !== 'available'} checked={selectedIds.includes(item.id)} onChange={() => toggleSelection(item)} className="accent-lime-400" />
                            <img src={item.mediaUrls?.[0]?.url || item.imageUrl || 'https://placehold.co/50'} className="w-12 h-12 rounded object-cover"/>
                            <div className="flex-1 min-w-0">
                                <p className="text-xs font-bold truncate">{item.name}</p>
                                {(() => { const q = getQty(item); const unit = bulkUnitPrice(item, q); const saved = (item.price||0) - unit; return (
                                    <p className="text-xs text-lime-400">${unit.toFixed(2)}{saved > 0.001 && <span className="text-[8px] text-yellow-300 ml-1">({Math.round((saved/(item.price||1))*100)}% bulk)</span>} {q > 1 && <span className="opacity-60">× {q} = ${(unit*q).toFixed(2)}</span>}</p>
                                ); })()}
                                <div className="flex items-center gap-2 mt-1">
                                    <span className="text-[8px] opacity-50 uppercase">Qty</span>
                                    <button onClick={() => setQtyMap({...qtyMap, [item.id]: Math.max(1, getQty(item) - 1)})} className="w-6 h-6 rounded bg-white/10 hover:bg-white/20 text-sm font-bold leading-none">−</button>
                                    <span className="text-xs font-bold w-6 text-center">{getQty(item)}</span>
                                    <button onClick={() => setQtyMap({...qtyMap, [item.id]: Math.min(maxStock(item), getQty(item) + 1)})} className="w-6 h-6 rounded bg-white/10 hover:bg-white/20 text-sm font-bold leading-none">+</button>
                                    <span className="text-[8px] opacity-40">/ {maxStock(item)} in stock</span>
                                </div>
                            </div>
                        </div>
                        {item.liveStatus !== 'available' && (
                            <div className="mt-2 flex items-center justify-between gap-2 bg-black/70 border border-red-500/50 rounded p-2">
                                <span className="text-[9px] font-black uppercase text-red-400 tracking-wide">{STATUS_LABELS[item.liveStatus]}</span>
                                <button onClick={() => handleRemove(item.id)} className="bg-red-600 hover:bg-red-500 text-white text-[9px] font-black uppercase px-3 py-1 rounded">Remove</button>
                            </div>
                        )}
                        {item.liveStatus === 'available' && (
                            <button onClick={() => { if(window.confirm("Remove this item from your cart?")) handleRemove(item.id); }} className="absolute top-2 right-2 text-red-400"><Trash size={16}/></button>
                        )}
                    </div>
                ))}
            </div>
            <div className="mt-4 border-t border-white/10 pt-4">
                <div className="flex justify-between items-center mb-4">
                    <span className="font-bold">Total:</span><span className="text-xl font-black text-lime-400">${totalCost.toFixed(2)}</span>
                </div>
                <Button disabled={selectedIds.length === 0} onClick={startCheckout} color="lime" className="w-full">Checkout ({selectedIds.length})</Button>
            </div>
        </Modal> 
    );
};
EOF

# Block 11
cat << 'EOF' >> src/App.js
const ItemDetailModal = ({ item, user, isOpen, onClose, onViewFeed, zClass }) => {
    const [showMore, setShowMore] = useState(false);
    const [trackId, setTrackId] = useState('');
    const [isEditing, setIsEditing] = useState(false);
    const [editForm, setEditForm] = useState({});
    
    const [reviewText, setReviewText] = useState('');
    const [reviewRating, setReviewRating] = useState(5);
    const [reviews, setReviews] = useState([]);

    useEffect(() => {
        // V37.11: view counting moved to App.handleViewItem (unique per UID)
        if(item) {
            setEditForm({ name: item.name, price: item.price, description: item.description, stockQty: item.stockQty });
            setReviews(item.reviews || []);
        }
    }, [isOpen, item, user]);

    if (!isOpen || !item) return null;
    const isOwner = user?.uid && (item.ownerId === user.uid || item.ownerPublicUid === user.uid || !item.ownerId);
    const isBuyer = item.buyers?.includes(user?.uid);
    const hasReviewed = reviews.some(r => r.uid === user?.uid);

    const saveTracking = async () => {
        if(!trackId) return;
        await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { trackingNumber: trackId });
        if(item.refId) await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', item.refId), { trackingNumber: trackId });
        alert("Tracking Saved securely.");
    };

    const handleUpdate = async () => {
        const batch = writeBatch(db);
        const updates = { ...editForm, price: parseFloat(editForm.price), stockQty: parseInt(editForm.stockQty) };
        batch.update(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), updates);
        if(item.refId) batch.update(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', item.refId), updates);
        await batch.commit();
        setIsEditing(false);
        alert("Post updated!");
    };

    const handleDelete = async () => {
        if(item.purchaseCount > 0 || item.trackingNumber || (item.status === 'approved' && item.isDIYRequest)) {
            return alert("Cannot delete an item that has active purchases, tracking, or an accepted Creator commision.");
        }
        if(!window.confirm("Permanently delete this post?")) return;
        const batch = writeBatch(db);
        
        try { await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id)); } catch(e){}
        if(item.refId) { try { await deleteDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', item.refId)); } catch(e){} }
        else { try { await deleteDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', item.id)); } catch(e){} }
        
        onClose();
    };

    const submitReview = async () => {
        if(!reviewText.trim()) return;
        const newReview = { uid: user.uid, user: user.displayName || 'Buyer', rating: reviewRating, text: reviewText, timestamp: Date.now() };
        await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { reviews: arrayUnion(newReview) });
        // V42.29 Stage A: roll this rating into the SELLER's running average so it can be
        // shown on their cards/posts/profile. ratingSum/ratingCount -> avg = sum/count.
        try {
            const sellerId = item.ownerId;
            if (sellerId) {
                await setDoc(doc(db, 'artifacts', appId, 'users', sellerId), {
                    ratingSum: increment(reviewRating), ratingCount: increment(1)
                }, { merge: true });
            }
        } catch (e) { console.log('seller rating update', e); }
        setReviews([newReview, ...reviews]);
    };

    if (isEditing) {
        return (
            <Modal isOpen={isOpen} onClose={() => setIsEditing(false)} title="Edit Post">
                <Input label="Name" value={editForm.name} onChange={v => setEditForm({...editForm, name: v})} />
                <div className="grid grid-cols-2 gap-2">
                    <Input label="Price ($)" type="number" value={editForm.price} onChange={v => setEditForm({...editForm, price: v})} />
                    <Input label="Stock Qty" type="number" value={editForm.stockQty} onChange={v => setEditForm({...editForm, stockQty: v})} />
                </div>
                <Input type="textarea" label="Description" value={editForm.description} onChange={v => setEditForm({...editForm, description: v})} />
                <Button onClick={handleUpdate} color="lime" className="w-full">Save Changes</Button>
            </Modal>
        );
    }

    return (
        <Modal isOpen={isOpen} onClose={onClose} zClass={zClass || 'z-50'} title={item.name || "Item Details"}>
            <div className="space-y-4 max-h-[70vh] overflow-y-auto pr-2">
                <div className="h-72 w-full rounded-lg overflow-hidden border border-white/10 bg-black/60">
                    <MediaCarousel media={item.mediaUrls} fallback={item.imageUrl || item.image || 'https://placehold.co/400x300/1a0033/ff50b4?text=RaveKandi'} />
                </div>

                {item.description && (
                    <div className="bg-white/5 p-3 rounded border border-white/10">
                        <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-1">Description</h4>
                        <p className="text-xs text-gray-100 whitespace-pre-wrap break-words">{item.description}</p>
                    </div>
                )}

                <div className="bg-white/5 p-3 rounded border border-white/10">
                    <h4 className="text-[10px] uppercase font-bold text-cyan-400 mb-2">Item Analytics</h4>
                    <div className="grid grid-cols-3 gap-2 text-[10px] text-center">
                        <div className="bg-black/40 p-1.5 rounded"><div className="font-bold text-white">{item.viewCount || 0}</div><div className="opacity-50">Views</div></div>
                        <div className="bg-black/40 p-1.5 rounded"><div className="font-bold text-pink-400">{item.likes?.length || 0}</div><div className="opacity-50">Likes</div></div>
                        <div className="bg-black/40 p-1.5 rounded"><div className="font-bold text-cyan-400">{item.comments?.length || 0}</div><div className="opacity-50">Comments</div></div>
                        <div className="bg-black/40 p-1.5 rounded"><div className="font-bold text-lime-400">{item.purchaseCount || 0}</div><div className="opacity-50">Sold</div></div>
                        <div className="bg-black/40 p-1.5 rounded"><div className="font-bold text-yellow-400">{item.shareCount || 0}</div><div className="opacity-50">Shares</div></div>
                        <div className="bg-black/40 p-1.5 rounded"><div className="font-bold text-white">{Math.max(0, item.stockQty ?? 1)}</div><div className="opacity-50">In Stock</div></div>
                    </div>
                    <div className="flex justify-between mt-2 text-[9px] opacity-70 px-1">
                        <span>Price: <span className="text-lime-400 font-bold">${item.price?.toFixed(2) || '0.00'}</span></span>
                        <span>Posted: {item.timestamp ? new Date(item.timestamp).toLocaleDateString() : '—'}</span>
                    </div>
                </div>
                
                {(isOwner || isBuyer) && item.purchaseCount > 0 && (
                    <div className="bg-black/50 border border-lime-500/50 p-3 rounded">
                        <h4 className="text-xs font-bold text-lime-400 uppercase mb-2 flex items-center gap-2"><Truck size={14}/> Shipping Status</h4>
                        {item.trackingNumber ? (
                            <p className="text-[10px] font-mono tracking-widest text-white">Tracking: {item.trackingNumber}</p>
                        ) : (
                            isOwner ? (
                                <div className="flex gap-2">
                                    <Input placeholder="Enter Tracking #..." value={trackId} onChange={setTrackId} className="mb-0 flex-1"/>
                                    <Button onClick={saveTracking} color="lime" className="text-[10px]">Save</Button>
                                </div>
                            ) : ( <p className="text-[10px] text-white/50 italic">Awaiting shipment from seller...</p> )
                        )}
                    </div>
                )}

                {reviews.length > 0 && (
                    <div className="bg-white/5 p-3 rounded border border-white/10">
                        <h4 className="text-[10px] uppercase font-bold text-cyan-400 mb-2">Verified Reviews</h4>
                        <div className="space-y-2">
                            {reviews.map((r, i) => (
                                <div key={i} className="bg-black/40 p-2 rounded text-xs border border-white/5">
                                    <div className="flex justify-between items-center mb-1">
                                        <span className="font-bold text-pink-400">{r.user}</span>
                                        <span className="flex text-yellow-400">{Array(r.rating || 5).fill().map((_, idx) => <StarIcon key={idx} size={10} fill="currentColor"/>)}</span>
                                    </div>
                                    <p className="opacity-80 italic">"{r.text}"</p>
                                </div>
                            ))}
                        </div>
                    </div>
                )}

                {isBuyer && !hasReviewed && (
                    <div className="bg-lime-900/20 p-3 rounded border border-lime-500/30">
                        <h4 className="text-xs font-bold text-lime-400 uppercase mb-2">Leave a Review</h4>
                        <div className="flex gap-1 mb-2">
                            {[1,2,3,4,5].map(num => (
                                <StarIcon key={num} onClick={() => setReviewRating(num)} size={16} className={`cursor-pointer ${reviewRating >= num ? 'text-yellow-400' : 'text-white/20'}`} fill={reviewRating >= num ? 'currentColor' : 'none'} />
                            ))}
                        </div>
                        <div className="flex gap-2">
                            <Input value={reviewText} onChange={setReviewText} placeholder="How was the Kandi?" className="mb-0 flex-1"/>
                            <Button onClick={submitReview} color="lime" className="text-[10px]">Submit</Button>
                        </div>
                    </div>
                )}

                {item.isDIYRequest ? (
                    <div className="bg-white/10 p-3 rounded border border-lime-400/50">
                        <h4 className="text-xs font-bold text-lime-400 uppercase mb-2">Project Status: {item.status}</h4>
                        <p className="text-[10px] opacity-70 mb-2">Cost: ${item.price?.toFixed(2)}</p>
                        <p className="text-[10px] opacity-70">Created: {new Date(item.timestamp).toLocaleDateString()}</p>
                        {item.dismissReason && ( <div className="mt-2 pt-2 border-t border-white/10"><span className="text-red-400 text-[10px] font-bold">Dismissed:</span><p className="text-[10px] italic">{item.dismissReason}</p></div> )}
                    </div>
                ) : (
                    <div className="grid grid-cols-2 gap-2">
                        <Button onClick={() => { onClose(); onViewFeed(item.ownerPublicUid || item.ownerId); }} color="cyan" className="text-xs">View in Feed</Button>
                        <Button onClick={onClose} color="accent" className="text-xs">Close</Button>
                    </div>
                )}

                {isOwner && (
                    <div className="border-t border-white/10 pt-4">
                        <div className="flex justify-between items-center mb-2">
                            <button onClick={() => setShowMore(!showMore)} className="flex items-center gap-2 text-xs text-lime-400 font-bold">{showMore ? "Hide" : "Show"} Stats <MoreHorizontal size={12}/></button>
                            <div className="flex gap-2">
                                <button onClick={() => setIsEditing(true)} className="text-cyan-400 bg-cyan-900/30 p-1 rounded"><Edit size={14}/></button>
                                <button onClick={handleDelete} className="text-red-400 bg-red-900/30 p-1 rounded"><Trash2 size={14}/></button>
                            </div>
                        </div>
                        {showMore && (
                            <div className="bg-white/5 p-3 rounded text-[10px] space-y-2 animate-fade-in-pulse">
                                <p><span className="opacity-50">Prompt:</span> {item.prompt || "Manual Upload"}</p>
                                <div className="grid grid-cols-5 gap-2 mt-2"><div className="bg-black/40 p-1 rounded text-center"><div className="font-bold text-pink-400">{item.likes?.length || 0}</div><div className="opacity-50">Likes</div></div><div className="bg-black/40 p-1 rounded text-center"><div className="font-bold text-cyan-400">{item.comments?.length || 0}</div><div className="opacity-50">Comms</div></div><div className="bg-black/40 p-1 rounded text-center"><div className="font-bold text-lime-400">{item.purchaseCount || 0}</div><div className="opacity-50">Sold</div></div><div className="bg-black/40 p-1 rounded text-center"><div className="font-bold text-yellow-400">{item.shareCount || 0}</div><div className="opacity-50">Shares</div></div><div className="bg-black/40 p-1 rounded text-center"><div className="font-bold text-white">{item.viewCount || 0}</div><div className="opacity-50">Views</div></div></div>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </Modal>
    );
};

const CollectionPopout = ({ user, type, isOpen, onClose, onViewFeed, readOnly = false, hideDIY = false }) => {
    const [items, setItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);

    const targetUid = user?.uid;
    useEffect(() => {
        if(!isOpen || !targetUid) return;
        const filterBroken = (arr) => arr.filter(i => {
            if (i.status === 'failed' || i.status === 'generating') return i.status === 'generating';
            if (i.isAICreation) { const img = i.imageUrl || i.mediaUrls?.[0]?.url || ''; return typeof img === 'string' && (img.startsWith('data:') || img.startsWith('http')); }
            return true;
        });
        // V57.1: when viewing ANOTHER raver's collection, read their PUBLIC posts from
        // tradeItems (by ownerId) — this is always readable and is where listed items live,
        // so collections reliably show items now. (The old inventory-subcollection read was
        // returning empty.) The owner's own view still reads their full inventory.
        if (readOnly) {
            const q = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('ownerId', '==', targetUid));
            return onSnapshot(q, s => {
                let arr = s.docs.map(d => ({ ...d.data(), id: d.id }));
                arr = arr.filter(i => !i.isCraftingStock);
                // V63: respect the owner's "hide my DIY/AI projects from others" preference.
                if (hideDIY) arr = arr.filter(i => !i.isDIYRequest && !i.isAICreation && !i.isDesignConcept && !i.isRequest && i.status !== 'request');
                arr.sort((a, b) => (b.timestamp || 0) - (a.timestamp || 0));
                setItems(filterBroken(arr));
            }, e => { console.log('collection(readOnly) load:', e); setItems([]); });
        }
        const q = query(collection(db, 'artifacts', appId, 'users', targetUid, 'inventory'));
        return onSnapshot(q, s => {
            let allItems = s.docs.map(d => ({...d.data(), id: d.id}));
            allItems.sort((a, b) => (b.timestamp || 0) - (a.timestamp || 0));
            const usable = filterBroken(allItems);
            if (type === 'posts') setItems(usable.filter(i => !i.isCraftingStock));
            if (type === 'stock') setItems(usable.filter(i => i.isCraftingStock));
        }, e => { console.log('collection load:', e); setItems([]); });
    }, [isOpen, targetUid, type, readOnly, hideDIY]);
    
    if(!isOpen) return null;
    return (
        <>
            <Modal isOpen={isOpen} onClose={onClose} zClass={readOnly ? 'z-[100]' : 'z-50'} title={readOnly ? "Collection" : (type === 'posts' ? "My Collection" : "My Stock")}>
                <div className="grid grid-cols-2 gap-3 max-h-[60vh] overflow-y-auto p-1">
                    {items.length === 0 && <p className="col-span-2 text-center opacity-50 py-10">{readOnly ? "This raver hasn't added any items to their collection yet." : "Empty here."}</p>}
                    {items.map(item => (
                        <div key={item.id} onClick={() => setSelectedItem(item)} className={`bg-white/5 p-2 rounded-lg border flex flex-col relative group cursor-pointer hover:bg-white/10 ${item.status === 'generating' ? 'border-yellow-500/50' : 'border-white/10'}`}>
                            {item.status === 'generating' ? (
                                <div className="w-full h-24 bg-black/50 flex flex-col items-center justify-center rounded mb-2"><Activity className="animate-pulse text-yellow-400 mb-1"/><span className="text-[8px] text-yellow-400">Processing...</span></div>
                            ) : ( <img src={item.mediaUrls?.[0]?.url || item.imageUrl || item.image || 'https://placehold.co/100?text=Kandi'} onError={(e)=>{ if(e.target.src.indexOf('placehold')<0) e.target.src='https://placehold.co/100?text=Kandi'; }} className="w-full h-24 object-cover rounded mb-2"/> )}
                            <p className="font-bold text-[10px] truncate">{item.name || item.subType || 'Unknown Item'}</p>
                            {!readOnly && (item.isDIYRequest || item.isAICreation || item.isDesignConcept) && (
                                <div className={`mt-1 text-[7px] font-bold uppercase tracking-wide px-1.5 py-0.5 rounded-full inline-flex items-center gap-1 self-start ${hideDIY ? 'bg-white/10 text-white/50' : 'bg-lime-500/20 text-lime-300'}`}>{hideDIY ? <><EyeOff size={8}/> Hidden from others</> : <><Eye size={8}/> Visible to others</>}</div>
                            )}
                            <div className="flex justify-between items-center mt-2 border-t border-white/10 pt-2"><span className="text-[10px] text-lime-400 font-bold">${item.sell || item.price || '0.00'}</span><span className="text-[8px] opacity-50">{item.status || 'Ready'}</span></div>
                        </div>
                    ))}
                </div>
            </Modal>
            <ItemDetailModal item={selectedItem} user={user} isOpen={!!selectedItem} onClose={() => setSelectedItem(null)} onViewFeed={onViewFeed} zClass={readOnly ? 'z-[110]' : 'z-50'}/>
        </>
    );
};
EOF

# Block 12
cat << 'EOF' >> src/App.js
const AICustomLab = ({ user, onSubmitRequest, profile }) => {
    const [prompt, setPrompt] = useState('');
    const [allowBuy, setAllowBuy] = useState(false); const [itemName, setItemName] = useState('');
    const [res, setRes] = useState(null); const [loading, setLoading] = useState(false);
    const [imageReady, setImageReady] = useState(false);
    const [remaining, setRemaining] = useState(DAILY_AI_LIMIT);
    
    useEffect(() => {
        const checkLimits = async () => {
            if(!user?.uid) return;
            const snap = await getDoc(doc(db, 'artifacts', appId, 'users', user.uid));
            if(snap.exists()) {
                const data = snap.data(); const lastReset = data.lastAiReset || 0; const now = new Date();
                const utc = now.getTime() + (now.getTimezoneOffset() * 60000); const cstDate = new Date(utc + (3600000 * -6)); 
                const resetTarget = new Date(cstDate); resetTarget.setHours(12, 0, 0, 0);
                if (cstDate.getHours() < 12) resetTarget.setDate(resetTarget.getDate() - 1);
                if (lastReset < resetTarget.getTime()) { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { aiUsageCount: 0, lastAiReset: Date.now() }, { merge: true }); setRemaining(DAILY_AI_LIMIT); } 
                else { setRemaining(DAILY_AI_LIMIT - (data.aiUsageCount || 0)); }
            }
        };
        checkLimits();
    }, [user]);

    const [genPct, setGenPct] = useState(0);
    const gen = async () => { 
        if(!prompt || !user?.uid) return;
        if(remaining <= 0) return alert("Daily limit reached. Resets at 12PM CST.");
        if (!RK_CFG.aiLabEnabled) return alert("The AI Design Lab is temporarily disabled by the admin team — check back soon!");
        setLoading(true); setGenPct(3); setImageReady(false); setRes(null); await ensureUserExists(user.uid);
        
        // V49: generate FIRST, and only write a collection doc once we have a real image.
        // This guarantees a failed generation never leaves a broken/placeholder item behind.
        try { 
            const r = await generateCustomKandi(prompt, setGenPct); setGenPct(98); setRes(r);
            const userRef = doc(db, 'artifacts', appId, 'users', user.uid);
            const snap = await getDoc(userRef);
            if (snap.exists()) { await updateDoc(userRef, { aiUsageCount: increment(1) }); } 
            else { await setDoc(userRef, { aiUsageCount: 1 }, { merge: true }); }
            setRemaining(prev => prev - 1);
            // V50: text-only analysis — the result is shown for the user to review and
            // optionally submit; we don't auto-write an image-less item to the collection.
        } catch(e){ 
            if (e.message === 'ANALYSIS_FAILED') alert("😔 The AI design service was busy and couldn't analyze your idea this time. Please try again in a moment — no credit was used."); 
            else alert(e.message); 
        } finally { setLoading(false); } 
    };

    const submit = async () => {
        if(!user?.uid) return;
        if(user.isAnonymous && allowBuy) return alert("Please create an account to sell items.");
        if (allowBuy && !itemName) return alert("You must name your item to allow others to buy it.");
        // V50: text-only design analysis (no image this version). Save the full breakdown.
        if (!res) { alert("Generate a design analysis first."); return; }
        setLoading(true);
        try {
            const inventoryData = { status: 'completed', imageUrl: '', visual_description: res.visual_description, item_category: res.item_category || 'Custom', primary_fabric: res.primary_fabric || 'N/A', estimated_materials: res.materials || [], material_cost: res.material_cost, creation_fee: res.creation_fee, estimated_time_hours: res.estimated_time_hours, estimated_cost: res.estimated_cost, difficulty: res.difficulty, skill_notes: res.skill_notes || '', name: itemName || ("AI " + (res.item_category || 'Design')), timestamp: Date.now(), allowBuy: allowBuy, isDIYRequest: false, isAICreation: true, isDesignConcept: true, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', type: res.item_category || "Other", viewCount: 0 };
            await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), inventoryData);
            if (allowBuy) { await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), { ...inventoryData, ownerId: user.uid, ownerName: profile?.displayName || 'Raver', ownerBadge: profile?.featuredBadge || null, isAppProduct: false, purchaseCount: 0, shareCount: 0, status: 'approved', requestStatus: 'awaiting_assignment', likes: [], comments: [] }); alert("Submitted! Your design is live and queued for a Creator to fabricate orders."); } 
            else { alert("Saved to your collection!"); }
            setPrompt(''); setRes(null); setAllowBuy(false); setItemName('');
        } catch (e) { alert("Error saving: " + e.message); } finally { setLoading(false); }
    };

    // V42.28: download the generated image straight to the user's device.
    const downloadImage = () => {
        const src = res?.permanentImage || res?.displayUrl || res?.imageUrl;
        if (!src) return;
        try {
            const a = document.createElement('a');
            a.href = src;
            a.download = 'RaveKandi_' + (itemName || 'AI_Design').replace(/[^a-zA-Z0-9]/g, '_') + '.jpg';
            document.body.appendChild(a); a.click(); document.body.removeChild(a);
        } catch (e) { try { window.open(src, '_blank'); } catch (e2) {} }
    };
    const shareImage = async () => {
        const src = res?.permanentImage || res?.displayUrl || res?.imageUrl;
        const shareUrl = (typeof buildShareUrl === 'function') ? buildShareUrl({ ref: profile?.publicUid || '' }) : 'https://ravekandi.web.app';
        const text = 'Check out the custom kandi I designed on RaveKandi! 🌈 Make your own:';
        try {
            if (src && src.startsWith('data:') && navigator.canShare) {
                const blob = await (await fetch(src)).blob();
                const file = new File([blob], 'ravekandi-design.jpg', { type: 'image/jpeg' });
                if (navigator.canShare({ files: [file] })) { await navigator.share({ files: [file], text: text + ' ' + shareUrl }); return; }
            }
            await navigator.share({ title: 'RaveKandi', text: text, url: shareUrl });
        } catch (e) { try { navigator.clipboard.writeText(text + ' ' + shareUrl); alert('Share link copied! Paste it anywhere to show off your design. 🌈'); } catch (e2) {} }
    };

    return ( 
        <Card className="p-6 text-center">
            <Bot size={48} className="mx-auto mb-4 text-pink-500"/>
            <h2 className="text-2xl font-bold mb-1 uppercase">AI Design Lab</h2>
            <p className="text-[10px] opacity-60 mb-3">Kandi · Clothing · Jewelry · Accessories · Equipment · Stickers & more</p>
            <div className="flex justify-center gap-2 mb-4"><span className={`text-[10px] font-bold px-2 py-1 rounded ${remaining > 0 ? 'bg-lime-500/20 text-lime-400' : 'bg-red-500/20 text-red-400'}`}>Daily Limit: {remaining}/{DAILY_AI_LIMIT}</span></div>
            <div className="bg-cyan-900/20 border border-cyan-500/40 rounded p-2 mb-4 text-left"><p className="text-[9px] text-cyan-200 leading-relaxed"><strong>🎨 Note:</strong> the Design Lab currently generates a full <strong>cost, material & time breakdown</strong> for any rave creation — it does <strong>not generate images yet</strong> (that's coming in a later version!). Describe anything you want to make and get an instant build plan with pricing.</p></div>
            {!res && ( <div className="mb-4 flex items-center justify-center gap-2 bg-white/5 p-2 rounded"><input type="checkbox" checked={allowBuy} onChange={e => setAllowBuy(e.target.checked)} className="accent-pink-500"/><label className="text-xs">Allow others to buy / request this design?</label></div> )}
            <Input type="textarea" value={prompt} onChange={setPrompt} placeholder="Describe ANY rave creation — e.g. 'holographic pleated festival skirt with LED trim' or 'neon cuff with alien charms'..." disabled={!!res}/>
            {!res && ( loading ? ( <div className="mt-4 space-y-2 text-center"><LoadingBar progress={genPct} className="h-2"/><p className="text-lime-400 font-mono text-lg font-bold">{genPct}%</p><p className="text-[10px] text-pink-300 animate-pulse">{genPct < 40 ? 'Analyzing your design...' : genPct < 92 ? 'Calculating materials, fabrics & costs...' : 'Finalizing your build plan...'}</p></div> ) : ( <Button onClick={gen} disabled={remaining <= 0} color={remaining > 0 ? "lime" : "accent"} className="w-full">{remaining > 0 ? "Analyze Design" : "Limit Reached"}</Button> ) )}
            {res && (
                <div className="mt-6 border-2 border-pink-400 rounded-lg p-4 bg-black/40 text-left shadow-[0_0_20px_rgba(255,100,200,0.5)] animate-fade-in-pulse">
                    <div className="flex items-center justify-between mb-2">
                        <span className="text-[9px] font-black uppercase bg-pink-500/30 text-pink-200 px-2 py-1 rounded">{res.item_category || 'Custom'}</span>
                        <span className="text-[9px] opacity-60">Difficulty {res.difficulty}/10 · ~{res.estimated_time_hours}h</span>
                    </div>
                    <p className="text-sm mb-4 leading-relaxed">{res.visual_description}</p>

                    {allowBuy && ( <div className="mb-4"><label className="block text-[10px] font-bold text-pink-400 mb-1">Item Name (Required to Sell)</label><Input value={itemName} onChange={setItemName} placeholder="Name your creation..."/></div> )}

                    {res.primary_fabric && res.primary_fabric !== 'N/A' && (
                        <div className="bg-white/5 p-2 rounded mb-3 flex justify-between text-[11px]"><span className="opacity-60">Primary Fabric</span><span className="font-bold text-cyan-300">{res.primary_fabric}</span></div>
                    )}

                    <div className="bg-white/5 p-3 rounded mb-3">
                        <h4 className="font-bold text-xs text-lime-400 border-b border-white/10 pb-1 mb-2">Materials & Fabrics</h4>
                        <div className="space-y-1">{(res.materials || []).map((m, i) => ( <div key={i} className="flex justify-between text-[10px] gap-2"><span className="flex-1">{m.name} <span className="opacity-50">({m.qty})</span></span>{m.unit_cost_usd ? <span className="opacity-70 text-cyan-300">~${parseFloat(m.unit_cost_usd).toFixed(2)}</span> : null}</div> ))}</div>
                    </div>

                    <div className="bg-gradient-to-br from-lime-900/20 to-cyan-900/20 border border-lime-500/30 p-3 rounded mb-3">
                        <h4 className="font-bold text-xs text-lime-400 mb-2">💰 Cost & Pricing Breakdown</h4>
                        <div className="space-y-1 text-[11px]">
                            <div className="flex justify-between"><span className="opacity-70">Material Cost</span><span>${res.material_cost}</span></div>
                            <div className="flex justify-between"><span className="opacity-70">Creation Fee (~{res.estimated_time_hours}h × skill)</span><span>${res.creation_fee}</span></div>
                            {parseFloat(res.complexity_surcharge) > 0 && <div className="flex justify-between"><span className="opacity-70">Complexity Surcharge</span><span>${res.complexity_surcharge}</span></div>}
                            <div className="flex justify-between font-black text-sm pt-2 mt-1 border-t border-white/15"><span className="text-lime-300">Suggested Sale Price</span><span className="text-lime-300">${res.estimated_cost}</span></div>
                        </div>
                        <p className="text-[8px] opacity-50 mt-2">Includes materials, a creation fee scaled by difficulty & time, and a healthy profit margin. Adjust to your market.</p>
                    </div>

                    {res.skill_notes && <p className="text-[10px] italic opacity-70 mb-3">🛠️ {res.skill_notes}</p>}

                    <div className="flex gap-2"><Button onClick={() => setRes(null)} color="accent" className="flex-1 text-xs">Discard</Button><Button onClick={submit} disabled={loading} color="lime" className="flex-1 text-xs">{loading ? "Saving..." : "Save Design Plan"}</Button></div>
                </div>
            )}
        </Card> 
    );
};
EOF

# Block 13
cat << 'EOF' >> src/App.js
const CreatorSelectCarousel = ({ onSelectCreator, selectedId }) => {
    const [creators, setCreators] = useState([]);
    const [stScroll, setStScroll] = useState({ thumb: 50, top: 0 });
    const gridRef = useRef(null);

    useEffect(() => {
        const q = query(collection(db, 'artifacts', appId, 'users'), where('isKandiCreator', '==', true));
        getDocs(q).then(snap => setCreators(snap.docs.map(d => ({...d.data(), id: d.id}))));
    }, []);

    if (creators.length === 0) return <div className="text-center p-4 text-[10px] opacity-50 border border-white/10 rounded mb-2">No active Kandi Creators found.</div>;

    // 2 rows of 4 visible; vertical scroll for the rest, with a visible scroll-wheel track.
    return (
        <div className="mb-2">
            <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-2 flex items-center justify-between"><span>Choose a Verified Creator</span>{creators.length > 8 && <span className="text-[8px] opacity-50 normal-case font-normal flex items-center gap-1">scroll <ChevronDown size={10} className="animate-bounce"/></span>}</h4>
            <div className="relative border-2 border-pink-500/40 rounded-xl bg-black/40 p-2" style={{ boxShadow: '0 0 10px rgba(236,72,153,0.3) inset' }}>
                <div ref={gridRef} onScroll={(e) => { const el = e.target; const max = el.scrollHeight - el.clientHeight; const thumb = Math.max(20, (el.clientHeight / el.scrollHeight) * 100); const top = max > 0 ? (el.scrollTop / max) * (100 - thumb) : 0; setStScroll({ thumb, top }); }} className="grid grid-cols-4 gap-2 overflow-y-auto rk-scroll pr-3 overscroll-contain" style={{ maxHeight: '188px', WebkitOverflowScrolling: 'touch' }}>
                    {creators.map(c => (
                        <div key={c.id} onClick={() => onSelectCreator(c)} className={`p-2 rounded-xl border flex flex-col items-center cursor-pointer transition-colors ${selectedId === c.id ? 'bg-pink-500/20 border-pink-500 shadow-[0_0_10px_rgba(236,72,153,0.5)]' : 'bg-black/50 border-white/10 hover:bg-white/5'}`}>
                            <img src={c.photoURL || 'https://placehold.co/50'} className="w-10 h-10 rounded-full mb-1 object-cover border border-white/20"/>
                            <p className="text-[8px] font-bold truncate w-full text-center">{c.displayName}</p>
                            <p className="text-[7px] opacity-50 flex items-center gap-1"><Award size={8}/> {c.completedTrades || 0}</p>
                        </div>
                    ))}
                </div>
                {creators.length > 8 && (
                    <div className="absolute right-1 top-2 bottom-2 w-1.5 rounded-full bg-white/10 pointer-events-none">
                        <div className="w-full rounded-full bg-pink-500/70 transition-all duration-75" style={{ height: stScroll.thumb + '%', marginTop: stScroll.top + '%' }}/>
                    </div>
                )}
            </div>
        </div>
    );
};

const DIYBuilder = ({ onSubmitRequest }) => {
    const [build, setBuild] = useState([]);
    const [desc, setDesc] = useState(''); const [success, setSuccess] = useState(false);
    const [activeCreator, setActiveCreator] = useState(null);
    const [creatorStock, setCreatorStock] = useState([]);
    const [openMode, setOpenMode] = useState(false);
    const [budget, setBudget] = useState('');
    const [lastSubmit, setLastSubmit] = useState(null);

    useEffect(() => {
        if(openMode) {
            // Open requests pull parts from the shared public DIY inventory
            getDocs(query(collection(db, 'artifacts', appId, 'public', 'data', 'inventory')))
                .then(snap => setCreatorStock(snap.docs.map(d => ({...d.data(), id: d.id})).filter(i => i.isCraftingStock)))
                .catch(() => setCreatorStock([]));
            return;
        }
        if(!activeCreator) { setCreatorStock([]); return; }
        const q = query(collection(db, 'artifacts', appId, 'users', activeCreator.id, 'inventory'));
        getDocs(q).then(snap => {
            const stock = snap.docs.map(d => ({...d.data(), id: d.id})).filter(i => i.isCraftingStock);
            setCreatorStock(stock);
        });
    }, [activeCreator, openMode]);
    
    const total = useMemo(() => {
        const raw = build.reduce((s, i) => s + (parseFloat(i.sell) || parseFloat(i.cost) || 0), 0);
        return raw > 0 ? raw : 0;
    }, [build]);
    
    const add = (i) => setBuild(prev => [...prev, i]); 
    const remove = (index) => setBuild(prev => prev.filter((_, i) => i !== index));
    const effTotal = build.length > 0 ? total : (parseFloat(budget) || 0);
    const submitDesign = () => {
        const windowH = getIdleWindowHours(effTotal, build.length);
        const targeted = !openMode && !!activeCreator?.id;
        setLastSubmit({ creator: activeCreator?.displayName || activeCreator?.name || null, hours: windowH, open: !targeted });
        onSubmitRequest({ name: openMode && build.length === 0 ? "Custom Design Request" : "DIY Custom Request", price: effTotal, components: build, description: desc, isDIYRequest: true, isRequest: true, openRequest: !targeted, type: "Other", viewCount: 0, assignedCreatorId: targeted ? activeCreator.id : null, assignedCreatorName: targeted ? (activeCreator?.name || activeCreator?.displayName || null) : null, requestStatus: targeted ? 'pending' : 'awaiting_assignment', idleWindowHours: windowH, idleExpiresAt: targeted ? Date.now() + windowH * 3600000 : null, status: 'request' });
        setSuccess(true); setBuild([]); setDesc(''); setActiveCreator(null); setBudget('');
    };

    return ( 
        <div className="flex flex-col gap-4">
            <Card className="p-5 text-center border-cyan-500/30">
                <Hammer size={44} className="mx-auto mb-2 text-cyan-400"/>
                <h2 className="text-2xl font-bold uppercase">DIY Build Lab</h2>
                <p className="text-[10px] opacity-60 mb-3">Custom kandi · Bracelets · Cuffs · Sets — built by real Creators</p>
                <div className="border-t border-cyan-500/20 pt-3 text-left">
                    <h3 className="font-black uppercase text-sm text-cyan-400 mb-1.5 italic tracking-widest">How DIY Builds Work</h3>
                    <div className="text-[13px] text-gray-100 space-y-0.5 leading-snug">
                        <p><span className="text-pink-400 font-bold">1.</span> Pick a Creator above to load their real crafting inventory (beads, strings, charms).</p>
                        <p><span className="text-pink-400 font-bold">2.</span> Tap parts to add them to Your Build — the price totals automatically as you design.</p>
                        <p><span className="text-pink-400 font-bold">3.</span> Describe your vision (colors, pattern, sizing) and hit Submit Build.</p>
                        <p><span className="text-pink-400 font-bold">4.</span> Track your request in your Collection — Pending → Active → Completed as the Creator works.</p>
                        <p><span className="text-pink-400 font-bold">5.</span> ⚖ Fairness window: a requested Creator gets <strong>24–72h</strong> (scaled by price & complexity) to accept before your request automatically opens to ALL Creators.</p>
                    </div>
                </div>
            </Card>
            <div className="flex flex-col gap-1.5">
                <div className="text-center"><p className="text-xs text-gray-100">Step 1: Choose an <strong className="text-cyan-400">individual Creator</strong> below…</p></div>
                <CreatorSelectCarousel selectedId={openMode ? null : activeCreator?.id} onSelectCreator={(c) => { setActiveCreator(c); setOpenMode(false); }} />
                <div className="flex items-center gap-3"><div className="flex-1 h-px bg-white/15"/><span className="text-2xl font-black text-yellow-300 uppercase tracking-widest" style={{ filter: 'drop-shadow(0 0 8px rgba(250,204,21,0.6))' }}>— OR —</span><div className="flex-1 h-px bg-white/15"/></div>
                <p className="text-center text-xs text-gray-100">…<strong className="text-lime-300">open your request to ALL Creators</strong> at once:</p>
                <button onClick={() => { const next = !openMode; setOpenMode(next); if (next) setActiveCreator(null); }} className={`w-full p-3 rounded-xl border-2 border-dashed font-black uppercase text-xs tracking-widest transition-all ${openMode ? 'border-lime-400 bg-lime-900/30 text-lime-300 shadow-[0_0_15px_rgba(163,230,53,0.4)]' : 'border-white/20 bg-white/5 text-white/60 hover:bg-white/10'}`}>
                    📢 All Inventory / Open Request to ALL Creators {openMode && '✓ ACTIVE'}
                </button>
                {openMode && <p className="text-[9px] text-lime-300/80 px-1">Open mode: your request goes straight to the Awaiting Creator queue where every Creator can see and accept it. Add parts from the shared inventory (if available) or just describe your vision and set a budget.</p>}
            </div>
            
            <div className="flex flex-col md:flex-row gap-4">
                {success && (
                    <Modal isOpen={success} onClose={() => setSuccess(false)} title="Submission Received">
                        <div className="text-center py-4 space-y-4">
                            <CheckCircle size={48} className="text-lime-400 mx-auto"/>
                            <div className="text-left bg-white/5 p-4 rounded text-xs space-y-2 opacity-80">
                                {lastSubmit?.open ? (
                                    <p>1. Your open request is now live in the <strong>Awaiting Creator</strong> queue — visible to ALL Creators. The first to accept takes the commission.</p>
                                ) : (<>
                                    <p>1. Your build has been sent directly to <strong>{lastSubmit?.creator || 'the Creator'}</strong>.</p>
                                    <p>2. They have a <strong>{lastSubmit?.hours || 24}-hour priority window</strong> (scaled by price & complexity) to accept. If they don't respond in time, your request automatically opens to ALL Creators — keeping things fair for you and for busy Creators.</p>
                                </>)}
                            </div>
                            <Button onClick={() => setSuccess(false)} color="primary" className="w-full">Got it</Button>
                        </div>
                    </Modal>
                )}
                
                <Card className="flex-none h-72 md:h-[500px] md:w-1/2 overflow-hidden flex flex-col">
                    <h3 className="font-bold mb-2 shrink-0 italic tracking-widest uppercase">DIY STUDIO</h3>
                    {(!activeCreator && !openMode) ? (
                        <div className="flex-1 flex items-center justify-center text-[10px] opacity-50 border border-dashed border-white/10 rounded text-center px-4">Select a Creator above — or tap Open Request — to load an inventory.</div>
                    ) : (
                        <div className="flex-1 overflow-y-auto grid grid-cols-3 gap-1 content-start p-1">
                            {creatorStock.length === 0 && <p className="col-span-3 text-center text-[10px] opacity-50 pt-10">{openMode ? 'No shared DIY stock yet — describe your vision below and set a budget.' : 'This creator has no active crafting stock.'}</p>}
                            {creatorStock.map(i => (
                                <div key={i.id} onClick={() => add(i)} className="bg-white/5 p-2 rounded cursor-pointer border border-transparent relative h-24 flex flex-col items-center justify-center transition hover:bg-white/10">
                                    <PlusCircle size={16} className="absolute top-1 right-1 text-lime-400"/>
                                    <img src={i.imageUrl || i.image || 'https://placehold.co/50'} className="h-10 w-10 rounded mb-1 object-cover"/>
                                    <p className="text-[8px] font-bold text-center leading-tight uppercase truncate w-full">{i.name || i.subType}</p>
                                    <p className="text-[8px] text-lime-400">${(parseFloat(i.sell) || parseFloat(i.cost) || 0).toFixed(2)}</p>
                                </div>
                            ))}
                        </div>
                    )}
                </Card>
                <div className="flex-1 flex flex-col gap-2">
                    <Card className="shrink-0 flex flex-col" glow="purpleGlow">
                        <h3 className="font-bold mb-2 shrink-0" style={getTextGlowStyle('purpleGlow')}>Your Build ({build.length})</h3>
                        <div className="h-40 overflow-y-auto bg-black/20 p-2 rounded">
                            {build.length === 0 && <p className="text-[10px] opacity-40 text-center pt-12">Tap parts on the left to add them here.</p>}
                            {build.map((b, i) => (
                                <div key={i} className="text-xs flex justify-between items-center p-2 border-b border-white/5 bg-white/5 mb-1 rounded">
                                    <span className="truncate flex-1">{b.name || b.subType}</span>
                                    <span className="text-lime-400 mr-3">${(parseFloat(b.sell) || parseFloat(b.cost) || 0).toFixed(2)}</span>
                                    <button onClick={() => remove(i)} className="text-red-500"><MinusCircle size={14}/></button>
                                </div>
                            ))}
                        </div>
                    </Card>
                    <Card className="shrink-0" glow="purpleGlow"><label className="text-[10px] font-bold mb-1 block">Describe Vision</label><textarea value={desc} onChange={e=>setDesc(e.target.value)} placeholder="Describe color order, exact pattern..." className="w-full p-2 rounded bg-white/10 border-2 border-white/30 text-[10px] h-16"/></Card>
                    {openMode && build.length === 0 && (
                        <Card className="shrink-0" glow="limeGlow"><label className="text-[10px] font-bold mb-1 block text-lime-400">Budget Offer ($) — required when sending without parts</label><input type="number" min="1" value={budget} onChange={e=>setBudget(e.target.value)} placeholder="e.g. 25" className="w-full p-2 rounded bg-white/10 border-2 border-white/30 text-xs"/></Card>
                    )}
                    <Card className="shrink-0 flex justify-between items-center bg-[#1a0033]" glow="limeGlow"><div className="text-xl font-bold text-white">Total: <span className="text-lime-400">${effTotal.toFixed(2)}</span></div><Button onClick={submitDesign} disabled={openMode ? (!desc || effTotal <= 0) : (build.length===0 || !activeCreator)} color="lime" className="shadow-neon-green">{openMode ? 'Send Open Request' : 'Submit Build'}</Button></Card>
                    <p className="text-[8px] opacity-50 text-center shrink-0">⚖ Requested Creators get a {getIdleWindowHours(effTotal, build.length)}h priority window — unaccepted requests then open to all Creators.</p>
                </div>
            </div>
        </div> 
    );
};
EOF

# Block 14
cat << 'EOF' >> src/App.js
const ItemCard = ({ item, user, profile, onViewProfile, onAddToCart, onViewItem }) => {
    const [liked, setLiked] = useState(item.likes?.includes(user?.uid));
    const [showComments, setShowComments] = useState(false);
    const [descExpanded, setDescExpanded] = useState(false);
    
    const isOwner = user?.uid === item.ownerId;
    const isBuyer = item.buyers?.includes(user?.uid);
    const inStock = (item.stockQty ?? (item.purchaseCount > 0 ? 0 : 1)) > 0;
    const canSeePrice = inStock || isOwner || isBuyer;

    const toggleLike = async () => { if(!user?.uid) return; const ref = doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id); if(liked) { await updateDoc(ref, { likes: arrayRemove(user.uid) }); } else { await updateDoc(ref, { likes: arrayUnion(user.uid) }); if (item.ownerId && item.ownerId !== user.uid) pushNotif(item.ownerId, 'like', (profile?.displayName || 'Someone') + ' liked "' + item.name + '"', item.id); } setLiked(!liked); };
    
    const handleShare = async () => {
        const itemUrl = buildShareUrl({ item: item.id, ref: (profile?.publicUid || '') }); try { await navigator.share({ title: 'RaveKandi', text: `Check out ${item.name} on RaveKandi!`, url: itemUrl }); await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { shareCount: increment(1) }).catch(()=>{}); } catch (err) { try { navigator.clipboard.writeText(`Check out ${item.name} on RaveKandi! ` + itemUrl); alert("Link copied!"); } catch(e2){} }
    };
    
    const avgRating = item.reviews?.length > 0 ? (item.reviews.reduce((a,b)=>a+b.rating,0) / item.reviews.length).toFixed(1) : null;

    return ( 
        <Card className="flex flex-col h-full relative">
            <CommentModal item={item} user={user} profile={profile} isOpen={showComments} onClose={() => setShowComments(false)} onViewProfile={onViewProfile}/>
            {profile?.isAdmin && (
                <div className="absolute top-2 left-1/2 -translate-x-1/2 z-40 flex gap-1 bg-red-950/90 border border-red-500/50 rounded-lg px-1.5 py-1 shadow-lg">
                    <span className="text-[7px] font-black text-red-300 uppercase self-center px-1">Admin</span>
                    <button onClick={(e) => { e.stopPropagation(); onViewItem(item); }} className="text-cyan-300 p-1 hover:bg-white/10 rounded" title="Open / edit"><Edit size={12}/></button>
                    <button onClick={(e) => { e.stopPropagation(); adminDeleteItem(item); }} className="text-red-300 p-1 hover:bg-white/10 rounded" title="Delete item"><Trash2 size={12}/></button>
                    <button onClick={(e) => { e.stopPropagation(); adminBanUser(item.ownerId, item.ownerName, 604800000, '7 days'); }} className="text-orange-300 p-1 hover:bg-white/10 rounded" title="Ban seller 7d"><Ban size={12}/></button>
                    <button onClick={(e) => { e.stopPropagation(); adminBanUser(item.ownerId, item.ownerName, 'permanent', 'permanently'); }} className="text-red-400 p-1 hover:bg-white/10 rounded" title="Ban seller permanently"><ShieldOff size={12}/></button>
                </div>
            )}
            {item.purchaseCount > 0 && ( <div className="absolute top-2 right-2 bg-black/60 backdrop-blur px-2 py-1 rounded text-[8px] flex items-center gap-1 z-10 border border-lime-400/30"><ShoppingBag size={10} className="text-lime-400"/> {item.purchaseCount} Sold</div> )}
            {item.isSeries && ( <div className="absolute top-2 left-2 bg-purple-900/80 backdrop-blur px-2 py-1 rounded text-[8px] flex items-center gap-1 z-10 border border-purple-400/50 uppercase font-bold text-white shadow-neon-purple"><Award size={10}/> {item.seriesName} #{item.seriesNumber}</div> )}
            
            <div className="h-48 bg-black/50 rounded mb-3 overflow-hidden relative group cursor-pointer" onClick={() => onViewItem(item)}>
                <MediaCarousel media={item.mediaUrls} fallback={item.imageUrl || item.image} />
                <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 bg-black/40 transition-opacity z-30 pointer-events-none"><Maximize2 size={24} className="text-white drop-shadow-md"/></div>
            </div>
            
            <div className="mb-2">
                <h3 className="font-bold text-lg leading-tight cursor-pointer hover:text-cyan-400" onClick={() => onViewItem(item)}>{item.name}</h3>
                <div className="flex justify-between items-center">
                    <div className="flex flex-col items-start gap-1">
                        <button onClick={() => onViewProfile(item.ownerPublicUid || item.ownerId)} className="text-xs text-pink-400 font-bold underline decoration-pink-500/40 underline-offset-2 hover:text-pink-300 cursor-pointer flex flex-col items-start gap-0.5"><UserRating sum={item.ownerRatingSum} count={item.ownerRatingCount} /><span className="flex items-center gap-0.5"><User size={10}/>@{item.ownerName}</span>{item.ownerBadge && <span className="flex"><BadgeChip badge={item.ownerBadge} /></span>}</button>
                        {user && !user.isAnonymous && item.ownerId !== user.uid && <AddFriendButton myProfile={profile} myUid={user.uid} targetUid={item.ownerId} targetName={item.ownerName} />}
                    </div>
                    <span className="text-lime-400 font-bold">
                        {item.isShowingOff ? <span className="text-[10px] text-fuchsia-200 bg-fuchsia-900/40 border border-fuchsia-500/40 px-2 py-1 rounded font-black uppercase">✨ Showing Off</span> : canSeePrice ? `$${item.price?.toFixed(2)}` : <span className="text-[10px] text-red-300 italic bg-red-900/40 border border-red-500/30 px-2 py-1 rounded font-bold">OUT OF STOCK</span>}
                    </span>
                </div>
                {item.description && (
                    <div className={`mt-1 ${item.description.length > 60 ? 'cursor-pointer' : ''}`} onClick={(e) => { if (item.description.length > 60) { e.stopPropagation(); setDescExpanded(!descExpanded); } }}>
                        <p className={`text-xs text-white/80 ${descExpanded ? 'whitespace-pre-wrap break-words' : 'truncate'}`}>{item.description}</p>
                        {item.description.length > 60 && (
                            <span className="text-[9px] text-cyan-400 font-bold flex items-center gap-1 mt-0.5">{descExpanded ? (<>Show Less <ChevronUp size={10}/></>) : (<>Read More <ChevronDown size={10}/></>)}</span>
                        )}
                    </div>
                )}
                <div className="flex gap-2 mt-2">
                    {item._boosted && <span className="text-[8px] bg-gradient-to-r from-yellow-300 to-pink-500 text-black px-1 rounded font-black uppercase">⚡ BOOSTED</span>}
                    {item.isShowingOff ? <span className="text-[8px] bg-fuchsia-500/20 text-fuchsia-300 px-1 rounded border border-fuchsia-500/50 font-bold uppercase">Showcase</span> : (item.stockQty ?? 1) <= 0 ? <span className="text-[8px] bg-red-900/60 text-red-300 px-1 rounded border border-red-500/40 font-bold uppercase">Out of Stock · Qty: 0</span> : <span className="text-[8px] bg-white/10 px-1 rounded border border-white/20">Qty: {Math.max(0, item.stockQty ?? 1)}</span>}
                    {!item.isShowingOff && isOwner && (item.stockQty ?? 1) <= 0 && <span className="text-[8px] text-lime-300 bg-lime-900/30 border border-lime-500/40 px-1 rounded font-bold">RESTOCK: Tap item → Edit</span>}
                    {!item.isShowingOff && ((item.bulkTiers && item.bulkTiers.length > 0) ? <span className="text-[8px] bg-lime-500/20 text-lime-400 px-1 rounded border border-lime-500/50">Bulk: {item.bulkTiers.map(t => `${t.qty}+ ${t.pct}%`).join(' · ')}</span> : (item.bulkDiscountPct > 0 && <span className="text-[8px] bg-lime-500/20 text-lime-400 px-1 rounded border border-lime-500/50">{item.bulkDiscountPct}% off {item.bulkDiscountQty}+</span>))}
                    <span className="text-[8px] bg-black/50 px-1 rounded border border-white/10 flex items-center gap-1"><Eye size={8}/> {item.viewCount || 0}</span>
                    {avgRating && <span className="text-[8px] bg-yellow-900/30 px-1 rounded border border-yellow-500/50 flex items-center gap-1 text-yellow-400"><StarIcon size={8} fill="currentColor"/> {avgRating}</span>}
                </div>
            </div>
            
            <div className="mt-auto flex justify-between items-center pt-3 border-t border-white/10">
                <div className="flex gap-3"><button onClick={toggleLike} className={liked ? 'text-pink-500' : 'text-white/50'}><Heart size={18} fill={liked?"currentColor":"none"}/></button><button onClick={() => setShowComments(true)} className="text-white/50 hover:text-white"><MessageSquare size={18}/></button><button onClick={handleShare} className="text-white/50 hover:text-cyan-400"><Share2 size={18}/></button></div>
                {item.isShowingOff ? ( <Button onClick={() => onViewItem(item)} color="purple" className="text-xs py-1 px-3 flex items-center gap-1"><Eye size={12}/> View</Button> ) : item.isAICreation && !item.allowBuy ? ( <Button onClick={() => onViewProfile(item.ownerPublicUid || item.ownerId)} color="purple" className="text-xs py-1 px-3">View Collection</Button> ) : ( <Button disabled={(item.stockQty !== undefined && item.stockQty !== null) ? item.stockQty <= 0 : item.purchaseCount > 0} onClick={() => onAddToCart(item)} color="accent" className="text-xs py-1 px-3 flex items-center gap-1"><ShoppingCart size={12}/> Add</Button> )}
            </div>
        </Card> 
    );
};

const SellKandiForm = ({ user, profile }) => {
    const [isOpen, setIsOpen] = useState(false);
    const [form, setForm] = useState({ name: '', price: '', description: '', type: 'Single (Bracelet)', isOfficial: false, stockQty: 1, bulkDiscountQty: '', bulkDiscountPct: '', bulkTiers: [{ qty: '', pct: '' }], isSeries: false, seriesName: '', seriesNumber: '', isPinned: false, isShowingOff: false });
    const [mediaFiles, setMediaFiles] = useState([]);
    const [loading, setLoading] = useState(false); const [uploadPercent, setUploadPercent] = useState(0);
    
    const handleFileChange = (e) => {
        const files = Array.from(e.target.files);
        if(files.length > 5) return alert("Maximum 5 files allowed.");
        const images = files.filter(f => f.type.startsWith('image/')).length;
        const videos = files.filter(f => f.type.startsWith('video/'));
        if(images > 3) return alert("Maximum 3 images allowed.");
        if(videos.length > 0) { alert("Heads up: post images here. To feature a video, use the homepage Festival Spotlight (paste a YouTube/TikTok/Instagram/Facebook link). Video files have been skipped."); }
        const imgOnly = files.filter(f => f.type.startsWith('image/'));
        if(imgOnly.length === 0) return alert("Please choose at least one image.");
        setMediaFiles(imgOnly);
    };

    const sub = async () => { 
        if(user?.isAnonymous) return alert("Please create an account to post items.");
        if (form.isShowingOff) {
            if (!form.name || mediaFiles.length === 0 || !user?.uid) return alert("Add a name and at least one photo to show off your piece.");
        } else {
            if(!form.name || !form.price || !form.stockQty || mediaFiles.length === 0 || !user?.uid) return alert("Fill all required fields including Stock Qty and Media.");
            if(parseInt(form.stockQty) < 1) return alert("Stock Quantity must be at least 1.");
        }
        setLoading(true); setUploadPercent(0);
        
        try { 
            let uploadedMedia = [];
            for(let i=0; i<mediaFiles.length; i++) {
                setUploadPercent(Math.round(((i) / mediaFiles.length) * 100));
                const imgStr = await compressImage(mediaFiles[i], null);
                uploadedMedia.push({ url: imgStr, type: mediaFiles[i].type.startsWith('video') ? 'video' : 'image', linkedItem: '' });
            }
            setUploadPercent(99);

            const cleanTiers = (form.bulkTiers || []).map(t => ({ qty: parseInt(t.qty)||0, pct: parseInt(t.pct)||0 })).filter(t => t.qty > 0 && t.pct > 0).sort((a,b) => a.qty - b.qty);
            const firstTier = cleanTiers[0] || { qty: 0, pct: 0 };
            const item = { ...form, price: form.isShowingOff ? 0 : parseFloat(form.price), type: form.type || 'Other', stockQty: form.isShowingOff ? 0 : parseInt(form.stockQty), bulkTiers: form.isShowingOff ? [] : cleanTiers, bulkDiscountQty: form.isShowingOff ? 0 : firstTier.qty, bulkDiscountPct: form.isShowingOff ? 0 : firstTier.pct, mediaUrls: uploadedMedia, imageUrl: uploadedMedia[0]?.url, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', ownerBadge: profile?.featuredBadge || null, ownerRatingSum: profile?.ratingSum || 0, ownerRatingCount: profile?.ratingCount || 0, timestamp: Date.now(), likes: [], comments: [], isAppProduct: form.isOfficial, status: 'approved', purchaseCount: 0, viewCount: 0, isPinned: form.isPinned, isCraftingStock: false, isShowingOff: !!form.isShowingOff }; 
            
            const batch = writeBatch(db);
            const publicRef = doc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'));
            batch.set(publicRef, item);
            const userColRef = doc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'));
            batch.set(userColRef, { ...item, refId: publicRef.id });
            await batch.commit(); setIsOpen(false); 
        } catch(e) { alert("Error: " + e.message); } finally { setLoading(false); setUploadPercent(0); setMediaFiles([]); } 
    };

    if(!isOpen) return <div className="mb-6"><p className="text-center text-[10px] text-yellow-300/80 mb-2">Not seeing any posts? Tap <strong>Clear Filters</strong> above to reset your search. 🔄</p><button onClick={() => setIsOpen(true)} className="w-full py-4 rounded-xl border-2 border-dashed border-white/20 hover:bg-white/10 flex items-center justify-center gap-2"><PlusCircle className="text-pink-500"/><span className="font-bold">Post Your Kandi</span></button></div>;
    return ( 
        <Card glow="primaryGlow" className="mb-6 relative">
            <button onClick={() => setIsOpen(false)} className="absolute top-2 right-2"><XCircle/></button>
            <h3 className="text-xl font-bold mb-4">New Post</h3>
            
            <div className="mb-3 bg-white/5 p-2 rounded border border-white/10">
                <label className="text-[10px] font-bold text-pink-400 mb-1 block">Upload Media (Max 3 Img, 2 Vid)</label>
                <input type="file" multiple accept="image/*,video/*" onChange={handleFileChange} className="text-[10px] w-full mb-1"/>
                <div className="flex gap-1 overflow-x-auto">
                    {mediaFiles.map((f, i) => <span key={i} className="text-[8px] bg-black/50 px-1 rounded truncate w-16 border border-white/10">{f.name}</span>)}
                </div>
                {loading && <div className="text-[10px] text-lime-400 font-bold mt-1 text-center">Uploading... {uploadPercent}%</div>}
            </div>

            <Input label="Name" value={form.name} onChange={v => setForm({...form, name: v})} />
            <div className="mb-4 bg-gradient-to-r from-fuchsia-900/30 to-pink-900/30 p-3 rounded-lg border border-fuchsia-500/40">
                <label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={form.isShowingOff} onChange={e=>setForm({...form, isShowingOff: e.target.checked})} className="accent-fuchsia-500 w-4 h-4"/><span className="text-xs font-black text-fuchsia-300 uppercase">✨ Just Showing Off (not for sale)</span></label>
                <p className="text-[9px] opacity-60 mt-1">Share your piece with the community without selling it — no price, no stock, no checkout. Pure flex. 🌈</p>
            </div>
            {!form.isShowingOff ? (
            <>
            <div className="grid grid-cols-2 gap-2">
                <Input label="Price ($)" type="number" value={form.price} onChange={v => setForm({...form, price: v})} />
                <Input label="Item Type" type="select" options={KANDI_TYPES} value={form.type} onChange={v => setForm({...form, type: v})} />
            </div>
            <div className="grid grid-cols-2 gap-2">
                <Input label="Stock Qty" type="number" value={form.stockQty} onChange={v => setForm({...form, stockQty: v})} />
                <div className="flex items-end"><p className="text-[9px] opacity-60 pb-2">Set bulk discounts below — buyers who add that many get the % off.</p></div>
            </div>
            </>
            ) : (
            <Input label="Item Type" type="select" options={KANDI_TYPES} value={form.type} onChange={v => setForm({...form, type: v})} />
            )}
            <div className="mb-4 bg-white/5 p-3 rounded border border-lime-500/20">
                <label className="text-[10px] font-bold text-lime-400 uppercase mb-2 block">Bulk Discount Tiers (optional)</label>
                {form.bulkTiers.map((t, i) => (
                    <div key={i} className="grid grid-cols-[1fr_1fr_auto] gap-2 mb-2 items-center">
                        <Input type="number" value={t.qty} onChange={v => { const nt=[...form.bulkTiers]; nt[i]={...nt[i],qty:v}; setForm({...form, bulkTiers: nt}); }} placeholder="Buy X+" className="mb-0"/>
                        <Input type="number" value={t.pct} onChange={v => { const nt=[...form.bulkTiers]; nt[i]={...nt[i],pct:v}; setForm({...form, bulkTiers: nt}); }} placeholder="% off" className="mb-0"/>
                        <button onClick={() => { const nt=form.bulkTiers.filter((_,idx)=>idx!==i); setForm({...form, bulkTiers: nt.length?nt:[{qty:'',pct:''}]}); }} className="text-red-400 p-1"><MinusCircle size={16}/></button>
                    </div>
                ))}
                {form.bulkTiers.length < 3 && <button onClick={() => setForm({...form, bulkTiers: [...form.bulkTiers, {qty:'',pct:''}]})} className="text-[10px] text-cyan-400 font-bold flex items-center gap-1"><PlusCircle size={12}/> Add another tier</button>}
                <p className="text-[8px] opacity-50 mt-1">Example: Buy 5+ → 10% off, Buy 10+ → 20% off. Discounts apply at checkout when buyers select quantity.</p>
            </div>
            
            <div className="mb-4 bg-white/5 p-3 rounded border border-white/10">
                <div className="flex items-center gap-2 mb-2">
                    <input type="checkbox" checked={form.isSeries} onChange={e=>setForm({...form, isSeries: e.target.checked})} className="accent-purple-500"/>
                    <span className="text-[10px] font-bold text-purple-400 uppercase">Part of a Series / Set</span>
                </div>
                {form.isSeries && (
                    <div className="grid grid-cols-2 gap-2 mt-2">
                        <Input value={form.seriesName} onChange={v => setForm({...form, seriesName: v})} placeholder="Collection Name" className="mb-0"/>
                        <Input value={form.seriesNumber} onChange={v => setForm({...form, seriesNumber: v})} placeholder="Edition #" className="mb-0"/>
                    </div>
                )}
            </div>

            <Input type="textarea" label="Description" value={form.description} onChange={v => setForm({...form, description: v})} />
            
            {(profile.isAdmin || profile.isKandiCreator) && (
                <div className="mb-4 flex flex-col gap-2">
                    <div className="flex items-center gap-2"><input type="checkbox" checked={form.isOfficial} onChange={e=>setForm({...form, isOfficial: e.target.checked})} className="accent-cyan-500"/><span className="text-xs font-bold text-cyan-400">Post as Official Product</span></div>
                    <div className="flex items-center gap-2"><input type="checkbox" checked={form.isPinned} onChange={e=>setForm({...form, isPinned: e.target.checked})} className="accent-pink-500"/><span className="text-xs font-bold text-pink-400">Pin to Profile Collection</span></div>
                </div>
            )}
            
            <Button onClick={sub} disabled={loading} color="lime" className="w-full flex justify-center items-center gap-2">{loading ? "Processing Media..." : "Post Now"}</Button>
        </Card> 
    );
};
EOF

# Block 15
cat << 'EOF' >> src/App.js
const FindUsersPanel = ({ onPick }) => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [q, setQ] = useState('');
    const [sortBy, setSortBy] = useState('joined');
    const [dir, setDir] = useState('desc');
    const [creatorsOnly, setCreatorsOnly] = useState(false);
    useEffect(() => {
        getDocs(query(collection(db, 'artifacts', appId, 'users'), limit(500)))
            .then(s => { setUsers(s.docs.map(d => ({ ...d.data(), id: d.id }))); setLoading(false); })
            .catch(e => { console.log('find users', e); setLoading(false); });
    }, []);
    const norm = (s) => (s || '').toString().toLowerCase();
    const SORTS = [
        { k: 'joined', label: 'Joined' }, { k: 'lastActive', label: 'Last Active' },
        { k: 'displayName', label: 'Name' }, { k: 'totalSalesValue', label: '$ Sold' },
        { k: 'itemsSold', label: 'Sold' }, { k: 'itemsBought', label: 'Bought' },
        { k: 'referrals', label: 'Referrals' }, { k: 'ratingCount', label: '# Ratings' },
        { k: 'radioMinutes', label: 'Radio Min' }, { k: 'creatorPoints', label: 'Creator Pts' },
    ];
    const filtered = users.filter(u => {
        if (creatorsOnly && !u.isKandiCreator) return false;
        const t = norm(q);
        if (!t) return true;
        return norm(u.displayName).includes(t) || norm(u.publicUid).includes(t) || norm(u.id).includes(t) || norm(u.nickname).includes(t);
    }).sort((a, b) => {
        let va = a[sortBy], vb = b[sortBy];
        if (sortBy === 'displayName') { va = norm(va); vb = norm(vb); return dir === 'asc' ? (va < vb ? -1 : va > vb ? 1 : 0) : (va > vb ? -1 : va < vb ? 1 : 0); }
        va = Number(va || 0); vb = Number(vb || 0);
        return dir === 'asc' ? va - vb : vb - va;
    });
    const fmtDate = (t) => t ? new Date(t).toLocaleDateString() : '—';
    const ago = (t) => { if (!t) return 'never'; const m = Math.floor((Date.now() - t) / 60000); if (m < 5) return '🟢 online'; if (m < 60) return m + 'm ago'; const h = Math.floor(m / 60); if (h < 24) return h + 'h ago'; return Math.floor(h / 24) + 'd ago'; };
    return (
        <div className="bg-white/5 p-3 rounded mb-4 border border-cyan-500/20">
            <h4 className="text-[10px] uppercase font-bold text-cyan-400 mb-2 flex items-center gap-1"><Users size={12}/> Find Users — Directory ({filtered.length})</h4>
            <input value={q} onChange={e => setQ(e.target.value)} placeholder="Filter by name, UID, nickname…" className="w-full bg-black border border-white/20 text-xs p-2 rounded mb-2"/>
            <div className="flex items-center gap-2 mb-2 flex-wrap">
                <select value={sortBy} onChange={e => setSortBy(e.target.value)} className="bg-black border border-white/20 text-[10px] p-1.5 rounded flex-1 min-w-[100px]">
                    {SORTS.map(s => <option key={s.k} value={s.k}>Sort: {s.label}</option>)}
                </select>
                <button onClick={() => setDir(dir === 'asc' ? 'desc' : 'asc')} className="bg-black border border-white/20 text-[10px] p-1.5 rounded px-2">{dir === 'asc' ? '↑ Asc' : '↓ Desc'}</button>
                <label className="text-[9px] flex items-center gap-1"><input type="checkbox" checked={creatorsOnly} onChange={e => setCreatorsOnly(e.target.checked)} className="accent-pink-500"/> Creators</label>
            </div>
            {loading ? <p className="text-center opacity-50 text-xs py-6">Loading directory…</p> : (
                <div className="max-h-[50vh] overflow-y-auto space-y-1 pr-1">
                    {filtered.length === 0 && <p className="text-center opacity-50 text-xs py-6">No users match.</p>}
                    {filtered.map(u => (
                        <button key={u.id} onClick={() => onPick && onPick(u)} className="w-full flex items-center gap-2 p-2 rounded bg-black/40 hover:bg-white/10 text-left border border-white/5">
                            <img src={u.photoURL || 'https://placehold.co/40?text=U'} className="w-9 h-9 rounded-full object-cover border border-pink-500/40 shrink-0"/>
                            <div className="flex-1 min-w-0">
                                <p className="text-[11px] font-bold truncate flex items-center gap-1">@{u.displayName || 'Raver'}{u.isKandiCreator && <Hammer size={9} className="text-yellow-400"/>}{u.isAdmin && <span className="text-[7px] text-red-400">TEAM</span>}{u.bannedUntil && <Ban size={9} className="text-red-500"/>}</p>
                                <p className="text-[8px] font-mono opacity-50 truncate">{u.publicUid || u.id}</p>
                                <p className="text-[8px] opacity-60">Joined {fmtDate(u.joined)} · active {ago(u.lastActive)}</p>
                            </div>
                            <div className="text-right shrink-0 text-[8px] opacity-70">
                                <p>${Number(u.totalSalesValue || 0).toFixed(0)} sold</p>
                                <p>{u.itemsSold || 0} items · {u.referrals || 0} refs</p>
                                {u.ratingCount > 0 && <p className="text-yellow-400">★ {((u.ratingSum||0)/u.ratingCount).toFixed(1)}</p>}
                            </div>
                        </button>
                    ))}
                </div>
            )}
            <p className="text-[7px] opacity-40 mt-2">Tap a user to load them into the User Manager below for actions.</p>
        </div>
    );
};

// V61: Admin force-clip + placeholder manager. Lets an admin push one or more rotational
// festival clips directly (no daily limit, marked isForced), and configure a PLACEHOLDER clip
// that shows whenever no live clip is active — so the spotlight is never empty. When a forced
// or user clip's window expires, the panel rotates back to this placeholder automatically.
const ForceClipPanel = ({ cfg, setCfg }) => {
    const [url, setUrl] = useState('');
    const [caption, setCaption] = useState('');
    const [name, setName] = useState('');
    const [mins, setMins] = useState(30);
    const [count, setCount] = useState(1);
    const [busy, setBusy] = useState(false);
    const parsed = url.trim() ? parseVideoLink(url) : null;

    const pushForced = async () => {
        if (!parsed || !parsed.ok) { alert('Paste a valid YouTube, TikTok, Instagram, or Facebook clip link first.'); return; }
        setBusy(true);
        try {
            const W = (parseInt(mins) || 30) * 60000;
            const n = Math.max(1, Math.min(parseInt(count) || 1, 20));
            // Chain the forced clips back-to-back starting now.
            let cursor = Date.now();
            for (let i = 0; i < n; i++) {
                const slotId = 'forced_' + cursor;
                await setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'videoSlots', slotId), {
                    uid: 'admin', name: (name.trim() || 'RaveKandi'), ownerPublicUid: 'admin',
                    platform: parsed.platform, embedUrl: parsed.embedUrl || null, watchUrl: parsed.watchUrl,
                    caption: (caption || '').slice(0, 100), postedAt: Date.now(),
                    start: cursor, end: cursor + W, isForced: true
                });
                cursor += W;
            }
            alert('Forced ' + n + ' clip window(s) live now (' + mins + ' min each).');
            setUrl(''); setCaption(''); setName('');
        } catch (e) { alert('Failed: ' + e.message); }
        setBusy(false);
    };

    const phParsed = (cfg.spotlightPlaceholderUrl || '').trim() ? parseVideoLink(cfg.spotlightPlaceholderUrl) : null;

    return (
        <div className="space-y-3">
            <div className="bg-pink-900/20 border border-pink-500/40 rounded-lg p-3 space-y-2">
                <h4 className="text-[11px] font-black uppercase text-pink-300">🎬 Force Rotational Clip(s)</h4>
                <input value={url} onChange={e => setUrl(e.target.value)} placeholder="Paste YouTube / TikTok / Instagram / Facebook link" className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                {parsed && <p className={`text-[9px] ${parsed.ok ? 'text-lime-400' : 'text-red-400'}`}>{parsed.ok ? '✓ ' + parsed.platform + ' clip verified' : parsed.reason}</p>}
                <input value={name} onChange={e => setName(e.target.value)} placeholder="Display name (default: RaveKandi)" className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                <input value={caption} onChange={e => setCaption(e.target.value)} maxLength={100} placeholder="Caption (optional)" className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                <div className="flex gap-2">
                    <div className="flex-1">
                        <label className="text-[8px] uppercase opacity-60 block mb-0.5">Minutes each</label>
                        <input type="number" min="1" value={mins} onChange={e => setMins(e.target.value)} className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                    </div>
                    <div className="flex-1">
                        <label className="text-[8px] uppercase opacity-60 block mb-0.5"># of windows</label>
                        <input type="number" min="1" max="20" value={count} onChange={e => setCount(e.target.value)} className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                    </div>
                </div>
                <Button onClick={pushForced} disabled={busy || !parsed?.ok} color="primary" className="w-full text-xs">{busy ? 'Pushing…' : 'Force Clip(s) Live 🎬'}</Button>
                <p className="text-[8px] opacity-50">Forced clips bypass the daily limit and chain back-to-back from now. Multiple windows = the same clip repeats, or use the takedown panel to manage them.</p>
            </div>

            <div className="bg-purple-900/20 border border-purple-500/40 rounded-lg p-3 space-y-2">
                <h4 className="text-[11px] font-black uppercase text-purple-300">📌 Spotlight Placeholder</h4>
                <label className="flex items-center gap-2 text-[10px] font-bold"><input type="checkbox" checked={!!cfg.spotlightPlaceholderActive} onChange={e => setCfg({ ...cfg, spotlightPlaceholderActive: e.target.checked })} className="accent-purple-500"/> Show placeholder when no clip is live</label>
                <input value={cfg.spotlightPlaceholderUrl || ''} onChange={e => setCfg({ ...cfg, spotlightPlaceholderUrl: e.target.value })} placeholder="Placeholder clip link (YouTube/TikTok/IG/FB)" className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                {phParsed && <p className={`text-[9px] ${phParsed.ok ? 'text-lime-400' : 'text-red-400'}`}>{phParsed.ok ? '✓ ' + phParsed.platform + ' placeholder verified' : phParsed.reason}</p>}
                <input value={cfg.spotlightPlaceholderName || ''} onChange={e => setCfg({ ...cfg, spotlightPlaceholderName: e.target.value })} placeholder="Placeholder name (default: RaveKandi)" className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                <input value={cfg.spotlightPlaceholderCaption || ''} onChange={e => setCfg({ ...cfg, spotlightPlaceholderCaption: e.target.value })} maxLength={100} placeholder="Placeholder caption (optional)" className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                <p className="text-[8px] opacity-50">When a real clip's window ends, the spotlight rotates back to this placeholder instead of going empty. Save config below to apply.</p>
            </div>

            <VideoTakedownPanel />
        </div>
    );
};

const VideoTakedownPanel = () => {
    const [vids, setVids] = useState([]);
    useEffect(() => onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'videoSlots')), s => setVids(s.docs.map(d => ({ ...d.data(), id: d.id })).sort((a, b) => a.start - b.start)), e => console.log(e)), []);
    const takedown = async (v) => {
        if (!window.confirm('Take down @' + v.name + "'s featured clip? This clears its window immediately.")) return;
        try { await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'videoSlots', v.id)); alert('Clip taken down.'); } catch (e) { alert('Failed: ' + e.message); }
    };
    const fmtT = (t) => new Date(t).toLocaleString([], { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
    const now = Date.now();
    return (
        <div className="space-y-2 max-h-60 overflow-y-auto pr-1">
            {vids.length === 0 && <p className="text-[10px] opacity-50 text-center py-3">No featured clips currently posted or queued.</p>}
            {vids.map(v => {
                const live = v.start <= now && now < v.end;
                return (
                    <div key={v.id} className={`flex items-center gap-2 p-2 rounded border ${live ? 'border-lime-400/60 bg-lime-900/10' : 'border-white/10 bg-white/5'}`}>
                        <a href={v.watchUrl} target="_blank" rel="noreferrer" className="w-12 h-12 rounded bg-black shrink-0 flex items-center justify-center border border-white/10"><Play size={18} className="text-pink-400"/></a>
                        <div className="flex-1 min-w-0">
                            <p className="text-[10px] font-bold truncate">@{v.name} <span className="text-[7px] bg-white/10 text-white/60 px-1 rounded uppercase">{v.platform}</span> {live && <span className="text-[7px] bg-lime-500 text-black px-1 rounded font-black uppercase">Live</span>}</p>
                            <p className="text-[8px] opacity-50 truncate">{v.caption || 'No caption'}</p>
                            <p className="text-[8px] opacity-40">{fmtT(v.start)} – {fmtT(v.end)}</p>
                        </div>
                        <button onClick={() => takedown(v)} className="bg-red-500/20 text-red-400 p-2 rounded hover:bg-red-500/40 shrink-0" title="Take down"><Trash2 size={14}/></button>
                    </div>
                );
            })}
        </div>
    );
};

const DurationPicker = ({ label, valueMs, onSet }) => {
    const [qty, setQty] = useState(1);
    const [unit, setUnit] = useState('hours');
    const units = { minutes: 60000, hours: 3600000, days: 86400000, weeks: 604800000 };
    const active = valueMs && valueMs > Date.now();
    const remain = active ? Math.max(0, valueMs - Date.now()) : 0;
    const fmtRemain = () => {
        if (!active) return 'no expiry set';
        const h = Math.floor(remain / 3600000), m = Math.floor((remain % 3600000) / 60000);
        if (h >= 24) return Math.floor(h / 24) + 'd ' + (h % 24) + 'h left';
        return h + 'h ' + m + 'm left';
    };
    return (
        <div className="bg-black/30 rounded p-2">
            <label className="text-[9px] font-bold uppercase opacity-70 block mb-1">{label}</label>
            <div className="flex gap-1 items-center flex-wrap">
                <input type="number" min="1" value={qty} onChange={e => setQty(e.target.value)} className="bg-black border border-white/20 text-[10px] p-1.5 rounded w-14"/>
                <select value={unit} onChange={e => setUnit(e.target.value)} className="bg-black border border-white/20 text-[10px] p-1.5 rounded">
                    <option value="minutes">Minutes</option><option value="hours">Hours</option><option value="days">Days</option><option value="weeks">Weeks</option>
                </select>
                <button onClick={() => onSet(Date.now() + (parseInt(qty) || 1) * units[unit])} className="bg-lime-600/40 text-lime-200 border border-lime-400/40 rounded px-2 py-1 text-[10px] font-bold">Set</button>
                <button onClick={() => onSet(0)} className="bg-white/10 text-white/60 border border-white/20 rounded px-2 py-1 text-[10px]">No expiry</button>
            </div>
            <p className="text-[8px] mt-1 text-cyan-300">{fmtRemain()}{active ? ' (expires ' + new Date(valueMs).toLocaleString() + ')' : ''}</p>
        </div>
    );
};

const TUTORIAL_STEPS = [
    { tut: null, title: 'Welcome to RaveKandi! 🌈', body: "Let's take a 30-second tour of the app. We'll show you the main features — tap Next to begin!", center: true },
    { tut: 'feed', title: 'The Feed 🛍️', body: "This is the community marketplace. Every post is an item a raver is selling or showing off — kandi, gear, custom pieces. Tap a post to view or buy, tap a @name to visit their profile." },
    { tut: 'shop', title: 'The Custom Lab 🧪', body: "This is where custom creations happen! Use the AI Design Lab to plan a piece (materials, cost & build time), or the DIY tab to request a custom build from a Creator. You can also list your own items to sell here." },
    { tut: 'profile', title: 'Your Profile 👤', body: "Your home base. Set up your shop, pin your best pieces, show your collection, earn badges, and manage your settings. Your Friend UID here is also your referral code!" },
    { tut: 'inbox', title: 'Inbox & Notifications 📬', body: "Message other ravers, get notified about sales, friend requests, comments and more. Tap a notification to jump straight to it." },
    { tut: 'cart', title: 'Your Cart 🛒', body: "Items you're ready to buy land here. (Heads up: payments are in test mode during Alpha.)" },
    { tut: 'home', title: 'Home Button 🏠', body: "Tap the RaveKandi logo anytime to return home. From here you can reach the DIY builder, your VIP perks, and everything else." },
    { tut: null, title: "You're all set! 🎉", body: "That's the tour! Almost everything in the app is tappable — explore and find hidden features. You can replay this tutorial anytime from Settings. Welcome to the tribe! 🌈", center: true }
];

const TutorialOverlay = ({ active, onFinish }) => {
    const [step, setStep] = useState(0);
    const [rect, setRect] = useState(null);
    // Always begin at step 1 each time the tutorial opens (fresh launch or replay from Settings).
    useEffect(() => { if (active) setStep(0); }, [active]);
    const cur = TUTORIAL_STEPS[step];
    useEffect(() => {
        if (!active) return;
        const measure = () => {
            if (!cur || !cur.tut || cur.center) { setRect(null); return; }
            const el = document.querySelector('[data-tut="' + cur.tut + '"]');
            if (el) { const r = el.getBoundingClientRect(); setRect({ top: r.top, left: r.left, width: r.width, height: r.height }); }
            else setRect(null);
        };
        measure();
        const t = setTimeout(measure, 60);
        window.addEventListener('resize', measure);
        window.addEventListener('scroll', measure, true);
        return () => { clearTimeout(t); window.removeEventListener('resize', measure); window.removeEventListener('scroll', measure, true); };
    }, [active, step]);
    if (!active || !cur) return null;
    const last = step === TUTORIAL_STEPS.length - 1;
    const pad = 8;
    const hole = rect ? { top: rect.top - pad, left: rect.left - pad, width: rect.width + pad * 2, height: rect.height + pad * 2 } : null;
    const noteTop = hole ? (hole.top < window.innerHeight / 2 ? hole.top + hole.height + 16 : null) : null;
    const noteBottom = hole ? (hole.top >= window.innerHeight / 2 ? (window.innerHeight - hole.top) + 16 : null) : null;
    const finish = () => { setStep(0); onFinish(); };
    const next = () => { if (last) finish(); else setStep(step + 1); };
    const back = () => { if (step > 0) setStep(step - 1); };
    return createPortal(
        <div className="fixed inset-0 z-[2000]" style={{ pointerEvents: 'none' }}>
            {hole ? (
                <>
                    <div className="absolute bg-black/80" style={{ top: 0, left: 0, right: 0, height: Math.max(0, hole.top), pointerEvents: 'auto' }}/>
                    <div className="absolute bg-black/80" style={{ top: hole.top, left: 0, width: Math.max(0, hole.left), height: hole.height, pointerEvents: 'auto' }}/>
                    <div className="absolute bg-black/80" style={{ top: hole.top, left: hole.left + hole.width, right: 0, height: hole.height, pointerEvents: 'auto' }}/>
                    <div className="absolute bg-black/80" style={{ top: hole.top + hole.height, left: 0, right: 0, bottom: 0, pointerEvents: 'auto' }}/>
                    <div className="absolute rounded-xl border-2 border-pink-400 animate-pulse" style={{ top: hole.top, left: hole.left, width: hole.width, height: hole.height, boxShadow: '0 0 20px rgba(236,72,153,0.6)', pointerEvents: 'none' }}/>
                </>
            ) : (
                <div className="absolute inset-0 bg-black/85" style={{ pointerEvents: 'auto' }}/>
            )}
            <div className="absolute left-1/2 -translate-x-1/2 w-[88%] max-w-sm" style={{ pointerEvents: 'auto', ...(cur.center ? { top: '50%', transform: 'translate(-50%,-50%)' } : noteTop != null ? { top: noteTop } : { bottom: noteBottom }) }}>
                <div className="bg-gradient-to-br from-purple-700 via-fuchsia-700 to-purple-800 border-2 border-pink-300 rounded-2xl p-5 shadow-[0_0_30px_rgba(236,72,153,0.5)]">
                    <p className="text-[10px] uppercase font-black tracking-widest text-pink-200 mb-1">Step {step + 1} of {TUTORIAL_STEPS.length}</p>
                    <h3 className="text-xl font-black text-white mb-2">{cur.title}</h3>
                    <p className="text-sm text-white/90 leading-relaxed mb-4">{cur.body}</p>
                    <div className="flex items-center justify-between gap-2">
                        <button onClick={finish} className="text-[11px] text-white/60 underline">Skip tour</button>
                        <div className="flex items-center gap-2">
                            {step > 0 && <button onClick={back} className="bg-white/15 text-white font-bold text-sm px-4 py-2 rounded-full hover:bg-white/25 active:scale-95 transition flex items-center gap-1"><ChevronLeft size={16}/> Back</button>}
                            <button onClick={next} className="bg-white text-purple-800 font-black uppercase text-sm px-6 py-2 rounded-full hover:bg-pink-100 active:scale-95 transition">{last ? 'Finish 🎉' : 'Next →'}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>, document.body);
};

const TutorialReminderPopIn = ({ active, onClose }) => {
    if (!active) return null;
    return createPortal(
        <div className="fixed inset-0 z-[1500] bg-black/80 flex items-center justify-center p-4" onClick={onClose}>
            <div onClick={e => e.stopPropagation()} className="relative max-w-sm w-full rounded-2xl border-2 border-cyan-400/60 bg-gradient-to-br from-purple-900 via-indigo-900 to-cyan-900 p-5 text-center shadow-[0_0_30px_rgba(0,255,255,0.3)]">
                <button onClick={onClose} className="absolute -top-2 -right-2 bg-black/80 text-white rounded-full p-1 border border-white/40"><X size={16}/></button>
                <div className="text-4xl mb-2">🧭</div>
                <p className="text-cyan-200 font-black uppercase text-xs tracking-widest mb-2">Need a refresher?</p>
                <p className="text-white text-sm leading-relaxed">You can replay the app tutorial anytime — find <strong>"Replay Tutorial"</strong> in your Settings. Happy raving! 🌈</p>
                <button onClick={onClose} className="mt-4 bg-cyan-500 text-black font-black uppercase text-xs px-6 py-2 rounded-full hover:bg-cyan-400 active:scale-95">Got it!</button>
            </div>
        </div>, document.body);
};

const POPIN_THEMES = {
    message: { grad: 'from-purple-600 via-fuchsia-600 to-purple-700', border: 'border-purple-300', icon: '💬', label: 'Message' },
    maintenance: { grad: 'from-amber-600 via-yellow-600 to-orange-700', border: 'border-amber-300', icon: '🛠️', label: 'Maintenance' },
    sale: { grad: 'from-pink-600 via-red-600 to-rose-700', border: 'border-pink-300', icon: '🔥', label: 'Sale' },
    offer: { grad: 'from-green-600 via-emerald-600 to-teal-700', border: 'border-green-300', icon: '🎁', label: 'Special Offer' },
    update: { grad: 'from-cyan-600 via-sky-600 to-blue-700', border: 'border-cyan-300', icon: '🚀', label: 'Update' },
    event: { grad: 'from-pink-500 via-purple-500 to-cyan-500', border: 'border-fuchsia-300', icon: '🎉', label: 'Event' },
    warning: { grad: 'from-orange-600 via-red-600 to-red-800', border: 'border-orange-300', icon: '⚠️', label: 'Important' },
    celebration: { grad: 'from-yellow-500 via-amber-500 to-orange-500', border: 'border-yellow-200', icon: '🥳', label: 'Celebration' }
};
const AnnouncementPopIn = ({ cfg }) => {
    const [dismissed, setDismissed] = useState(false);
    const id = cfg?.popInId || '';
    useEffect(() => { try { if (id && localStorage.getItem('rk_popin_seen') === id) setDismissed(true); else setDismissed(false); } catch (e) {} }, [id]);
    if (!cfg?.popInActive || !id) return null;
    if (cfg.popInExpiry > 0 && Date.now() > cfg.popInExpiry) return null;
    if (dismissed) return null;
    const theme = POPIN_THEMES[cfg.popInTheme] || POPIN_THEMES.message;
    const close = () => { try { localStorage.setItem('rk_popin_seen', id); } catch (e) {} setDismissed(true); };
    return createPortal(
        <div className="fixed inset-0 z-[300] bg-black/85 flex items-center justify-center p-4" onClick={close}>
            <div onClick={e => e.stopPropagation()} className={`relative max-w-md w-full rounded-3xl border-4 ${theme.border} bg-gradient-to-br ${theme.grad} shadow-[0_0_40px_rgba(255,255,255,0.3)] p-6 text-center`}>
                <button onClick={close} className="absolute -top-3 -right-3 bg-black/80 text-white rounded-full p-1.5 border-2 border-white/40 hover:scale-110 transition"><X size={20}/></button>
                <div className="text-5xl mb-2">{theme.icon}</div>
                <p className="text-[10px] uppercase font-black tracking-widest text-white/80 mb-3">{theme.label}</p>
                {cfg.popInMedia && (cfg.popInMediaType === 'video'
                    ? <video src={cfg.popInMedia} autoPlay loop muted playsInline className="w-full rounded-xl mb-3 max-h-60 object-cover"/>
                    : <img src={cfg.popInMedia} className="w-full rounded-xl mb-3 max-h-60 object-cover"/>)}
                <p className="text-white font-bold text-lg leading-relaxed whitespace-pre-wrap break-words drop-shadow">{cfg.popInMessage}</p>
                <button onClick={close} className="mt-5 bg-white/90 text-black font-black uppercase tracking-wide text-sm px-8 py-2.5 rounded-full hover:bg-white transition active:scale-95">Got it!</button>
            </div>
        </div>, document.body);
};

const DiscoveryTip = ({ cfg }) => {
    const [show, setShow] = useState(false);
    useEffect(() => {
        const mins = cfg?.discoveryTipMin || 0;
        if (!mins || mins <= 0) return;
        let last = 0; try { last = parseInt(localStorage.getItem('rk_tip_last') || '0'); } catch (e) {}
        const due = !last || (Date.now() - last) > mins * 60000;
        const t = setTimeout(() => { setShow(true); try { localStorage.setItem('rk_tip_last', String(Date.now())); } catch (e) {} }, due ? 8000 : mins * 60000);
        return () => clearTimeout(t);
    }, [cfg?.discoveryTipMin]);
    if (!show) return null;
    return createPortal(
        <div className="fixed inset-0 z-[290] bg-black/70 flex items-center justify-center p-4" onClick={() => setShow(false)}>
            <div onClick={e => e.stopPropagation()} className="relative max-w-sm w-full rounded-2xl border-2 border-cyan-400/60 bg-gradient-to-br from-purple-900 via-indigo-900 to-cyan-900 p-5 text-center shadow-[0_0_30px_rgba(0,255,255,0.3)]">
                <button onClick={() => setShow(false)} className="absolute -top-2 -right-2 bg-black/80 text-white rounded-full p-1 border border-white/40"><X size={16}/></button>
                <div className="text-4xl mb-2">💡✨</div>
                <p className="text-cyan-200 font-black uppercase text-xs tracking-widest mb-2">Pro Tip</p>
                <p className="text-white text-sm leading-relaxed">Almost <strong>everything</strong> on your screen is clickable and has a purpose! Tap names, badges, stats, icons, and items to discover hidden features. Explore RaveKandi — there's more than meets the eye. 🌈</p>
                <button onClick={() => setShow(false)} className="mt-4 bg-cyan-500 text-black font-black uppercase text-xs px-6 py-2 rounded-full hover:bg-cyan-400 active:scale-95">Explore!</button>
            </div>
        </div>, document.body);
};

const AdminAnalyticsBlock = () => {
    const [stats, setStats] = useState(null);
    useEffect(() => onSnapshot(doc(db, 'artifacts', appId, 'global', 'stats'), s => setStats(s.exists() ? s.data() : {}), e => {}), []);
    if (!stats) return null;
    const visitors = stats.uniqueVisitors || 0;
    const accounts = stats.userCount || 0;
    const conv = visitors > 0 ? ((accounts / visitors) * 100).toFixed(1) : '0';
    // last 7 days of DAU keys
    const days = [];
    for (let i = 6; i >= 0; i--) { const d = new Date(Date.now() - i * 86400000).toISOString().slice(0, 10); days.push({ d, n: stats['dau_' + d] || 0 }); }
    const todayKey = new Date().toISOString().slice(0, 10);
    return (
        <div className="bg-gradient-to-br from-purple-900/30 to-cyan-900/20 border border-purple-500/40 rounded-lg p-3 my-2">
            <h4 className="text-[11px] font-black uppercase text-purple-300 mb-2 flex items-center gap-1">📊 Traffic & Growth</h4>
            <div className="grid grid-cols-3 gap-2 mb-2">
                <div className="bg-black/40 rounded p-2 text-center"><p className="text-lg font-black text-cyan-300">{visitors.toLocaleString()}</p><p className="text-[8px] opacity-70 uppercase">Unique Visitors</p></div>
                <div className="bg-black/40 rounded p-2 text-center"><p className="text-lg font-black text-lime-300">{accounts.toLocaleString()}</p><p className="text-[8px] opacity-70 uppercase">Accounts</p></div>
                <div className="bg-black/40 rounded p-2 text-center"><p className="text-lg font-black text-pink-300">{conv}%</p><p className="text-[8px] opacity-70 uppercase">Signup Rate</p></div>
            </div>
            <p className="text-[9px] font-bold opacity-70 mb-1">Daily Active (last 7 days)</p>
            <div className="flex items-end gap-1 h-16">
                {days.map((day, i) => { const max = Math.max(1, ...days.map(x => x.n)); const h = Math.max(4, (day.n / max) * 100); return (
                    <div key={i} className="flex-1 flex flex-col items-center gap-0.5">
                        <div className={`w-full rounded-t ${day.d === todayKey ? 'bg-lime-400' : 'bg-purple-500/60'}`} style={{ height: h + '%' }} title={day.d + ': ' + day.n}></div>
                        <span className="text-[7px] opacity-50">{day.d.slice(5)}</span>
                        <span className="text-[7px] font-bold">{day.n}</span>
                    </div>
                ); })}
            </div>
            <p className="text-[7px] opacity-40 mt-2">Unique visitors = distinct devices that opened the app (incl. guests). Signup rate = accounts ÷ visitors. Counts started when this feature shipped.</p>
        </div>
    );
};

const RemoteConfigPanel = () => {
    const [cfg, setCfg] = useState(null);
    const [saving, setSaving] = useState(false);
    useEffect(() => onSnapshot(doc(db, 'artifacts', appId, 'global', 'config'), s => setCfg({ checkoutEnabled: true, paymentsLive: false, bannersEnabled: true, boostsEnabled: true, aiLabEnabled: true, launchPerks: true, maintenanceMessage: '', minVersion: '', marqueeSpeed: 60, videoRotateSec: 8, videoWindowMin: 30, bannerAnnounceOnly: false, maintenanceExpiry: 0, popInActive: false, popInMessage: '', popInTheme: 'message', popInMedia: '', popInMediaType: '', popInExpiry: 0, popInId: '', discoveryTipMin: 0, spotlightPlaceholderActive: false, spotlightPlaceholderUrl: '', spotlightPlaceholderCaption: '', spotlightPlaceholderName: 'RaveKandi', chatDelaySec: 8, chatVipShareMax: 5, chatCollectionShareMax: 5, ...(s.exists() ? s.data() : {}) }), e => console.log(e)), []);
    if (!cfg) return <p className="text-[10px] opacity-50">Loading config…</p>;
    const T = ({ k, label }) => (
        <button onClick={() => setCfg({ ...cfg, [k]: !cfg[k] })} className={`p-2 rounded border text-[9px] font-bold uppercase ${cfg[k] ? 'border-lime-400 bg-lime-500/15 text-lime-300' : 'border-red-400 bg-red-500/15 text-red-300'}`}>{label}: {cfg[k] ? 'ON' : 'OFF'}</button>
    );
    const save = async () => { setSaving(true); try { await setDoc(doc(db, 'artifacts', appId, 'global', 'config'), cfg, { merge: true }); alert('Config pushed live to all users.'); } catch (e) { alert('Save failed: ' + e.message); } finally { setSaving(false); } };
    return (
        <div className="space-y-2">
            <div className="grid grid-cols-2 gap-2">
                <T k="checkoutEnabled" label="Checkout"/><T k="aiLabEnabled" label="AI Lab"/><T k="bannersEnabled" label="Banners"/><T k="boostsEnabled" label="Boosts"/><T k="launchPerks" label="Launch Perks"/><T k="paymentsLive" label="Payments LIVE"/>
            </div>
            <div className="bg-amber-900/20 border border-amber-500/40 rounded-lg p-3 space-y-2">
                <h4 className="text-[11px] font-black uppercase text-amber-300 flex items-center gap-1">📢 Banner Announcement</h4>
                <Input label="Message (blank = hidden)" value={cfg.maintenanceMessage || ''} onChange={v => setCfg({ ...cfg, maintenanceMessage: v })}/>
                <label className="flex items-center gap-2 text-[10px]"><input type="checkbox" checked={!!cfg.bannerAnnounceOnly} onChange={e => setCfg({ ...cfg, bannerAnnounceOnly: e.target.checked })} className="accent-amber-500"/> Show as the ONLY banner message (hide marquee while active)</label>
                <DurationPicker label="Auto-expire after" valueMs={cfg.maintenanceExpiry} onSet={(ms) => setCfg({ ...cfg, maintenanceExpiry: ms })}/>
            </div>
            <div className="bg-purple-900/20 border border-purple-500/40 rounded-lg p-3 space-y-2">
                <h4 className="text-[11px] font-black uppercase text-purple-300 flex items-center gap-1">🪧 Full-Screen Pop-In</h4>
                <label className="flex items-center gap-2 text-[10px] font-bold"><input type="checkbox" checked={!!cfg.popInActive} onChange={e => setCfg({ ...cfg, popInActive: e.target.checked, popInId: e.target.checked ? ('pop_' + Date.now()) : (cfg.popInId || '') })} className="accent-purple-500"/> Pop-In ACTIVE (forces over every screen for all users)</label>
                <div>
                    <label className="text-[10px] font-bold text-purple-300 uppercase block mb-1">Theme</label>
                    <select value={cfg.popInTheme || 'message'} onChange={e => setCfg({ ...cfg, popInTheme: e.target.value })} className="w-full bg-black border border-white/20 text-xs p-2 rounded">
                        <option value="message">💬 Message (purple)</option>
                        <option value="maintenance">🛠️ Maintenance (amber)</option>
                        <option value="sale">🔥 Sale (red/pink)</option>
                        <option value="offer">🎁 Offer (green)</option>
                        <option value="update">🚀 Update (cyan)</option>
                        <option value="event">🎉 Event (rainbow)</option>
                        <option value="warning">⚠️ Warning (orange)</option>
                        <option value="celebration">🥳 Celebration (gold)</option>
                    </select>
                </div>
                <textarea value={cfg.popInMessage || ''} onChange={e => setCfg({ ...cfg, popInMessage: e.target.value })} placeholder="Your pop-in message..." className="w-full bg-black/50 border border-white/20 rounded p-2 text-xs h-20"/>
                <div>
                    <label className="text-[10px] font-bold text-purple-300 uppercase block mb-1">Image / Video (optional, &lt;5MB)</label>
                    <input type="file" accept="image/*,video/*" onChange={(e) => {
                        const file = e.target.files?.[0]; if (!file) return;
                        if (file.size > 5 * 1024 * 1024) { alert('Please use a file under 5MB (it embeds inline). For big HD videos, host them and paste a URL in the message.'); return; }
                        const reader = new FileReader();
                        reader.onload = () => setCfg({ ...cfg, popInMedia: reader.result, popInMediaType: file.type.startsWith('video') ? 'video' : 'image' });
                        reader.readAsDataURL(file);
                    }} className="text-[10px] w-full"/>
                    {cfg.popInMedia && <p className="text-[8px] text-lime-400 mt-1">✓ Media attached ({cfg.popInMediaType || 'image'}). <button onClick={() => setCfg({ ...cfg, popInMedia: '', popInMediaType: '' })} className="text-red-400 underline">remove</button></p>}
                </div>
                <DurationPicker label="Auto-dismiss after" valueMs={cfg.popInExpiry} onSet={(ms) => setCfg({ ...cfg, popInExpiry: ms })}/>
            </div>
            <Input label="Minimum Version (e.g. 42.11.00 — blank = no gate)" value={cfg.minVersion || ''} onChange={v => setCfg({ ...cfg, minVersion: v })}/>
            <div>
                <label className="text-[10px] font-bold text-pink-300 uppercase block mb-1">🎬 Festival Clip Window (slot length)</label>
                <select value={cfg.videoWindowMin || 30} onChange={e => setCfg({ ...cfg, videoWindowMin: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded">
                    {[1,5,10,15,30,45,60,90,120].map(m => <option key={m} value={m}>{m} minute{m>1?'s':''} per clip</option>)}
                </select>
                <p className="text-[8px] opacity-60 mt-1">How long each clip stays featured. Applies to newly-posted clips. Users who post mid-window now get the NEXT full slot (+10% bonus time).</p>
            </div>
            <div>
                <label className="text-[10px] font-bold text-cyan-300 uppercase block mb-1">📺 Time Between Clip Rotations</label>
                <select value={cfg.videoRotateSec || 8} onChange={e => setCfg({ ...cfg, videoRotateSec: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded">
                    {[3,5,8,10,15,20,30].map(s => <option key={s} value={s}>{s} seconds</option>)}
                </select>
                <p className="text-[8px] opacity-60 mt-1">When multiple clips are queued in the same window, how fast the panel cycles between them in preview.</p>
            </div>
            <div>
                <label className="text-[10px] font-bold text-lime-300 uppercase block mb-1">🏃 Marquee Scroll Speed</label>
                <select value={cfg.marqueeSpeed || 60} onChange={e => setCfg({ ...cfg, marqueeSpeed: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded">
                    <option value={30}>Fast (30s)</option><option value={45}>Brisk (45s)</option><option value={60}>Normal (60s)</option><option value={90}>Relaxed (90s)</option><option value={120}>Slow (120s)</option><option value={180}>Very Slow (180s)</option>
                </select>
                <p className="text-[8px] opacity-60 mt-1">Lower = the top banner scrolls faster. Takes effect immediately for all users.</p>
            </div>

            <div className="bg-pink-900/20 border border-pink-500/40 rounded-lg p-3 space-y-2">
                <h4 className="text-[11px] font-black uppercase text-pink-300">💬 Radio Chat Controls</h4>
                <div>
                    <label className="text-[9px] font-bold uppercase opacity-70 block mb-1">Message delay (anti-spam, non-VIP)</label>
                    <select value={cfg.chatDelaySec || 8} onChange={e => setCfg({ ...cfg, chatDelaySec: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded">
                        {[0,3,5,8,10,15,20,30].map(s => <option key={s} value={s}>{s === 0 ? 'No delay' : s + ' seconds between messages'}</option>)}
                    </select>
                    <p className="text-[8px] opacity-50 mt-1">VIP users bypass this delay entirely.</p>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div>
                        <label className="text-[9px] font-bold uppercase opacity-70 block mb-1">VIP link shares/day</label>
                        <input type="number" min="0" max="50" value={cfg.chatVipShareMax ?? 5} onChange={e => setCfg({ ...cfg, chatVipShareMax: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                    </div>
                    <div>
                        <label className="text-[9px] font-bold uppercase opacity-70 block mb-1">Collection shares/day</label>
                        <input type="number" min="0" max="50" value={cfg.chatCollectionShareMax ?? 5} onChange={e => setCfg({ ...cfg, chatCollectionShareMax: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded"/>
                    </div>
                </div>
            </div>

            <div className="bg-cyan-900/20 border border-cyan-500/40 rounded-lg p-3">
                <label className="text-[10px] font-bold text-cyan-300 uppercase block mb-1">💡 Discovery Tip Frequency</label>
                <select value={cfg.discoveryTipMin || 0} onChange={e => setCfg({ ...cfg, discoveryTipMin: parseInt(e.target.value) })} className="w-full bg-black border border-white/20 text-xs p-2 rounded">
                    <option value={0}>Off</option>
                    <option value={30}>Every 30 minutes</option>
                    <option value={60}>Every hour</option>
                    <option value={180}>Every 3 hours</option>
                    <option value={360}>Every 6 hours</option>
                    <option value={720}>Every 12 hours</option>
                    <option value={1440}>Once a day</option>
                </select>
                <p className="text-[8px] opacity-60 mt-1">A friendly pop-in reminding users almost everything is clickable — encourages exploration. At most once per interval per device.</p>
            </div>

            <AdminAnalyticsBlock />
            <p className="text-[8px] opacity-60">⚠ "Payments LIVE" stays OFF until real billing is wired — turning it on blocks checkout with an explanatory notice (it will never silently fake-charge).</p>
            <p className="text-[8px] opacity-60">🎉 "Launch Perks" = free VIP for everyone + commission cut 20%→10%. Turn OFF at full release to restore paid plans and normal rates.</p>
            <div className="border-t border-white/10 pt-3 mt-2">
                <h4 className="text-[11px] font-black uppercase text-pink-300 mb-2">🎬 Festival Spotlight Control</h4>
                <ForceClipPanel cfg={cfg} setCfg={setCfg} />
                <p className="text-[8px] opacity-50 mt-1">Placeholder settings save with the button below. Forced clips push live immediately.</p>
            </div>
            <Button onClick={save} disabled={saving} color="purple" className="w-full text-xs">{saving ? 'Pushing…' : 'Push Config Live'}</Button>
        </div>
    );
};

const AdminDashboard = ({ user, profile, onMessageUser }) => {
    const [adminTab, setAdminTab] = useState('tools');
    const [apps, setApps] = useState([]);
    const [targetUid, setTargetUid] = useState('');
    const [customRate, setCustomRate] = useState('');
    const [tickets, setTickets] = useState([]);
    const [ticketFilter, setTicketFilter] = useState('open');
    const [searchUid, setSearchUid] = useState('');
    const [managedUser, setManagedUser] = useState(null);
    const [revPct, setRevPct] = useState('');
    const [commInput, setCommInput] = useState('');
    const [vipQty, setVipQty] = useState(1);
    const [vipUnit, setVipUnit] = useState('months');
    const [forceBadgeId, setForceBadgeId] = useState('');
    const [statEdits, setStatEdits] = useState({});
    const [batchRate, setBatchRate] = useState('');
    const [batchBusy, setBatchBusy] = useState(false);

    useEffect(() => onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications'), where('status', '==', 'pending')), s => setApps(s.docs.map(d => ({...d.data(), id: d.id})))), []);
    useEffect(() => onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tickets')), s => setTickets(s.docs.map(d => ({...d.data(), id: d.id})).sort((a,b)=>(b.createdAt||0)-(a.createdAt||0)))), []);

    const [reviewApp, setReviewApp] = useState(null); // V48: the application being reviewed in the pop-in
    const approve = async (a) => { if(window.confirm("Approve?")) { await updateDoc(doc(db, 'artifacts', appId, 'users', a.uid), { isKandiCreator: true }); await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications', a.id), { status: 'approved' }); } };
    // V48: set an application's status (approve / deny / pending / waitlist) + notify + grant.
    const setAppStatus = async (a, status) => {
        try {
            await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications', a.id), { status, reviewedAt: Date.now() });
            if (status === 'approved') { await setDoc(doc(db, 'artifacts', appId, 'users', a.uid), { isKandiCreator: true }, { merge: true }); pushNotif(a.uid, 'admin', '🎉 Your Creator application was APPROVED! You can now post official drops, take DIY commissions & pin items. PLUR!'); }
            else if (status === 'denied') { pushNotif(a.uid, 'admin', '📋 Your Creator application was reviewed and not approved this time. You\'re welcome to refine your portfolio and reapply.'); }
            else if (status === 'waitlist') { pushNotif(a.uid, 'admin', '⏳ Your Creator application has been WAIT-LISTED. You\'re in the queue — we\'ll reach out as spots open up!'); }
            else if (status === 'pending') { pushNotif(a.uid, 'admin', '📋 Your Creator application is back under review.'); }
            alert('Application marked: ' + status);
            if (status !== 'pending') setReviewApp(null);
        } catch (e) { alert('Failed: ' + e.message); }
    };
    // V48: grant/revoke VIP straight from the review pop-in (or user manager).
    const forceVipDuration = async () => {
        if (!managedUser) { alert("Find & select a user first."); return; }
        const units = { days: 86400000, weeks: 604800000, months: 2592000000, years: 31536000000 };
        const ms = (parseInt(vipQty) || 1) * (units[vipUnit] || units.months);
        const expires = Date.now() + ms;
        try {
            await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { isVIP: true, vipPlan: 'admin_granted', vipSince: Date.now(), vipExpires: expires }, { merge: true });
            pushNotif(managedUser.id, 'admin', '⭐ You\'ve been granted VIP for ' + vipQty + ' ' + vipUnit + '! Enjoy 6 Profile Pins, Themes, Banners, Boosts & the Font Selector. PLUR!');
            alert('@' + (managedUser.displayName || 'user') + ' is now VIP until ' + new Date(expires).toLocaleDateString() + '.');
            setManagedUser({ ...managedUser, isVIP: true, vipExpires: expires });
        } catch (e) { alert('Failed: ' + e.message); }
    };
    const forceVipPermanent = async () => {
        if (!managedUser) { alert("Find & select a user first."); return; }
        try {
            await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { isVIP: true, vipPlan: 'lifetime', lifetimeVipGranted: true, vipSince: Date.now(), vipExpires: null }, { merge: true });
            pushNotif(managedUser.id, 'admin', '👑 You\'ve been granted PERMANENT VIP! All premium perks are yours forever. PLUR!');
            alert('@' + (managedUser.displayName || 'user') + ' now has PERMANENT VIP.');
            setManagedUser({ ...managedUser, isVIP: true, vipPlan: 'lifetime', vipExpires: null });
        } catch (e) { alert('Failed: ' + e.message); }
    };
    const setVipFor = async (uid, name, grant) => {
        if (!uid) return;
        try {
            if (grant) await setDoc(doc(db, 'artifacts', appId, 'users', uid), { isVIP: true, vipPlan: 'lifetime', vipSince: Date.now(), vipExpires: null }, { merge: true });
            else await setDoc(doc(db, 'artifacts', appId, 'users', uid), { isVIP: false, vipPlan: 'none', vipExpires: null }, { merge: true });
            alert('@' + (name || 'user') + (grant ? ' is now VIP (lifetime).' : ' VIP removed.'));
        } catch (e) { alert('Failed: ' + e.message); }
    };
    
    const setCommRate = async () => {
        if(!targetUid || !customRate) return;
        await updateDoc(doc(db, 'artifacts', appId, 'users', targetUid), { customCommissionRate: parseFloat(customRate) });
        alert(`Commission rate for ${targetUid} set to ${customRate}`);
        setTargetUid(''); setCustomRate('');
    };

    const [userMatches, setUserMatches] = useState([]);
    const findUser = async () => {
        const term = searchUid.trim();
        if (!term) return;
        const norm = (s) => (s || '').toString().toLowerCase().replace(/[^a-z0-9]/g, '');
        const nt = norm(term);
        try {
            // 1) exact publicUid
            let found = null;
            const exactSnap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', term)));
            if (!exactSnap.empty) { const d = exactSnap.docs[0]; found = { ...d.data(), id: d.id }; }
            // 2) exact raw doc id
            if (!found) { const direct = await getDoc(doc(db, 'artifacts', appId, 'users', term)); if (direct.exists()) found = { ...direct.data(), id: direct.id }; }
            if (found) { setManagedUser(found); setRevPct(found.customRevSharePct ?? ''); setUserMatches([]); setStatEdits({}); setForceBadgeId(''); return; }
            // 3) FUZZY: scan recent users, match partial on name / publicUid / nickname / id
            const dirSnap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), orderBy('joined', 'desc'), limit(200)));
            const matches = dirSnap.docs.map(d => ({ ...d.data(), id: d.id })).filter(u =>
                norm(u.displayName).includes(nt) || norm(u.publicUid).includes(nt) || norm(u.nickname).includes(nt) || norm(u.id).includes(nt)
            ).slice(0, 12);
            if (matches.length === 0) return alert("No users found matching \"" + term + "\". Try part of their name or UID.");
            if (matches.length === 1) { setManagedUser(matches[0]); setRevPct(matches[0].customRevSharePct ?? ''); setUserMatches([]); setStatEdits({}); setForceBadgeId(''); }
            else setUserMatches(matches); // show a picker
        } catch (e) { alert(e.message); }
    };
    const pickUser = (u) => { setManagedUser(u); setRevPct(u.customRevSharePct ?? ''); setUserMatches([]); setStatEdits({}); setForceBadgeId(''); };

    const toggleCreator = async (grant) => {
        if (!managedUser) return;
        if (!window.confirm((grant ? 'GRANT' : 'REVOKE') + ' Kandi Creator status for @' + managedUser.displayName + '?')) return;
        try {
            await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { isKandiCreator: !!grant }, { merge: true });
            setManagedUser({ ...managedUser, isKandiCreator: !!grant });
            if (grant) pushNotif(managedUser.id, 'admin', '🔨 You\'ve been granted Official Kandi Creator status! You can now post official drops, take DIY commissions, and pin featured items. PLUR!');
            alert('@' + managedUser.displayName + (grant ? ' is now a Kandi Creator.' : ' is no longer a Kandi Creator.'));
        } catch (e) { alert('Failed: ' + e.message); }
    };
    const forceBadge = async () => {
        if (!managedUser) return;
        try {
            const next = forceBadgeId ? { id: forceBadgeId, name: (ACHIEVEMENT_TIERS.find(a => a.id === forceBadgeId)?.name || forceBadgeId), forced: true } : null;
            await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { featuredBadge: next }, { merge: true });
            setManagedUser({ ...managedUser, featuredBadge: next });
            alert(next ? ('Badge "' + next.name + '" forced onto @' + managedUser.displayName) : 'Badge cleared.');
        } catch (e) { alert('Failed: ' + e.message); }
    };
    const STAT_FIELDS = [
        { k: 'itemsSold', label: 'Items Sold' }, { k: 'itemsBought', label: 'Items Bought' },
        { k: 'totalSalesValue', label: '$ Sold' }, { k: 'totalBoughtValue', label: '$ Bought' },
        { k: 'totalLikes', label: 'Likes' }, { k: 'totalComments', label: 'Comments' },
        { k: 'referrals', label: 'Referrals' }, { k: 'completedTrades', label: 'Completed Trades' },
        { k: 'radioMinutes', label: 'Radio Minutes' }, { k: 'videosPosted', label: 'Videos Posted' },
    ];
    const saveStats = async () => {
        if (!managedUser) return;
        const upd = {};
        Object.keys(statEdits).forEach(k => { if (statEdits[k] !== '' && statEdits[k] != null && !isNaN(Number(statEdits[k]))) upd[k] = Number(statEdits[k]); });
        if (Object.keys(upd).length === 0) return alert('Enter at least one stat value to change.');
        if (!window.confirm('Overwrite these stats for @' + managedUser.displayName + '? ' + JSON.stringify(upd))) return;
        try {
            await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), upd, { merge: true });
            setManagedUser({ ...managedUser, ...upd }); setStatEdits({});
            alert('Stats updated.');
        } catch (e) { alert('Failed: ' + e.message); }
    };
    const batchCommission = async () => {
        const rate = parseFloat(batchRate);
        if (isNaN(rate) || rate < 0 || rate > 1) return alert('Enter a rate between 0 and 1 (e.g. 0.10 for 10%).');
        if (!window.confirm('Set commission rate to ' + (rate*100).toFixed(0) + '% for ALL Creators? This overrides every Creator\'s customCommissionRate.')) return;
        setBatchBusy(true);
        try {
            const snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('isKandiCreator', '==', true)));
            const batch = writeBatch(db);
            snap.docs.forEach(d => batch.set(d.ref, { customCommissionRate: rate }, { merge: true }));
            await batch.commit();
            alert('Updated commission for ' + snap.size + ' Creator(s) to ' + (rate*100).toFixed(0) + '%.');
            setBatchRate('');
        } catch (e) { alert('Batch failed: ' + e.message); } finally { setBatchBusy(false); }
    };
    const saveCommission = async (val) => {
        if (!managedUser) { alert("Find & select a user first (search above or use the directory)."); return; }
        try {
            if (val === null || val === '' || val === undefined) {
                await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { customCommissionRate: null }, { merge: true });
                alert('Commission override removed for @' + (managedUser.displayName || 'user') + ' — they now use the standard rate.');
            } else {
                let rate = parseFloat(val);
                if (isNaN(rate)) { alert("Enter a number, e.g. 0.10 for 10%."); return; }
                if (rate > 1) rate = rate / 100; // allow "10" to mean 10%
                rate = Math.max(0, Math.min(1, rate));
                await setDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { customCommissionRate: rate }, { merge: true });
                alert('Commission for @' + (managedUser.displayName || 'user') + ' set to ' + (rate * 100).toFixed(0) + '%.');
            }
            setManagedUser({ ...managedUser, customCommissionRate: (val === null || val === '') ? null : (parseFloat(val) > 1 ? parseFloat(val)/100 : parseFloat(val)) });
            setCommInput('');
        } catch (e) { alert("Couldn't set commission: " + e.message); }
    };

    const saveRevShare = async (val) => {
        if (!managedUser) return;
        const pct = val === null || val === '' ? null : Math.min(100, Math.max(0, parseFloat(val)));
        if (val !== null && val !== '' && isNaN(pct)) return alert("Enter a valid percentage (0-100).");
        await updateDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { customRevSharePct: pct });
        setManagedUser({ ...managedUser, customRevSharePct: pct });
        alert(pct === null ? "Override removed - user returns to standard tier rates." : `RevShare locked at ${pct}% for ${managedUser.displayName}.`);
    };

    const banUser = async (durationMs, label) => {
        if (!managedUser) return;
        const reason = prompt(`Reason for ${label} ban of ${managedUser.displayName}:`);
        if (reason === null) return;
        const until = durationMs === 'permanent' ? 'permanent' : Date.now() + durationMs;
        await updateDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { bannedUntil: until, banReason: reason || 'Violation of community guidelines' });
        setManagedUser({ ...managedUser, bannedUntil: until });
        alert(`${managedUser.displayName} banned ${label}.`);
    };
    const unban = async () => {
        if (!managedUser) return;
        await updateDoc(doc(db, 'artifacts', appId, 'users', managedUser.id), { bannedUntil: null, banReason: null });
        setManagedUser({ ...managedUser, bannedUntil: null });
        alert("User unbanned.");
    };
    const setTicketStatus = async (t, status) => { await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tickets', t.id), { status }); };

    const isBanned = managedUser?.bannedUntil && (managedUser.bannedUntil === 'permanent' || managedUser.bannedUntil > Date.now());
    const visibleTickets = tickets.filter(t => ticketFilter === 'all' ? true : (t.status || 'open') === ticketFilter);

    return (
        <Card className="mt-8 border-red-500/30">
            <div className="flex gap-2 mb-4">
                <button onClick={() => setAdminTab('tools')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${adminTab==='tools' ? 'bg-red-600 text-white' : 'bg-white/5 text-white/50'}`}>Admin Tools</button>
                <button onClick={() => setAdminTab('tickets')} className={`flex-1 py-2 rounded font-black uppercase text-[10px] tracking-widest ${adminTab==='tickets' ? 'bg-yellow-500 text-black' : 'bg-white/5 text-white/50'}`}>Feedback & Tickets ({tickets.filter(t=>(t.status||'open')==='open').length})</button>
            </div>

            {adminTab === 'tools' && (<>
            <h3 className="font-bold text-red-400 mb-4 uppercase italic">Admin Console</h3>

            <div className="bg-white/5 p-3 rounded mb-4 border border-purple-500/40">
                <h4 className="text-[10px] uppercase font-bold text-purple-300 mb-2">🛰 Remote Config — live for all users</h4>
                <RemoteConfigPanel />
            </div>

            <div className="bg-white/5 p-3 rounded mb-4 border border-red-500/40">
                <h4 className="text-[10px] uppercase font-bold text-red-300 mb-2">🎬 Featured Videos — Moderation</h4>
                <p className="text-[8px] opacity-60 mb-2">Take down any user clip instantly. Force clips &amp; the placeholder are in Remote Config above.</p>
                <VideoTakedownPanel />
            </div>

            <FindUsersPanel onPick={(u) => { pickUser(u); setSearchUid(u.publicUid || u.id); try { window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' }); } catch (e) {} }} />

            <div className="bg-white/5 p-3 rounded mb-4 border border-white/10">
                <h4 className="text-[10px] uppercase font-bold text-cyan-400 mb-2">User Manager — RevShare & Bans</h4>
                <div className="flex gap-2 mb-1">
                    <Input value={searchUid} onChange={setSearchUid} placeholder="Name, UID, or part of either…" className="mb-0 flex-1" />
                    <Button onClick={findUser} color="cyan" className="text-[10px]">Find</Button>
                </div>
                <p className="text-[8px] opacity-40 mb-3">Tip: partial matches work — type any part of a name or UID.</p>
                {userMatches.length > 0 && (
                    <div className="bg-black/50 border border-cyan-500/30 rounded p-2 mb-3 space-y-1">
                        <p className="text-[9px] uppercase font-bold text-cyan-400 mb-1">{userMatches.length} matches — tap one:</p>
                        {userMatches.map(u => (
                            <button key={u.id} onClick={() => pickUser(u)} className="w-full flex items-center gap-2 p-1.5 rounded bg-white/5 hover:bg-white/10 text-left">
                                <img src={u.photoURL || 'https://placehold.co/40?text=U'} className="w-7 h-7 rounded-full object-cover border border-pink-500/40"/>
                                <div className="flex-1 min-w-0"><p className="text-[10px] font-bold truncate">@{u.displayName || 'Raver'}</p><p className="text-[8px] font-mono opacity-50 truncate">{u.publicUid || u.id}</p></div>
                            </button>
                        ))}
                    </div>
                )}
                {managedUser && (
                    <div className="bg-black/50 border border-white/10 rounded p-3 space-y-3">
                        <div className="flex justify-between items-center flex-wrap gap-1">
                            <div><p className="font-bold text-sm text-white">@{managedUser.displayName}</p><p className="text-[8px] opacity-50 font-mono break-all">{managedUser.id}</p></div>
                            {isBanned && <span className="text-[8px] font-black bg-red-600 px-2 py-1 rounded uppercase">BANNED {managedUser.bannedUntil === 'permanent' ? 'PERMANENTLY' : 'until ' + new Date(managedUser.bannedUntil).toLocaleDateString()}</span>}
                        </div>
                        <div>
                            <p className="text-[9px] font-bold text-lime-400 uppercase mb-1">RevShare Override (Earned Tier: {getReferralTier(managedUser.referrals || 0).badge} @ {getReferralTier(managedUser.referrals || 0).sharePct}%)</p>
                            <div className="flex gap-1 items-center flex-wrap">
                                <select value={revPct} onChange={e=>setRevPct(e.target.value)} className="bg-black border border-white/20 text-[10px] p-2 rounded flex-1 min-w-[100px]">
                                    <option value="">— Pick Tier / % —</option>
                                    {REFERRAL_TIERS.map(t => <option key={t.badge} value={t.sharePct}>{t.badge} ({t.sharePct}%)</option>)}
                                    <option value="10">Promoter (10%)</option>
                                    <option value="25">Partner (25%)</option>
                                    <option value="50">Equity (50%)</option>
                                    <option value="100">Full (100%)</option>
                                </select>
                                <input value={revPct} onChange={e=>setRevPct(e.target.value)} type="number" min="0" max="100" placeholder="%" className="bg-black border border-white/20 text-[10px] p-2 rounded w-16"/>
                                <Button onClick={() => saveRevShare(revPct)} color="lime" className="text-[10px]">Set</Button>
                                <Button onClick={() => saveRevShare(null)} color="accent" className="text-[10px]">Reset</Button>
                            </div>
                            {managedUser.customRevSharePct != null && <p className="text-[8px] text-yellow-400 mt-1">Active override: {managedUser.customRevSharePct}% — replaces tier rate on all future RevShare payouts.</p>}

                            <div className="mt-3 pt-3 border-t border-white/10">
                                <p className="text-[9px] font-black uppercase text-pink-300 mb-1">Seller Commission Rate</p>
                                <div className="flex gap-2 items-center flex-wrap">
                                    <select value={commInput} onChange={e => setCommInput(e.target.value)} className="bg-black border border-white/20 text-[10px] p-2 rounded flex-1 min-w-[90px]">
                                        <option value="">— Quick set —</option>
                                        <option value="0">0% (free)</option>
                                        <option value="0.05">5%</option>
                                        <option value="0.10">10%</option>
                                        <option value="0.15">15%</option>
                                        <option value="0.20">20% (standard)</option>
                                    </select>
                                    <input value={commInput} onChange={e => setCommInput(e.target.value)} type="number" step="0.01" min="0" max="1" placeholder="0.10" className="bg-black border border-white/20 text-[10px] p-2 rounded w-20"/>
                                    <Button onClick={() => saveCommission(commInput)} color="lime" className="text-[10px]">Set</Button>
                                    <Button onClick={() => saveCommission(null)} color="accent" className="text-[10px]">Reset</Button>
                                </div>
                                <p className="text-[8px] opacity-50 mt-1">Current: {managedUser.customCommissionRate != null ? (managedUser.customCommissionRate * 100).toFixed(0) + '% (override)' : 'standard 20%'}{managedUser.lockedCommissionRate != null ? ' · 🔒 launch-locked at ' + (managedUser.lockedCommissionRate * 100).toFixed(0) + '%' : ''}. Enter 0.10 for 10% (or just 10).</p>
                            </div>

                            <div className="mt-3 pt-3 border-t border-white/10">
                                <p className="text-[9px] font-black uppercase text-yellow-300 mb-1">⭐ VIP Status</p>
                                <p className="text-[8px] opacity-60 mb-2">Current: {managedUser.isVIP ? (managedUser.vipPlan === 'lifetime' ? '👑 Permanent VIP' : (managedUser.vipExpires ? 'VIP until ' + new Date(managedUser.vipExpires).toLocaleDateString() : 'VIP active')) : 'Not VIP'}</p>
                                <div className="flex gap-2 items-center mb-2">
                                    <input value={vipQty} onChange={e => setVipQty(e.target.value)} type="number" min="1" className="bg-black border border-white/20 text-[10px] p-2 rounded w-16"/>
                                    <select value={vipUnit} onChange={e => setVipUnit(e.target.value)} className="bg-black border border-white/20 text-[10px] p-2 rounded flex-1">
                                        <option value="days">Days</option><option value="weeks">Weeks</option><option value="months">Months</option><option value="years">Years</option>
                                    </select>
                                    <Button onClick={forceVipDuration} color="gold" className="text-[10px]">Grant</Button>
                                </div>
                                <div className="flex gap-2">
                                    <Button onClick={forceVipPermanent} color="gold" className="flex-1 text-[10px]">👑 Permanent VIP</Button>
                                    <Button onClick={() => setVipFor(managedUser.id, managedUser.displayName, false)} color="accent" className="flex-1 text-[10px]">Remove VIP</Button>
                                </div>
                            </div>
                        </div>
                        <div>
                            <p className="text-[9px] font-bold text-red-400 uppercase mb-1">Account Bans</p>
                            <div className="grid grid-cols-5 gap-1">
                                <Button onClick={() => banUser(86400000, '24 hours')} color="accent" className="text-[8px] py-1 px-1">24h</Button>
                                <Button onClick={() => banUser(604800000, '7 days')} color="accent" className="text-[8px] py-1 px-1">7d</Button>
                                <Button onClick={() => banUser(2592000000, '30 days')} color="accent" className="text-[8px] py-1 px-1">30d</Button>
                                <Button onClick={() => banUser('permanent', 'permanently')} color="red" className="text-[8px] py-1 px-1">Perm</Button>
                                <Button onClick={unban} color="lime" className="text-[8px] py-1 px-1">Unban</Button>
                            </div>
                        </div>
                        <div>
                            <p className="text-[9px] font-bold text-orange-400 uppercase mb-1">🔨 Kandi Creator Status</p>
                            <div className="flex items-center gap-2">
                                <span className={`text-[10px] font-bold flex-1 ${managedUser.isKandiCreator ? 'text-lime-400' : 'opacity-50'}`}>{managedUser.isKandiCreator ? '✅ Currently a Creator' : 'Not a Creator'}</span>
                                {managedUser.isKandiCreator
                                    ? <Button onClick={() => toggleCreator(false)} color="red" className="text-[9px] py-1 px-2">Revoke</Button>
                                    : <Button onClick={() => toggleCreator(true)} color="lime" className="text-[9px] py-1 px-2">Grant Creator</Button>}
                            </div>
                        </div>
                        <div>
                            <p className="text-[9px] font-bold text-yellow-400 uppercase mb-1">Force Badge</p>
                            <div className="flex gap-1 items-center">
                                <select value={forceBadgeId} onChange={e=>setForceBadgeId(e.target.value)} className="bg-black border border-white/20 text-[10px] p-2 rounded flex-1">
                                    <option value="">— No badge / clear —</option>
                                    {ACHIEVEMENT_TIERS.map(a => <option key={a.id} value={a.id}>{a.name}</option>)}
                                </select>
                                <Button onClick={forceBadge} color="gold" className="text-[10px]">Apply</Button>
                            </div>
                            {managedUser.featuredBadge && <p className="text-[8px] text-yellow-300 mt-1">Current: {managedUser.featuredBadge.name}{managedUser.featuredBadge.forced ? ' (forced)' : ''}</p>}
                        </div>
                        <div>
                            <p className="text-[9px] font-bold text-cyan-400 uppercase mb-1">Edit Statistics</p>
                            <div className="grid grid-cols-2 gap-1">
                                {STAT_FIELDS.map(f => (
                                    <div key={f.k} className="flex flex-col">
                                        <label className="text-[7px] opacity-60 uppercase">{f.label} <span className="opacity-40">(now {managedUser[f.k] || 0})</span></label>
                                        <input type="number" value={statEdits[f.k] ?? ''} onChange={e=>setStatEdits({...statEdits, [f.k]: e.target.value})} placeholder={String(managedUser[f.k] || 0)} className="bg-black border border-white/20 text-[10px] p-1 rounded"/>
                                    </div>
                                ))}
                            </div>
                            <Button onClick={saveStats} color="cyan" className="text-[10px] w-full mt-2">Save Stat Changes</Button>
                            <p className="text-[7px] opacity-50 mt-1">Sets exact values (overwrites, not adds). Leave blank to keep current.</p>
                        </div>
                    </div>
                )}
                <div className="mt-3 pt-3 border-t border-white/10">
                    <p className="text-[9px] font-bold text-pink-400 uppercase mb-1">⚡ Batch: Set Commission for ALL Creators</p>
                    <div className="flex gap-1 items-center">
                        <input type="number" step="0.01" min="0" max="1" value={batchRate} onChange={e=>setBatchRate(e.target.value)} placeholder="e.g. 0.10" className="bg-black border border-white/20 text-[10px] p-2 rounded flex-1"/>
                        <Button onClick={batchCommission} disabled={batchBusy} color="pink" className="text-[10px]">{batchBusy ? 'Working…' : 'Apply to All'}</Button>
                    </div>
                    <p className="text-[7px] opacity-50 mt-1">0.10 = 10%. Overrides every Creator's individual rate at once.</p>
                </div>
            </div>

            <div className="bg-white/5 p-3 rounded mb-4 border border-white/10">
                <h4 className="text-[10px] uppercase font-bold text-red-400 mb-2">Custom Fee Overrides</h4>
                <div className="flex gap-2">
                    <Input value={targetUid} onChange={setTargetUid} placeholder="Legacy: exact doc-ID only" className="mb-0 flex-1" />
                    <Input value={customRate} onChange={setCustomRate} type="number" placeholder="0.10" className="mb-0 w-24" />
                    <Button onClick={setCommRate} color="red" className="text-[10px]">Set</Button>
                </div>
                <p className="text-[8px] opacity-50 mt-1">Default rate is 0.20. Lowering this overrides the app's cut for specific promoters.</p>
            </div>

            {apps.length > 0 && <h4 className="text-[10px] uppercase font-bold text-red-400 mb-2">Pending Creator Applications ({apps.length})</h4>}
            {apps.length === 0 && <p className="text-center opacity-50 text-xs py-4">No pending applications.</p>}
            {apps.map(a => (
                <button key={a.id} onClick={() => setReviewApp(a)} className="w-full bg-white/5 hover:bg-white/10 p-3 rounded mb-2 flex justify-between items-center text-left border border-white/10">
                    <div className="min-w-0">
                        <p className="text-sm font-bold truncate">{a.name || 'Unnamed'}</p>
                        <p className="text-[9px] opacity-50 truncate">{a.email} · {a.yearsCreating} crafting · {a.submittedAt ? new Date(a.submittedAt).toLocaleDateString() : ''}</p>
                    </div>
                    <span className="text-[9px] font-black uppercase bg-cyan-500/20 text-cyan-300 px-2 py-1 rounded shrink-0">Review →</span>
                </button>
            ))}

            {reviewApp && (
                <Modal isOpen={!!reviewApp} onClose={() => setReviewApp(null)} title="📋 Creator Application Review">
                    <div className="space-y-3">
                        <div className="bg-black/50 border border-white/10 rounded-lg p-3 space-y-2">
                            {[['Name / DJ Name', reviewApp.name], ['Contact Email', reviewApp.email], ['Main Social', reviewApp.social], ['Portfolio', reviewApp.portfolio], ['Years in Scene', reviewApp.yearsRaving], ['Years Crafting', reviewApp.yearsCreating]].map(([k, v]) => (
                                <div key={k} className="flex justify-between gap-3 text-[11px]"><span className="opacity-50 shrink-0">{k}</span><span className="font-bold text-right break-all">{v && (k.includes('Social') || k.includes('Portfolio')) && /^https?:\/\//.test(v) ? <a href={v} target="_blank" rel="noreferrer" className="text-cyan-400 underline">{v}</a> : (v || '—')}</span></div>
                            ))}
                            <div className="pt-2 border-t border-white/10"><p className="text-[10px] opacity-50 mb-1">Rave Experience & Kandi Style</p><p className="text-[11px] leading-relaxed bg-white/5 rounded p-2">{reviewApp.experience || '—'}</p></div>
                            <p className="text-[8px] opacity-40">UID: {reviewApp.uid}</p>
                        </div>

                        <Button onClick={() => { if (onMessageUser) onMessageUser(reviewApp.uid, reviewApp.name); setReviewApp(null); }} color="purple" className="w-full text-xs flex items-center justify-center gap-2"><Mail size={14}/> Message {reviewApp.name || 'Applicant'}</Button>

                        <div>
                            <p className="text-[9px] font-black uppercase text-cyan-400 mb-1">Decision</p>
                            <div className="grid grid-cols-2 gap-2">
                                <Button onClick={() => setAppStatus(reviewApp, 'approved')} color="lime" className="text-[10px] py-2">✅ Approve</Button>
                                <Button onClick={() => setAppStatus(reviewApp, 'denied')} color="red" className="text-[10px] py-2">⛔ Deny</Button>
                                <Button onClick={() => setAppStatus(reviewApp, 'waitlist')} color="gold" className="text-[10px] py-2">⏳ Wait-List</Button>
                                <Button onClick={() => setAppStatus(reviewApp, 'pending')} color="cyan" className="text-[10px] py-2">📋 Keep Pending</Button>
                            </div>
                        </div>

                        <div className="bg-pink-950/20 border border-pink-500/30 rounded-lg p-3 space-y-2">
                            <p className="text-[9px] font-black uppercase text-pink-300">Instant Perks for this Applicant</p>
                            <div className="grid grid-cols-2 gap-2">
                                <Button onClick={() => setVipFor(reviewApp.uid, reviewApp.name, true)} color="gold" className="text-[9px] py-1.5">⭐ Grant VIP</Button>
                                <Button onClick={() => setVipFor(reviewApp.uid, reviewApp.name, false)} color="accent" className="text-[9px] py-1.5">Remove VIP</Button>
                            </div>
                            <Button onClick={async () => { const u = await getDoc(doc(db, 'artifacts', appId, 'users', reviewApp.uid)); if (u.exists()) { pickUser({ ...u.data(), id: u.id }); setReviewApp(null); setAdminTab('config'); try { window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' }); } catch (e) {} } }} color="cyan" className="w-full text-[10px] py-2">⚙️ Open in User Manager (commission, tiers, RevShare %, badges, bans)</Button>
                            <p className="text-[8px] opacity-50">The User Manager has full control: set commission rate, RevShare % / tier, force badges, edit stats, and ban — all for this applicant.</p>
                        </div>
                    </div>
                </Modal>
            )}
            </>)}

            {adminTab === 'tickets' && (<>
            <div className="flex gap-2 mb-3">
                {['open', 'resolved', 'all'].map(f => <button key={f} onClick={() => setTicketFilter(f)} className={`px-3 py-1 rounded-full text-[9px] font-black uppercase ${ticketFilter===f ? 'bg-yellow-500 text-black' : 'bg-white/5 text-white/50'}`}>{f}</button>)}
            </div>
            <div className="space-y-2 max-h-[55vh] overflow-y-auto pr-1">
                {visibleTickets.length === 0 && <p className="text-center opacity-50 text-xs py-4">No {ticketFilter} tickets.</p>}
                {visibleTickets.map(t => (
                    <div key={t.id} className={`bg-white/5 p-3 rounded border ${(t.status||'open')==='open' ? 'border-yellow-500/40' : 'border-white/10 opacity-60'}`}>
                        <div className="flex justify-between items-start mb-1">
                            <span className="text-[8px] font-black uppercase bg-purple-500/30 text-purple-300 px-1 rounded">{t.category}</span>
                            <span className="text-[8px] opacity-50">{new Date(t.createdAt).toLocaleString()}</span>
                        </div>
                        <p className="font-bold text-xs text-white">{t.subject}</p>
                        <p className="text-[10px] text-gray-100 mt-1 whitespace-pre-wrap break-words">{t.message}</p>
                        <div className="flex justify-between items-center mt-2 pt-2 border-t border-white/10 gap-1">
                            <span className="text-[8px] opacity-60 truncate">@{t.username}</span>
                            <div className="flex gap-1 shrink-0">
                                {t.uid && t.uid !== 'guest' && <Button onClick={async () => { const txt = prompt('Reply to @' + t.username + ' about "' + t.subject + '":'); if (!txt) return; try { await sendDirectMessage(user.uid, profile?.displayName || 'RaveKandi Admin', t.uid, t.username, '🎫 RE: ' + t.subject + '\n' + txt); pushNotif(t.uid, 'ticket', '🎫 Admin replied to your ticket "' + t.subject + '" — check your messages!', t.id); alert('Reply sent via DM.'); } catch (e) { alert(e.message); } }} color="purple" className="text-[8px] py-1 px-2">Reply via DM</Button>}
                                {(t.status||'open') === 'open'
                                    ? <Button onClick={() => setTicketStatus(t, 'resolved')} color="lime" className="text-[8px] py-1 px-2">Resolved</Button>
                                    : <Button onClick={() => setTicketStatus(t, 'open')} color="accent" className="text-[8px] py-1 px-2">Reopen</Button>}
                            </div>
                        </div>
                    </div>
                ))}
            </div>
            </>)}
        </Card>
    );
};

const HubHelpModal = ({ isOpen, onClose }) => {
    if (!isOpen) return null;
    const sections = [
        { t: '📦 What is the Inventory Hub?', d: "It's your private stock manager as a Creator. Log every material and finished item you have on hand — beads, fabrics, charms, clothing, plushies, trinkets, and more. Nothing here is auto-listed for sale; it's your behind-the-scenes catalog." },
        { t: '🎨 Powers the DIY Builder', d: "Items you stock here become selectable parts in the DIY builder, so when a customer designs a custom piece they can pick from what you actually have. Keeping your hub current means more accurate custom requests and fewer 'out of stock' surprises." },
        { t: '🏷️ Adding an item', d: "Pick a Type (e.g. Fabric, Bead, Clothing), then a Sub-Type (e.g. Spandex, Pony, Bucket Hat), a Size, and enter Quantity, your Cost (what you paid), and Sell price. Add a photo or link and a description. Tap 'Add to Stock'." },
        { t: '💰 Cost vs. profit assessment', d: "As you type Cost and Sell, the hub shows your Estimated Unit Profit — that's your sell price minus your cost minus the platform commission. Use it to price items so you actually make money and stay ahead of your expenses." },
        { t: '📐 Types & sub-types', d: "Types include Beads, String/Cord, Charms, Fabric (with breakdowns like cotton, spandex, mesh, velvet, sequin, holographic, faux fur…), Clothing, Hats/Headwear, Accessories, Plushies/Toys, Trinkets, and Supplies. Pick the closest match, or use Other → Custom." },
        { t: '🔢 Managing quantity', d: "Set the quantity you have. As you build pieces and use materials, update the hub so your stock and DIY availability stay accurate." },
        { t: '🧮 Why track cost?', d: "Logging what you paid per item lets the hub compute real margins. Over time this helps you see which items are profitable, which to reorder, and how to price custom work fairly." },
    ];
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="📦 Inventory Hub — Help">
            <div className="space-y-2 max-h-[65vh] overflow-y-auto pr-1">
                {sections.map((s, i) => (
                    <div key={i} className="bg-white/5 border border-white/10 rounded-lg p-3">
                        <p className="font-bold text-sm text-cyan-300 mb-1">{s.t}</p>
                        <p className="text-[11px] text-gray-100 leading-relaxed">{s.d}</p>
                    </div>
                ))}
            </div>
        </Modal>
    );
};

const InventoryManager = ({ user, profile }) => {
    const [target, setTarget] = useState('user');
    const [targetUid, setTargetUid] = useState(user?.uid || '');
    const [hubHelp, setHubHelp] = useState(false);
    const [newItem, setNewItem] = useState({ type: 'Bead', subType: 'Pony', size: 'M', cost: '', sell: '', quantity: '', description: '', image: null, imageUrl: '' });
    
    const handleAdd = async () => {
        if (!newItem.cost || !newItem.sell || !newItem.quantity || !user?.uid) return alert("Financials required.");
        let img = newItem.imageUrl;
        if (newItem.image) { img = await compressImage(newItem.image); }
        const payload = { ...newItem, image: img, timestamp: Date.now(), isCraftingStock: true, ownerId: user.uid, ownerName: profile?.displayName };
        const dest = target === 'diy' ? collection(db, 'artifacts', appId, 'public', 'data', 'inventory') : collection(db, 'artifacts', appId, 'users', targetUid, 'inventory');
        await addDoc(dest, payload);
        alert("Inventory Saved!");
        setNewItem({ type: 'Bead', subType: 'Pony', size: 'M', cost: '', sell: '', quantity: '', description: '', image: null, imageUrl: '' });
    };
    
    const profit = (parseFloat(newItem.sell || 0) - parseFloat(newItem.cost || 0) - (parseFloat(newItem.sell || 0) * effCommissionRate(null))).toFixed(2);
    
    return ( 
        <Card className="mt-8 border-cyan-500/40">
            <h3 className="font-bold text-cyan-400 mb-2 flex justify-between items-center">Inventory Hub <button onClick={() => setHubHelp(true)} className="text-cyan-400 hover:text-cyan-200 flex items-center gap-1" title="How the Inventory Hub works"><HelpCircle size={18}/><span className="text-[10px] font-bold">HELP</span></button></h3>
            <div className="bg-cyan-900/20 border border-cyan-500/30 rounded-lg p-3 mb-4">
                <p className="text-[11px] text-cyan-100 leading-relaxed">📦 <strong>The Inventory Hub is for Creators.</strong> Add the materials & items you stock here so they appear in the <strong>DIY builder</strong> for customers to choose from, to <strong>manage your stock</strong>, and to <strong>assess cost vs. profit</strong> — the hub calculates your margin per item (after commission) so you can price smart and stay ahead.</p>
            </div>
            <HubHelpModal isOpen={hubHelp} onClose={() => setHubHelp(false)} />
            {profile.isAdmin && <div className="grid grid-cols-2 gap-2 mb-4"><select value={target} onChange={e=>setTarget(e.target.value)} className="bg-black border border-white/20 text-xs p-2 rounded"><option value="diy">DIY Stock</option><option value="user">User Stock</option></select><input value={targetUid} onChange={e=>setTargetUid(e.target.value)} placeholder="Target UID" className="bg-black border border-white/20 text-xs p-2 rounded"/></div>}
            <div className="grid grid-cols-3 gap-2"><Input label="Type" type="select" options={Object.keys(ITEM_CATEGORIES)} value={newItem.type} onChange={v => setNewItem({...newItem, type: v, subType: ITEM_CATEGORIES[v][0]})}/><Input label="Sub-Type" type="select" options={ITEM_CATEGORIES[newItem.type]||['Custom']} value={newItem.subType} onChange={v => setNewItem({...newItem, subType: v})}/><Input label="Size" type="select" options={ITEM_SIZES} value={newItem.size} onChange={v => setNewItem({...newItem, size: v})}/></div>
            <div className="grid grid-cols-3 gap-2"><Input label="Qty" type="number" value={newItem.quantity} onChange={v => setNewItem({...newItem, quantity: v})}/><Input label="Cost" type="number" value={newItem.cost} onChange={v => setNewItem({...newItem, cost: v})}/><Input label="Sell" type="number" value={newItem.sell} onChange={v => setNewItem({...newItem, sell: v})}/></div>
            <div className="grid grid-cols-2 gap-2"><Input label="Link" value={newItem.imageUrl} onChange={v => setNewItem({...newItem, imageUrl: v})} placeholder="URL"/><div className="flex flex-col"><label className="text-xs font-bold mb-1">Upload</label><input type="file" onChange={e=>setNewItem({...newItem, image: e.target.files[0]})} className="text-[10px]"/></div></div>
            <Input label="Description" type="textarea" value={newItem.description} onChange={v => setNewItem({...newItem, description: v})}/>
            
            <div className="flex justify-between items-center border-t border-white/10 pt-4"><p className="text-xs">Est. Unit Profit: <span className="text-lime-400 font-bold">${profit}</span></p><Button onClick={handleAdd} color="lime">Add to Stock</Button></div>
        </Card> 
    );
};
const CreatorProjectHub = ({ user, onClose }) => {
    const [hubTab, setHubTab] = useState('awaiting_assignment');
    const [requests, setRequests] = useState([]);
    const [legacyPending, setLegacyPending] = useState([]);

    const TABS = [
        { id: 'pending', label: 'Pending' },
        { id: 'awaiting_assignment', label: 'Awaiting Creator' },
        { id: 'active', label: 'Active' },
        { id: 'completed', label: 'Completed' },
        { id: 'denied', label: 'Denied' },
    ];

    useEffect(() => {
        const q = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('requestStatus', '==', hubTab));
        const unsub = onSnapshot(q, s => setRequests(s.docs.map(d => ({...d.data(), id: d.id}))));
        return () => unsub();
    }, [hubTab]);

    // Legacy support: pre-V37.10 submissions used status:'pending' with no requestStatus field
    useEffect(() => {
        const q = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('status', '==', 'pending'));
        const unsub = onSnapshot(q, s => setLegacyPending(s.docs.map(d => ({...d.data(), id: d.id})).filter(d => !d.requestStatus)));
        return () => unsub();
    }, []);

    // V37.12: release expired priority windows when viewing the pending queue
    useEffect(() => {
        if (hubTab !== 'pending') return;
        requests.filter(r => r.requestStatus === 'pending' && r.idleExpiresAt && Date.now() > r.idleExpiresAt)
            .forEach(r => updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', r.id), { requestStatus: 'awaiting_assignment', autoReleasedAt: Date.now() }).catch(()=>{}));
    }, [requests, hubTab]);

    const list = hubTab === 'pending' ? [...requests, ...legacyPending.filter(l => !requests.some(r => r.id === l.id))] : requests;

    const setStage = async (item, requestStatus, extra = {}) => {
        await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { requestStatus, ...extra });
    };
    const handleAccept = async (item) => { if(!window.confirm("Accept this request and assign it to yourself?")) return; await setStage(item, 'active', { assigneeId: user.uid, assigneeName: user.displayName || 'Creator', status: item.isRequest ? 'request' : (item.status === 'pending' ? 'approved' : (item.status || 'approved')), acceptedAt: Date.now() }); pushNotif(item.ownerId, 'diy', '🛠️ Your request "' + item.name + '" was accepted and is now ACTIVE!', item.id); };
    const handleComplete = async (item) => { if(!window.confirm("Mark this request as completed?")) return; await setStage(item, 'completed', { completedAt: Date.now() }); pushNotif(item.ownerId, 'diy', '✅ Your request "' + item.name + '" is COMPLETED!', item.id); };
    const handleDeny = async (item) => { const r = prompt("Reason for denial:"); if(!r) return; await setStage(item, 'denied', { dismissReason: r, deniedAt: Date.now() }); pushNotif(item.ownerId, 'diy', '❌ Your request "' + item.name + '" was denied: ' + r, item.id); };

    return (
        <div className="fixed inset-0 bg-black z-50 overflow-y-auto p-4">
            <div className="flex justify-between items-center mb-4">
                <h2 className="text-2xl font-black italic text-lime-400 uppercase tracking-widest">Creator Hub</h2>
                <button onClick={onClose}><XCircle size={32}/></button>
            </div>
            <div className="flex gap-1 mb-6 overflow-x-auto pb-2">
                {TABS.map(t => (
                    <button key={t.id} onClick={() => setHubTab(t.id)} className={`px-3 py-2 rounded-full font-black uppercase text-[9px] tracking-widest whitespace-nowrap ${hubTab===t.id ? 'bg-lime-500 text-black' : 'bg-white/5 text-white/50'}`}>{t.label}</button>
                ))}
            </div>
            {hubTab === 'pending' && <p className="text-[9px] text-yellow-300 bg-yellow-900/20 border border-yellow-500/30 rounded p-2 mb-4">⚖ Fairness window: requested Creators get 24–72h (scaled by price & complexity) to accept. Expired requests auto-release to the Awaiting Creator queue for all Creators.</p>}
            <div className="grid gap-4">
                {list.length === 0 ? <p className="opacity-50 italic uppercase text-xs">No {TABS.find(t=>t.id===hubTab)?.label} requests</p> : list.map(req => (
                    <Card key={req.id} className="border-lime-500/30">
                        <div className="flex justify-between items-start">
                            <div>
                                <h3 className="font-bold text-lg">{req.name}</h3>
                                <p className="text-xs opacity-70">Client: {req.ownerName || 'Unknown'}</p>
                                <div className="flex gap-1 mt-1 flex-wrap">
                                    {req.isAICreation && <span className="bg-purple-500/20 text-purple-400 text-[8px] px-1 rounded">AI Generated</span>}
                                    {req.isDIYRequest && <span className="bg-cyan-500/20 text-cyan-400 text-[8px] px-1 rounded">DIY Build</span>}
                                    {req.assignedCreatorName && <span className="bg-pink-500/20 text-pink-400 text-[8px] px-1 rounded">Requested: {req.assignedCreatorName}</span>}
                                    {req.requestStatus === 'pending' && req.idleExpiresAt && <span className="bg-yellow-500/20 text-yellow-300 text-[8px] px-1 rounded">{req.idleExpiresAt > Date.now() ? '⏳ Opens to all in ' + Math.max(1, Math.ceil((req.idleExpiresAt - Date.now()) / 3600000)) + 'h' : '⏳ Releasing to all...'}</span>}
                                    {req.assigneeName && <span className="bg-lime-500/20 text-lime-400 text-[8px] px-1 rounded">Assigned: {req.assigneeName}</span>}
                                </div>
                            </div>
                            <span className="text-lime-400 font-bold">${req.price?.toFixed(2)}</span>
                        </div>
                        <div className="bg-white/5 p-2 rounded mt-2 text-xs"><p className="font-bold mb-1">Vision:</p><p>{req.description || req.visual_description || 'No description provided.'}</p></div>
                        {req.dismissReason && <p className="text-[10px] text-red-400 mt-2">Denial reason: {req.dismissReason}</p>}
                        <div className="mt-4 flex gap-2">
                            {(hubTab === 'pending' || hubTab === 'awaiting_assignment') && (<>
                                <Button onClick={()=>handleAccept(req)} color="lime" className="flex-1 text-xs uppercase font-black italic">Accept</Button>
                                <Button onClick={()=>handleDeny(req)} color="accent" className="flex-1 text-xs uppercase font-black italic">Deny</Button>
                            </>)}
                            {hubTab === 'active' && (<>
                                <Button onClick={()=>handleComplete(req)} color="cyan" className="flex-1 text-xs uppercase font-black italic">Mark Completed</Button>
                                <Button onClick={()=>handleDeny(req)} color="accent" className="flex-1 text-xs uppercase font-black italic">Deny</Button>
                            </>)}
                            {(hubTab === 'completed' || hubTab === 'denied') && <p className="text-[9px] opacity-40 uppercase">Archived</p>}
                        </div>
                    </Card>
                ))}
            </div>
        </div>
    );
};
const UserStatsDashboard = ({ profile, isOpen, onClose }) => {
    if (!isOpen) return null;
    const refStats = getReferralTier(profile.referrals || 0);
    const activeCommRate = effCommissionRate(profile.customCommissionRate, profile.lockedCommissionRate);
    
    const totalRevenue = profile.totalSalesValue || 0;
    const totalFees = totalRevenue * activeCommRate;
    const netProfit = totalRevenue - totalFees;
    const totalRevShare = profile.totalRevShareEarned || 0;

    return (
        <Modal isOpen={isOpen} onClose={onClose} title="Analytics Dashboard">
            <div className="space-y-4 max-h-[60vh] overflow-y-auto pr-1">
                <div className="bg-black/50 p-4 rounded border border-lime-500/30 shadow-[0_0_15px_rgba(163,230,53,0.1)]">
                    <h4 className="text-[10px] uppercase font-bold text-lime-400 mb-4 flex items-center gap-2"><BarChart3 size={14}/> Lifetime Financials</h4>
                    <div className="grid grid-cols-2 gap-4 text-center">
                        <div className="bg-white/5 p-3 rounded">
                            <p className="text-xs opacity-70 mb-1">Gross Revenue</p>
                            <p className="text-xl font-black text-white">${totalRevenue.toFixed(2)}</p>
                        </div>
                        <div className="bg-white/5 p-3 rounded">
                            <p className="text-xs opacity-70 mb-1">Net Profit</p>
                            <p className="text-xl font-black text-lime-400">${netProfit.toFixed(2)}</p>
                        </div>
                    </div>
                </div>

                <div className="grid grid-cols-2 gap-3">
                    <div className="bg-white/5 p-3 rounded border border-white/10">
                        <p className="text-[10px] opacity-70 uppercase mb-1">Active Comm. Fee</p>
                        <p className="text-lg font-bold text-red-400">{(activeCommRate * 100).toFixed(1)}%</p>
                        <p className="text-[8px] opacity-50 mt-1">Total Paid: ${totalFees.toFixed(2)}</p>
                    </div>
                    <div className="bg-white/5 p-3 rounded border border-white/10">
                        <p className="text-[10px] opacity-70 uppercase mb-1">RevShare Earned</p>
                        <p className="text-lg font-bold text-cyan-400">${totalRevShare.toFixed(2)}</p>
                        <p className="text-[8px] opacity-50 mt-1">Current Tier: {refStats.sharePct}%</p>
                    </div>
                </div>

                <div className="bg-black/50 p-4 rounded border border-pink-500/30">
                    <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-3 flex items-center gap-2"><TrendingUp size={14}/> Sales Performance</h4>
                    <div className="grid grid-cols-3 gap-2 text-center text-[10px]">
                        <div className="bg-white/5 p-2 rounded"><span className="block opacity-70 mb-1">Items Sold</span><span className="font-bold">{profile.itemsSold || 0}</span></div>
                        <div className="bg-white/5 p-2 rounded"><span className="block opacity-70 mb-1">Orders</span><span className="font-bold">{profile.completedTrades || 0}</span></div>
                        <div className="bg-white/5 p-2 rounded"><span className="block opacity-70 mb-1">Recruits</span><span className="font-bold">{profile.referrals || 0}</span></div>
                        <div className="bg-white/5 p-2 rounded"><span className="block opacity-70 mb-1">Active Hrs</span><span className="font-bold text-lime-400">{(((profile.activeMinutes || 0) / 60) + (profile.activeHours || 0)).toFixed(1)}</span></div>
                        <div className="bg-white/5 p-2 rounded"><span className="block opacity-70 mb-1">App Opens</span><span className="font-bold">{profile.activeOpens || 0}</span></div>
                    </div>
                </div>
            </div>
        </Modal>
    );
};

const HELP_TOPICS = [
    { cat: 'Getting Started', title: '🌈 What is RaveKandi?', content: "RaveKandi is a marketplace and community for ravers to buy, sell, and trade kandi (beaded bracelets, cuffs, perler art), festival fashion, and handmade gear. Create a profile, list items, follow creators, chat, listen to rave radio, and earn rewards for spreading the PLUR." },
    { cat: 'Getting Started', title: '📲 Installing the App', content: "RaveKandi runs in your browser at ravekandi.web.app. For an app-like experience, tap the install prompt (or your browser menu → Add to Home Screen). Installed, it launches fullscreen with its own icon. Updates are automatic — just reopen it." },
    { cat: 'Getting Started', title: '🆔 Your Friend UID', content: "Every account gets a unique Friend UID. Others use it to find your profile, and it's your referral code. Tap your UID anywhere to copy it. Share it (or your invite link) so friends can find you and you both earn RevShare." },
    { cat: 'Buying', title: '🛒 How to Buy', content: "Tap any item to view details, then Add to Cart. In your cart, choose a quantity (up to the seller's stock) — bulk discounts apply automatically if the seller set them. Check out with card (Stripe) or crypto (Solana). After buying, you can leave a review on the item." },
    { cat: 'Buying', title: '💳 Bulk Discounts', content: "Sellers can set tiered bulk pricing (e.g. buy 5+ for 10% off, 10+ for 20% off). When you raise the quantity in your cart past a tier, the discount applies automatically and the new price shows on the item." },
    { cat: 'Buying', title: '📦 Tracking & Delivery', content: "For physical items, sellers must add a tracking number, which is permanently locked once entered and visible only to you and the seller. Check your Collection to follow an order: Pending → Active → Completed." },
    { cat: 'Selling', title: '🏷️ Posting an Item', content: "On the Feed, tap Post Your Kandi. Add up to 3 images, a name, price, item type, and stock quantity. Optionally set bulk discount tiers and mark it as part of a series. Note: post images here — to feature a video, use the homepage Festival Spotlight." },
    { cat: 'Selling', title: '💸 Commission & Payouts', content: "RaveKandi takes a back-end commission (up to 20%, often less, and 10% during launch perks) to cover payment fees, servers, and RevShare. You keep the rest. Sellers manage payouts through their secure Stripe Connect portal." },
    { cat: 'Selling', title: '👑 Becoming a Creator', content: "Apply to become a verified Creator from your profile. Creators get an Official badge, can take DIY commission requests, post official drops, and pin featured items to their profile. Top creators climb the leaderboard." },
    { cat: 'Creating (DIY)', title: '🎨 DIY Custom Requests', content: "In the DIY Builder, either pick an individual Creator OR open your request to ALL Creators. Add parts from their stock or describe your vision and set a budget. A requested Creator gets a 24–72h priority window (scaled by price & complexity); if they don't accept, it opens to everyone." },
    { cat: 'Community', title: '💬 Messaging', content: "Tap the Inbox to DM any raver. Messages are private between you and the recipient. You can change your message font in the messenger's own font tool (VIP)." },
    { cat: 'Community', title: '❤️ Likes, Comments & Profiles', content: "Like and comment on posts to spread vibes. Tap any user to view their full profile — stats, achievements, collection, and socials. Your own profile stats (items sold, bought, likes, etc.) are tappable to see the actual items behind each number." },
    { cat: 'Community', title: '🏅 Achievements & Badges', content: "Earn achievements for selling, buying, referring, listening to radio, posting, and more. Choose your favorite 5 to feature on your profile, and pick one as your displayed badge. Tap your achievements box to see them all." },
    { cat: 'Community', title: '🎬 Festival Spotlight', content: "Share a festival clip (YouTube/TikTok/Instagram/Facebook link) on the homepage Spotlight. Your clip plays in a rotating 30-minute window with your profile button beside it — great for advertising yourself, your products, streams, or socials. Up to 4 clips/day." },
    { cat: 'Rewards', title: '🤝 RevShare (Referrals)', content: "Refer friends with your Friend UID or invite link. You earn 2%–25% of RaveKandi's commission on every purchase your referrals make, forever. The more you refer, the higher your tier (up to 25%). Put your invite link in your IG/Telegram bio — it auto-applies your code when someone signs up." },
    { cat: 'Rewards', title: '🔗 Invite Links', content: "From the RevShare panel, copy your invite link. Anyone who opens it gets your referral auto-applied at signup. Share it anywhere — DMs, stories, or your bio." },
    { cat: 'VIP', title: '⭐ VIP Perks', content: "VIP unlocks 6 profile pins (the free tier includes 3), custom profile backgrounds (Theme Selector), banner messages, post boosts, and the Font Selector for stylized text in your bio, posts, comments, and messages. In Rave Radio chat, VIP also removes the message cooldown, lets you share your social links (limited per day), and lets you share collection items in chat. During launch perks, VIP is free for everyone." },
    { cat: 'Radio', title: '📻 Rave Radio (Free!)', content: "Rave Radio is free for everyone — stream live electronic stations across every genre — house, techno, trance, dnb, dubstep, hardstyle, psytrance and more — with a built-in equalizer. A separate YouTube tab links full DJ sets and livestreams. Drag the radio button anywhere on your screen." },
    { cat: 'Payments', title: '🛡️ Checkout Options', content: "Pay by card through Stripe's encrypted portal, or with Solana crypto (Phantom, Coinbase, MetaMask) for near-zero fees. Your payment details are never stored by RaveKandi." },
    { cat: 'Safety', title: '🚩 Reporting & Support', content: "Use the Bugs/Feedback button to report issues. Admins can take down inappropriate content and moderate the community. For account help, submit a support ticket — replies arrive in your notifications." },
];

const HelpModal = ({ isOpen, onClose }) => {
    const [q, setQ] = useState('');
    const [openIdx, setOpenIdx] = useState(null);
    if (!isOpen) return null;
    const term = q.trim().toLowerCase();
    const filtered = HELP_TOPICS.map((t, i) => ({ ...t, i })).filter(t => !term || t.title.toLowerCase().includes(term) || t.content.toLowerCase().includes(term) || t.cat.toLowerCase().includes(term));
    const cats = [...new Set(filtered.map(t => t.cat))];
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="❓ Help & How It Works">
            <div className="space-y-3">
                <input value={q} onChange={e => setQ(e.target.value)} placeholder="Search help (e.g. 'bulk', 'refer', 'tracking')…" autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck={false} data-lpignore="true" data-form-type="other" className="w-full p-2 rounded bg-white/10 border-2 border-white/30 text-sm"/>
                <div className="max-h-[60vh] overflow-y-auto pr-1 space-y-4">
                    {cats.length === 0 && <p className="text-center opacity-50 text-xs py-6">No help topics match "{q}".</p>}
                    {cats.map(cat => (
                        <div key={cat}>
                            <p className="text-[10px] font-black uppercase tracking-widest text-cyan-400 mb-1">{cat}</p>
                            <div className="space-y-1.5">
                                {filtered.filter(t => t.cat === cat).map(t => (
                                    <div key={t.i} className="bg-white/5 border border-white/10 rounded-lg overflow-hidden">
                                        <button onClick={() => setOpenIdx(openIdx === t.i ? null : t.i)} className="w-full p-3 text-left font-bold text-xs text-white flex justify-between items-center gap-2 hover:bg-white/10">
                                            <span>{t.title}</span>
                                            {openIdx === t.i ? <ChevronUp size={14} className="shrink-0"/> : <ChevronDown size={14} className="shrink-0"/>}
                                        </button>
                                        {openIdx === t.i && <div className="p-3 pt-2 text-[11px] text-gray-100 leading-relaxed bg-black/40 border-t border-white/10">{t.content}</div>}
                                    </div>
                                ))}
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </Modal>
    );
};

const InfoSection = () => {
    const [openIdx, setOpenIdx] = useState(null);
    const infos = HELP_TOPICS.slice(0, 6);
    return (
        <div className="mt-8 text-left max-w-md mx-auto">
            <h3 className="text-xl font-black italic text-pink-400 mb-4 tracking-wider">How RaveKandi Works</h3>
            <div className="space-y-2">
                {infos.map((info, i) => (
                    <div key={i} className="bg-white/5 border border-white/10 rounded-lg overflow-hidden transition-all">
                        <button onClick={() => setOpenIdx(openIdx === i ? null : i)} className="w-full p-4 text-left font-bold text-sm text-white flex justify-between items-center hover:bg-white/10">
                            {info.title}
                            {openIdx === i ? <ChevronUp size={16}/> : <ChevronDown size={16}/>}
                        </button>
                        {openIdx === i && <div className="p-4 pt-3 text-sm text-gray-100 leading-relaxed bg-black/40 border-t border-white/10">{info.content}</div>}
                    </div>
                ))}
            </div>
        </div>
    );
};

export const CreatorPerksSection = ({ onApply }) => (
    <div className="mt-8 text-left max-w-md mx-auto">
        <h2 className="text-3xl font-black text-center mb-6 italic tracking-widest text-transparent bg-clip-text bg-gradient-to-r from-lime-400 to-cyan-400 drop-shadow-[0_0_10px_rgba(163,230,53,0.5)]">Become a KandiCreator!</h2>
        <div className="bg-black/40 border border-pink-500/30 rounded-xl p-5 mb-6 relative overflow-hidden">
            <div className="absolute -top-4 -right-4 p-4 opacity-5"><Wand2 size={120}/></div>
            <h3 className="text-2xl font-black italic text-pink-400 mb-4 tracking-wider shadow-black drop-shadow-md">Creator Perks</h3>
            <ul className="text-xs space-y-3 mb-6 relative z-10 opacity-90 font-bold text-gray-200">
                <li className="flex gap-3 items-center"><Check size={16} className="text-lime-400 shrink-0"/> Take on custom DIY commissions directly.</li>
                <li className="flex gap-3 items-center"><Check size={16} className="text-lime-400 shrink-0"/> Pre-release info on app drops & updates.</li>
                <li className="flex gap-3 items-center"><Check size={16} className="text-lime-400 shrink-0"/> Boosted visibility on the main exchange.</li>
                <li className="flex gap-3 items-center"><Check size={16} className="text-lime-400 shrink-0"/> Exclusive Verified Creator profile badge.</li>
                <li className="flex gap-3 items-center"><Check size={16} className="text-lime-400 shrink-0"/> Advanced multi-item inventory management.</li>
            </ul>
            <div className="bg-gradient-to-r from-lime-500/20 to-cyan-500/10 border-l-4 border-lime-400 p-4 rounded relative z-10 shadow-[0_0_15px_rgba(163,230,53,0.2)]">
                <p className="text-xl font-black text-white italic tracking-wide uppercase drop-shadow-[0_0_5px_rgba(255,255,255,0.5)]">Keep up to 100% of Sales!</p>
                <p className="text-[11px] text-lime-200 font-bold mt-2 leading-relaxed">We pre-calculate materials and scaling costs so your profit margins stay protected. We can take up to 20% commission (typically starting at 20% and going as low as zero). Build your empire.</p>
            </div>
        </div>
        <Button onClick={onApply} color="primary" className="w-full mb-8 py-4 text-lg">Apply to be a KandiCreator</Button>
    </div>
);

export const ReferralProgramSection = ({ onNavigateToProfile }) => (
    <div className="mt-8 text-left max-w-md mx-auto mb-10">
        <h2 className="text-2xl font-black mb-4 italic tracking-tighter text-cyan-400">The PLUR RevShare Program</h2>
        <Card glow="accentGlow" className="p-5">
            <p className="text-sm text-gray-100 mb-4">Invite your rave fam and earn passive income forever! When someone signs up using your Friend UID, you earn a percentage of the app's commission on EVERY purchase they make — climbing all the way to <strong className="text-lime-300">25% of the commission</strong> at the top tier.</p>
            <div className="bg-black/50 p-3 rounded mb-4 max-h-52 overflow-y-auto border border-white/10">
                <table className="w-full text-xs">
                    <thead><tr className="text-left text-lime-400 border-b border-white/20"><th className="pb-1">Tier</th><th className="pb-1">Refs</th><th className="pb-1">RevShare</th></tr></thead>
                    <tbody>
                        {REFERRAL_TIERS.map(t => (
                            <tr key={t.badge} className="border-b border-white/5"><td className={`py-1 font-bold ${t.color}`}>{t.badge}</td><td className="py-1">{t.min}-{t.max}</td><td className="py-1 text-lime-300">{t.sharePct}%</td></tr>
                        ))}
                    </tbody>
                </table>
            </div>
            <div className="bg-cyan-900/20 p-3 rounded text-xs border border-cyan-500/30 mb-4">
                <span className="font-bold text-cyan-400 block mb-1">Quick Guide: How to find your Referral Portal</span>
                <ol className="list-decimal pl-4 space-y-1 text-gray-100">
                    <li>Go to the <User size={10} className="inline"/> <strong>Profile Tab</strong>.</li>
                    <li>Scroll to your Stats grid.</li>
                    <li>Tap the <strong>Referrals</strong> box to open your dashboard!</li>
                </ol>
            </div>
            <Button onClick={onNavigateToProfile} color="lime" className="w-full">Open Referral Portal</Button>
        </Card>
    </div>
);
EOF

# Block 16
cat << 'EOF' >> src/App.js
const PinSelectModal = ({ user, profile, isOpen, onClose }) => {
    const [inv, setInv] = useState([]);
    useEffect(() => {
        if(!isOpen || !user?.uid) return;
        getDocs(query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'))).then(s => setInv(s.docs.map(d=>({...d.data(), id: d.id}))));
    }, [isOpen, user]);
    const pinnedCount = inv.filter(i => i.isPinned).length;
    const vip = isEffVIP(profile);
    const maxPins = vip ? 6 : 3;
    const togglePin = async (item) => {
        if (!item.isPinned && pinnedCount >= maxPins) {
            if (!vip) { alert("Free tier lets you pin 3 items. Upgrade to VIP to pin up to 6!"); }
            else { alert("You can pin up to 6 items. Unpin one first."); }
            return;
        }
        await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', item.id), { isPinned: !item.isPinned });
        onClose();
    };
    if(!isOpen) return null;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="Select Items to Pin">
            <p className="text-[10px] opacity-60 mb-2 text-center">{pinnedCount}/{maxPins} pinned{!vip ? ' (free tier — VIP unlocks 6)' : ''}. Tap an item to pin or unpin it.</p>
            <div className="grid grid-cols-2 gap-2 max-h-60 overflow-y-auto p-1">
                {inv.length === 0 && <p className="col-span-2 text-center opacity-50 py-6 text-xs">No items yet — post or stock an item first, then pin it here.</p>}
                {inv.map(i => (
                    <div key={i.id} onClick={() => togglePin(i)} className={`border p-2 rounded cursor-pointer relative ${i.isPinned ? 'border-pink-500 bg-pink-500/20' : 'border-white/20 hover:bg-white/10'}`}>
                        {i.isPinned && <span className="absolute top-1 right-1 bg-pink-600 text-white text-[7px] font-black rounded-full px-1.5 py-0.5">★ PINNED</span>}
                        <img src={i.mediaUrls?.[0]?.url || i.imageUrl || i.image || 'https://placehold.co/100'} className="w-full h-16 object-cover rounded mb-1"/>
                        <p className="text-[8px] truncate">{i.name}</p>
                    </div>
                ))}
            </div>
        </Modal>
    );
};

const PublicProfilePage = ({ uid, viewerUid, viewerProfile, onClose, onMessage, onViewFeedItem }) => {
    const [targ, setTarg] = useState(null);
    const [errMsg, setErrMsg] = useState('');
    const [pinnedItems, setPinnedItems] = useState([]);
    const [showAnalytics, setShowAnalytics] = useState(false);
    const [showCollection, setShowCollection] = useState(false);
    const [selectedPinned, setSelectedPinned] = useState(null);
    const [statDetail, setStatDetail] = useState(null); // V42.23.02 FIX: was referenced but never declared → crash on opening a profile

    useEffect(() => {
        setTarg(null); setErrMsg('');
        if (!uid) return;
        let cancelled = false;
        (async () => {
            try {
                const direct = await getDoc(doc(db, 'artifacts', appId, 'users', uid));
                if (cancelled) return;
                if (direct.exists()) { setTarg({ ...direct.data(), id: direct.id }); return; }
            } catch (e) { console.log('public profile direct load failed', e); }
            try {
                const snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', uid)));
                if (cancelled) return;
                if (!snap.empty) { setTarg({ ...snap.docs[0].data(), id: snap.docs[0].id }); return; }
                setTarg('not_found');
            } catch (e) {
                if (cancelled) return;
                console.log('public profile query failed', e);
                setErrMsg((e && e.message) || 'Unknown error'); setTarg('error');
            }
        })();
        return () => { cancelled = true; };
    }, [uid]);

    // featured pins of the target (creators only)
    useEffect(() => {
        const tid = (targ && targ !== 'not_found' && targ !== 'error') ? targ.id : null;
        if (!tid) { setPinnedItems([]); return; }
        const q = query(collection(db, 'artifacts', appId, 'users', tid, 'inventory'), where('isPinned', '==', true));
        const unsub = onSnapshot(q, s => setPinnedItems(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log(e));
        return () => unsub();
    }, [targ]);

    if (!uid) return null;

    const isSelf = targ && targ !== 'not_found' && targ !== 'error' && (targ.id === viewerUid);
    const refStats = (targ && targ.referrals) ? getReferralTier(targ.referrals || 0) : null;

    return (
        <div className="fixed inset-0 bg-[#0a0014] z-[90] overflow-y-auto">
            <div className="sticky top-0 z-10 bg-black/80 backdrop-blur border-b border-white/10 px-4 py-3 flex items-center justify-between">
                <h2 className="text-lg font-black italic uppercase tracking-widest" style={getTextGlowStyle('primaryGlow')}>
                    {targ === 'not_found' ? 'Not Found' : targ === 'error' ? 'Connection Issue' : (targ?.displayName ? '@' + targ.displayName : 'Loading…')}
                </h2>
                <button onClick={onClose} className="text-white hover:text-pink-400"><XCircle size={30}/></button>
            </div>

            {targ === 'not_found' ? <p className="opacity-50 text-center py-20">This raver no longer exists.</p>
            : targ === 'error' ? <p className="text-red-300 text-sm text-center py-20">Couldn't load this profile.{errMsg ? ' (' + errMsg + ')' : ''} Check your connection and try again.</p>
            : !targ ? <div className="py-20 px-10"><LoadingBar progress={50} className="w-full"/><p className="text-center text-[10px] opacity-50 mt-3 animate-pulse uppercase tracking-widest">Loading profile…</p></div>
            : (
                <div className="max-w-4xl mx-auto px-4 pb-20 pt-6 space-y-6">
                    <UserStatsDashboard profile={targ} isOpen={showAnalytics} onClose={() => setShowAnalytics(false)} />
                    <CollectionPopout user={{ uid: targ.id }} type="posts" isOpen={showCollection} onClose={() => setShowCollection(false)} onViewFeed={onClose} readOnly={true} hideDIY={!!targ.hideDIYFromOthers} />
                    <StatDetailModal statKey={statDetail} uid={targ.id} profile={targ} isOpen={!!statDetail} onClose={() => setStatDetail(null)} />
                    <ItemDetailModal item={selectedPinned} user={{ uid: viewerUid }} isOpen={!!selectedPinned} onClose={() => setSelectedPinned(null)} onViewFeed={onClose}/>

                    <div className="flex flex-col items-center md:flex-row gap-6 relative">
                        <div className="relative shrink-0">
                            <div className="w-32 h-32 rounded-full border-4 border-pink-500 overflow-hidden bg-gray-800"><img src={targ.photoURL || 'https://placehold.co/100?text=User'} className="w-full h-full object-cover"/></div>
                            {(targ.referrals > 0) && refStats && (
                                <div className={`absolute -bottom-2 -right-2 bg-black/90 px-3 py-1 rounded-full border border-white/20 text-[10px] font-black uppercase tracking-widest ${refStats.color} shadow-lg flex flex-col items-center leading-tight`}>
                                    <span>{refStats.badge}</span>
                                    <span className="text-[8px] opacity-80">{targ.customRevSharePct ?? refStats.sharePct}% RevShare</span>
                                </div>
                            )}
                            {isEffVIP(targ) && (
                                <div className="absolute -top-2 -left-2 bg-yellow-500/20 text-yellow-400 p-1.5 rounded-full border border-yellow-400 shadow-[0_0_10px_rgba(250,204,21,0.5)]"><Crown size={14}/></div>
                            )}
                        </div>
                        <div className="text-center md:text-left flex-1 w-full">
                            <div className="flex items-center justify-center md:justify-start gap-2 mb-1">
                                <UserRating sum={targ.ratingSum} count={targ.ratingCount} size="lg" /><h2 className="text-3xl font-black" style={getTextGlowStyle('primaryGlow')}>@{targ.displayName || 'Raver'}</h2>{targ.featuredBadge && <div className="flex mt-1"><BadgeChip badge={targ.featuredBadge} /></div>}
                                {(targ.isKandiCreator || targ.isAdmin) && <span className="text-[8px] bg-yellow-500/20 text-yellow-400 border border-yellow-400/50 px-2 py-0.5 rounded-full font-black uppercase tracking-wider flex items-center gap-1"><Hammer size={9}/>{targ.isAdmin ? 'Team' : 'Official Creator'}</span>}
                            </div>

                            {pinnedItems.length > 0 && (
                                <div className="mb-4 bg-black/50 border border-pink-500/30 p-2 rounded-lg">
                                    <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-2 flex items-center gap-1"><Star size={12}/> Featured Pins</h4>
                                    <div className="flex gap-2 overflow-x-auto pb-1">
                                        {pinnedItems.slice(0, 6).map(item => (
                                            <div key={item.id} onClick={async () => { if (onViewFeedItem) { try { const snap = await getDocs(query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('ownerId', '==', targ.id))); const match = snap.docs.map(d => ({ ...d.data(), id: d.id })).find(t => (t.name && item.name && t.name === item.name) || (item.imageUrl && (t.imageUrl === item.imageUrl)) || (item.mediaUrls?.[0]?.url && t.mediaUrls?.[0]?.url === item.mediaUrls[0].url)); onClose(); onViewFeedItem(match || item); } catch (e) { onClose(); onViewFeedItem(item); } } else { setSelectedPinned(item); } }} className="bg-white/5 border border-white/10 rounded p-1 w-24 shrink-0 cursor-pointer hover:bg-white/10 transition-colors">
                                                <img src={item.mediaUrls?.[0]?.url || item.imageUrl || item.image} className="w-full h-16 object-cover rounded mb-1 border-2 border-pink-500/30" />
                                                <p className="text-[8px] font-bold truncate text-white text-center">★ {item.name}</p>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            )}

                            <div className="flex items-center gap-2 justify-center md:justify-start mb-3 w-full"><div onClick={() => { try { navigator.clipboard.writeText(targ.publicUid || targ.id); alert('Friend UID copied!'); } catch (e) {} }} className="bg-gradient-to-r from-lime-900/40 to-cyan-900/40 border border-lime-400/40 px-4 py-2 rounded font-mono text-sm w-full md:w-auto text-center md:text-left truncate cursor-pointer hover:border-lime-400 transition-colors">Friend UID: <span className="text-lime-400 font-bold">{targ.publicUid || targ.id}</span> <Copy size={11} className="inline ml-1 text-cyan-400"/></div></div>

                            <div className="bg-gradient-to-br from-pink-500/10 via-purple-500/5 to-cyan-500/10 p-4 rounded-xl text-lg relative border-2 border-pink-500/40 flex items-start min-h-[72px] shadow-[0_0_15px_rgba(255,80,180,0.15)]">
                                {!targ.bio && <span className="text-xs uppercase font-bold opacity-40 mr-2 select-none self-center">BIO</span>}
<p className={"opacity-90 italic flex-1 break-words leading-relaxed " + getUserTextStyle(targ.textStyle).className} style={getUserTextStyle(targ.textStyle).style}>{targ.bio || "No vibe check yet."}</p>
                            </div>

                            <div className="flex gap-4 my-4 justify-center md:justify-start flex-wrap">
                                {SOCIAL_PLATFORMS.map(p => { if (targ.socialLinks && targ.socialLinks[p.id]) return (<a key={p.id} href={`https://${p.baseUrl}${targ.socialLinks[p.id]}`} target="_blank" rel="noreferrer" className="bg-white/10 p-2 rounded-full hover:bg-white/20 transition hover:scale-110"><p.icon size={20} color={p.color}/></a>); return null; })}
                            </div>

                            <div className="grid grid-cols-4 gap-2 mb-2">
                                {[{ label: "Items Sold", val: targ.itemsSold || 0, k: 'sold' }, { label: "Bought", val: targ.itemsBought || 0, k: 'bought' }, { label: "$ Sold", val: "$" + Number(targ.totalSalesValue || 0).toFixed(2), k: 'salesVal' }, { label: "$ Bought", val: "$" + Number(targ.totalBoughtValue || 0).toFixed(2), k: 'boughtVal' }, { label: "Likes", val: targ.totalLikes || 0, k: 'likes' }, { label: "Comments", val: targ.totalComments || 0, k: 'comments' }, { label: "Badges", val: getDisplayAchievements(targ).filter(a=>a.unlocked).length }, { label: "Referrals", val: targ.referrals || 0 }].map((s, i) => (
                                    <div key={i} onClick={() => s.k && setStatDetail(s.k)} className={`bg-black/80 border border-lime-400/50 shadow-[0_0_5px_rgba(163,230,53,0.4)] p-1.5 rounded text-center ${s.k ? 'cursor-pointer hover:bg-lime-900/40' : ''}`}><div className="text-sm font-bold text-lime-400 break-words">{s.val}</div><div className="text-[9px] opacity-70 uppercase leading-tight text-white">{s.label}</div></div>
                                ))}
                            </div>
                            <button onClick={() => setShowAnalytics(true)} className="w-full text-center text-xs text-cyan-400 hover:text-white mb-4 underline opacity-80">View Detailed Analytics</button>

                            {!isSelf && (
                                <div className="mt-4">
                                    <AddFriendButton myProfile={viewerProfile} myUid={viewerUid} targetUid={targ.id} targetName={targ.displayName} size="lg" className="w-full" showHint={true} />
                                </div>
                            )}
                            <div className="flex gap-2 mt-2 justify-center md:justify-start">
                                <button onClick={() => setShowCollection(true)} className="rk-shimmer-border flex-1 text-xs flex justify-center items-center gap-2 py-2 rounded-lg font-bold active:scale-95"><Package size={14}/> Collection</button>
                                {!isSelf && <Button onClick={() => { if (onMessage) onMessage(targ.id, targ.displayName || 'Raver'); }} color="purple" className="flex-1 text-xs flex justify-center items-center gap-2"><Mail size={14}/> Message</Button>}
                            </div>
                        </div>
                    </div>

                    <AchievementsCard profile={targ} editable={false} />
                </div>
            )}
        </div>
    );
};


// V42.15: featured-video window is admin-configurable via RK_CFG.videoWindowMin.
// Allowed durations (minutes) — the Firestore rule accepts exactly these.
const VIDEO_WINDOW_CHOICES = [1, 5, 10, 15, 30, 45, 60];
const videoWindowMs = () => { const m = RK_CFG.videoWindowMin; return (VIDEO_WINDOW_CHOICES.includes(m) ? m : 30) * 60000; };

const VideoSubmitModal = ({ user, profile, isOpen, onClose, slots }) => {
    const [link, setLink] = useState('');
    const [parsed, setParsed] = useState(null);
    const [caption, setCaption] = useState('');
    const [busy, setBusy] = useState(false);
    const [confirmation, setConfirmation] = useState(null);

    if (!isOpen) return null;

    const todayKey = new Date().toDateString();
    const usedToday = profile?.videoDay === todayKey ? (profile?.videoCountToday || 0) : 0;

    const checkLink = () => {
        const v = parseVideoLink(link);
        if (!v.ok) { setParsed(null); return alert(v.reason); }
        setParsed(v);
    };

    const submitVideo = async () => {
        if (!parsed) return alert('Paste your clip link and tap Check first.');
        if (usedToday >= 4) return alert('Daily limit reached — 4 featured clips per day. Resets at midnight.');
        setBusy(true);
        try {
            const W = videoWindowMs();
            const now = Date.now();
            const curStart = Math.floor(now / W) * W;
            const taken = new Set(slots.map(s => s.start));
            // V52.2: a user must get a FULL window. The current window has almost always
            // already started, so giving it to them = a partial slot. Instead, always start
            // at the NEXT clean window boundary (the first free one from there).
            let s = curStart + W;
            while (taken.has(s)) s += W;
            const assigned = [s];
            const GRACE = Math.floor(W * 0.1); // ~10% extra time as a little bonus
            const payload = { uid: user.uid, name: profile?.displayName || 'Raver', ownerPublicUid: profile?.publicUid || user.uid, platform: parsed.platform, embedUrl: parsed.embedUrl || null, watchUrl: parsed.watchUrl, caption: (caption || '').slice(0, 100), postedAt: now };
            for (const st of assigned) { await setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'videoSlots', String(st)), { ...payload, start: st, end: st + W + GRACE }); }
            await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { videoDay: todayKey, videoCountToday: usedToday + 1, videosPosted: increment(1) }, { merge: true });
            const startsAt = assigned[0], endsAt = assigned[assigned.length - 1] + W;
            const queueAhead = slots.filter(s => s.start >= Date.now() && s.start < startsAt && s.uid !== user.uid).length;
            setConfirmation({ startsAt, endsAt, queueAhead, live: startsAt <= Date.now() });
            setLink(''); setParsed(null); setCaption('');
        } catch (e) { alert('Submit failed: ' + e.message); } finally { setBusy(false); }
    };

    const fmtT = (t) => new Date(t).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    return (
        <Modal isOpen={isOpen} onClose={onClose} title="🎬 Feature Your Festival Clip">
            <div className="space-y-3">
                <div className="bg-white/5 border border-white/10 rounded p-2 text-[10px] text-gray-100 leading-relaxed">
                    <strong className="text-pink-400">How it works:</strong> Paste a link to your clip on <strong>YouTube, TikTok, Instagram, or Facebook</strong> (Shorts & Reels work great). Use this spot to <strong>advertise yourself, your products, content, streams, brand, or social media</strong> — your profile button shows next to your clip the whole time so every raver can find and follow you. Your clip plays in the homepage <strong>Festival Spotlight</strong> for a rotation window set by the team; windows run one at a time on the clock and queue automatically. Limit: <strong>4 clips/day</strong>, resets at midnight. Keep it festival/rave content and PLUR-friendly. <span className="text-yellow-300">We embed the platform's own player — nothing is stored on our servers, and your clip stops showing the moment its window ends.</span>
                </div>
                {confirmation && (
                    <div className="bg-lime-900/30 border border-lime-400/60 rounded p-3 text-center">
                        <p className="text-xs font-bold text-lime-300">{confirmation.live ? '🟢 Your clip is featured NOW!' : '✅ Clip queued!'}</p>
                        <p className="text-[10px] mt-1">Window: <strong>{fmtT(confirmation.startsAt)} – {fmtT(confirmation.endsAt)}</strong></p>
                        {!confirmation.live && <p className="text-[9px] opacity-70">Queue position: #{confirmation.queueAhead + 1}</p>}
                    </div>
                )}
                <div>
                    <span className="text-[10px] font-bold text-cyan-400 uppercase">Clip link (YouTube · TikTok · Instagram)</span>
                    <div className="flex gap-1 mt-1">
                        <input value={link} onChange={e => { setLink(e.target.value); setParsed(null); }} placeholder="https://youtube.com/shorts/…" className="flex-1 p-2 rounded bg-white/10 border-2 border-white/30 text-[11px]"/>
                        <Button onClick={checkLink} color="cyan" className="px-3 text-[10px]">Check</Button>
                    </div>
                </div>
                {parsed && (
                    <div className="space-y-1">
                        <p className="text-[9px] text-lime-300 bg-lime-900/20 border border-lime-500/40 rounded p-1.5">✅ {parsed.platform.charAt(0).toUpperCase() + parsed.platform.slice(1)} clip verified{parsed.embedUrl ? '' : ' (will show as a tap-to-watch link)'}</p>
                        {parsed.embedUrl && <div className={`bg-black rounded overflow-hidden mx-auto ${parsed.platform === 'youtube' ? 'aspect-video w-full' : 'w-full max-w-[240px]'}`} style={parsed.platform === 'youtube' ? {} : { aspectRatio: '9 / 16', maxHeight: '50vh' }}><iframe src={parsed.embedUrl} className="w-full h-full" frameBorder="0" allow="autoplay; encrypted-media" allowFullScreen scrolling="no" title="preview"/></div>}
                    </div>
                )}
                <input value={caption} onChange={e => setCaption(e.target.value)} maxLength={100} placeholder="Caption (optional, 100 chars)" className="w-full p-2 rounded bg-white/10 border-2 border-white/30 text-xs"/>
                <p className="text-[8px] opacity-50 text-right">{4 - usedToday} clips left today</p>
                <Button onClick={submitVideo} disabled={busy || !parsed || usedToday >= 4} color="primary" className="w-full">{busy ? 'Submitting…' : 'Feature My Clip 🎬'}</Button>
            </div>
        </Modal>
    );
};

const FeaturedVideoBlock = ({ user, profile, nowTick, onViewProfile, onOpenSubmit }) => {
    const [slots, setSlots] = useState([]);
    useEffect(() => {
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'videoSlots')), s => setSlots(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('videoSlots', e));
        return () => unsub();
    }, []);

    const liveClip = slots.find(s => s.start <= nowTick && nowTick < s.end) || null;
    const upcoming = slots.filter(s => s.start > nowTick).sort((a, b) => a.start - b.start);
    // V61: when no live clip, fall back to the admin placeholder (if configured). The
    // placeholder holds the spot until a user posts, and the panel rotates back to it the
    // moment a forced/user clip's window expires.
    let placeholder = null;
    if (!liveClip && RK_CFG.spotlightPlaceholderActive && (RK_CFG.spotlightPlaceholderUrl || '').trim()) {
        const pp = parseVideoLink(RK_CFG.spotlightPlaceholderUrl);
        if (pp && pp.ok) placeholder = { platform: pp.platform, embedUrl: pp.embedUrl || null, watchUrl: pp.watchUrl, name: RK_CFG.spotlightPlaceholderName || 'RaveKandi', caption: RK_CFG.spotlightPlaceholderCaption || '', ownerPublicUid: null, uid: null, isPlaceholder: true };
    }
    const active = liveClip || placeholder;

    // V42.14: window-expiry just clears the slot doc (no files are stored, so
    // nothing to delete from storage). Any viewer past the window cleans it up.
    useEffect(() => {
        const expired = slots.filter(s => s.end <= Date.now());
        expired.forEach(async (s) => { try { await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'videoSlots', s.id)); } catch (e) {} });
    }, [nowTick, slots]);

    return (
        <div className="w-full">
            {active ? (
                <div className="w-full bg-black rounded-xl overflow-hidden border-2 border-pink-500/50 shadow-[0_0_18px_rgba(236,72,153,0.35)]">
                    {active.embedUrl ? (
                        <div className={`w-full bg-black mx-auto ${active.platform === 'youtube' ? 'aspect-video' : 'max-w-[360px]'}`} style={active.platform === 'youtube' ? {} : { aspectRatio: '9 / 16', maxHeight: '70vh' }}><iframe key={active.id} src={active.embedUrl} className="w-full h-full" frameBorder="0" allow="autoplay; encrypted-media; fullscreen" allowFullScreen scrolling="no" title={'Clip by ' + active.name}/></div>
                    ) : (
                        <a href={active.watchUrl} target="_blank" rel="noreferrer" className="flex flex-col items-center justify-center gap-2 h-48 bg-gradient-to-br from-purple-900/40 to-pink-900/40 hover:from-purple-900/60 hover:to-pink-900/60 transition-colors"><Play size={44} className="text-pink-400"/><span className="text-xs font-bold text-white uppercase tracking-wide">Tap to watch on {active.platform}</span></a>
                    )}
                    <div className="p-3 bg-gradient-to-r from-purple-900/40 to-pink-900/40">
                        {active.caption && <p className="text-xs text-gray-100 italic mb-2 break-words">"{active.caption}"</p>}
                        {active.isPlaceholder ? (
                            <div className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-purple-700/60 to-pink-700/60 rounded-lg py-2 text-sm font-black uppercase tracking-wide">
                                <Sparkles size={16}/> {active.name}
                            </div>
                        ) : (
                            <button onClick={() => onViewProfile(active.ownerPublicUid || active.uid)} className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-pink-600 to-purple-600 hover:from-pink-500 hover:to-purple-500 rounded-lg py-2 text-sm font-black uppercase tracking-wide transition-colors">
                                <User size={16}/> Featured: @{active.name} — View Profile
                            </button>
                        )}
                    </div>
                </div>
            ) : (
                <div className="w-full h-48 bg-black/50 border-2 border-dashed border-white/20 rounded-xl flex flex-col items-center justify-center gap-2">
                    <Play size={40} className="text-white/20"/>
                    <p className="text-xs text-white/40 text-center px-4">No clip featured right now — be the first to share your festival vibe!</p>
                </div>
            )}
            <Button onClick={onOpenSubmit} color="primary" className="w-full mt-2 text-xs flex items-center justify-center gap-2"><Video size={14}/> Feature Your Festival Clip</Button>
            {upcoming.length > 0 && <p className="text-[8px] text-center opacity-50 mt-1">⏳ {upcoming.length} clip(s) queued — yours rotates in automatically</p>}
        </div>
    );
};

const VibeTribeModal = ({ user, profile, isOpen, onClose, onViewProfile, onMessageUser }) => {
    const [tab, setTab] = useState('friends');
    const [friends, setFriends] = useState([]);
    const [tribes, setTribes] = useState([]);
    const [loading, setLoading] = useState(true);
    const [newTribeName, setNewTribeName] = useState('');
    const [activeTribe, setActiveTribe] = useState(null);
    const [tribeMsgs, setTribeMsgs] = useState([]);
    const [tribeInput, setTribeInput] = useState('');
    const [friendSearch, setFriendSearch] = useState('');
    const [friendMode, setFriendMode] = useState('mine'); // 'mine' = my friends | 'find' = find new ravers
    const [userResults, setUserResults] = useState([]);
    const [searching, setSearching] = useState(false);
    const [tribeFontOpen, setTribeFontOpen] = useState(false);       // font selector in tribe chat
    const [showMembers, setShowMembers] = useState(false);           // member list popup
    const [memberProfiles, setMemberProfiles] = useState([]);        // loaded member cards
    const [memberSearch, setMemberSearch] = useState('');            // search within tribe members
    const [tribeAddSearch, setTribeAddSearch] = useState('');        // add-by-search in tribe view
    const [tribeAddResults, setTribeAddResults] = useState([]);
    // Search all ravers by name/UID (excludes self + existing friends) for the "Find Ravers" tab.
    const runUserSearch = async (term) => {
        const t = (term || '').trim().toLowerCase();
        if (t.length < 2) { setUserResults([]); return; }
        setSearching(true);
        try {
            const snap = await getDocs(collection(db, 'artifacts', appId, 'users'));
            const myFriends = profile?.friends || [];
            const res = snap.docs.map(d => ({ ...d.data(), id: d.id }))
                .filter(u => u.id !== myUid && (u.publicUid !== profile?.publicUid)
                    && ((u.displayName || '').toLowerCase().includes(t) || (u.publicUid || '').toLowerCase().includes(t)))
                .slice(0, 25);
            setUserResults(res);
        } catch (e) { setUserResults([]); }
        setSearching(false);
    };
    const myUid = user?.uid;

    // Load friends' profiles
    useEffect(() => {
        if (!isOpen || !profile) return;
        const ids = profile.friends || [];
        if (ids.length === 0) { setFriends([]); setLoading(false); return; }
        Promise.all(ids.slice(0, 100).map(id => getDoc(doc(db, 'artifacts', appId, 'users', id)).then(s => s.exists() ? { ...s.data(), id: s.id } : null).catch(() => null)))
            .then(list => { setFriends(list.filter(Boolean)); setLoading(false); });
    }, [isOpen, profile?.friends]);

    // Load tribes I'm in
    useEffect(() => {
        if (!isOpen || !myUid) return;
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tribes'), where('members', 'array-contains', myUid)), s => {
            const list = s.docs.map(d => ({ ...d.data(), id: d.id }));
            setTribes(list);
            // update achievement metrics (best-effort)
            const biggest = list.reduce((m, t) => Math.max(m, (t.memberCount || (t.members || []).length)), 0);
            try { setDoc(doc(db, 'artifacts', appId, 'users', myUid), { tribesJoined: list.length, biggestTribe: biggest }, { merge: true }); } catch (e) {}
        }, e => console.log('tribes', e));
        return () => unsub();
    }, [isOpen, myUid]);

    // Load active tribe's messages
    useEffect(() => {
        if (!activeTribe) { setTribeMsgs([]); return; }
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tribes', activeTribe.id, 'messages'), orderBy('at', 'asc')), s => {
            setTribeMsgs(s.docs.map(d => ({ ...d.data(), id: d.id })));
        }, e => console.log('tribe msgs', e));
        return () => unsub();
    }, [activeTribe]);

    // Load tribe member profiles (for the member-list popup).
    useEffect(() => {
        if (!showMembers || !activeTribe) { return; }
        const ids = (activeTribe.members || []).slice(0, 200);
        Promise.all(ids.map(id => getDoc(doc(db, 'artifacts', appId, 'users', id)).then(s => s.exists() ? { ...s.data(), id: s.id } : null).catch(() => null)))
            .then(list => setMemberProfiles(list.filter(Boolean)));
    }, [showMembers, activeTribe]);

    // Search all ravers to add to the active tribe (excludes existing members).
    const runTribeAddSearch = async (term) => {
        const t = (term || '').trim().toLowerCase();
        if (t.length < 2) { setTribeAddResults([]); return; }
        try {
            const snap = await getDocs(collection(db, 'artifacts', appId, 'users'));
            const mem = (activeTribe?.members || []);
            const res = snap.docs.map(d => ({ ...d.data(), id: d.id }))
                .filter(u => u.id !== myUid && !mem.includes(u.id) && ((u.displayName || '').toLowerCase().includes(t) || (u.publicUid || '').toLowerCase().includes(t)))
                .slice(0, 25);
            setTribeAddResults(res);
        } catch (e) { setTribeAddResults([]); }
    };

    if (!isOpen) return null;

    const doCreateTribe = async () => {
        if (!newTribeName.trim()) { alert("Name your tribe first!"); return; }
        try { await createTribe(myUid, profile?.displayName || 'Raver', newTribeName); setNewTribeName(''); alert('🎉 Vibe Tribe "' + newTribeName.trim() + '" created! Add friends from the Friends tab.'); }
        catch (e) { alert("Couldn't create tribe: " + e.message); }
    };
    const proposeFriend = async (tribe, friendId, friendName) => {
        try { const needed = await proposeToTribe(tribe.id, friendId, friendName, myUid); alert('Proposed @' + friendName + ' to "' + tribe.name + '". Needs ' + needed + ' member vote(s) to join.'); }
        catch (e) { alert(e.message); }
    };
    const sendTMsg = async () => {
        if (!tribeInput.trim() || !activeTribe) return;
        const txt = tribeInput; setTribeInput('');
        try { await sendTribeMessage(activeTribe.id, myUid, profile?.displayName || 'Raver', txt, profile?.featuredBadge || null, { style: profile?.msgTextStyle || profile?.textStyle || null, photoURL: profile?.photoURL || '', publicUid: profile?.publicUid || myUid }); } catch (e) {}
    };

    return (
        <Modal isOpen={isOpen} onClose={() => { setActiveTribe(null); onClose(); }} title="🌈 Vibe Tribe" wide={true}>
            {!activeTribe ? (
                <div>
                    <div className="flex gap-2 mb-3">
                        <button onClick={() => setTab('friends')} className={`flex-1 text-xs font-bold py-2 rounded-lg ${tab==='friends' ? 'bg-pink-600 text-white' : 'bg-white/5 text-white/60'}`}>👥 Friends ({(profile?.friends||[]).length})</button>
                        <button onClick={() => setTab('tribes')} className={`flex-1 text-xs font-bold py-2 rounded-lg ${tab==='tribes' ? 'bg-purple-600 text-white' : 'bg-white/5 text-white/60'}`}>🌈 Tribes ({tribes.length})</button>
                    </div>

                    {tab === 'friends' && (
                        <div>
                            {/* Mode toggle: my friends vs find new ravers */}
                            <div className="flex gap-1 mb-3 bg-black/40 rounded-lg p-1">
                                <button onClick={() => setFriendMode('mine')} className={`flex-1 text-[11px] font-bold py-1.5 rounded-md transition ${friendMode==='mine' ? 'bg-pink-600 text-white' : 'text-white/50'}`}>👥 My Friends</button>
                                <button onClick={() => setFriendMode('find')} className={`flex-1 text-[11px] font-bold py-1.5 rounded-md transition ${friendMode==='find' ? 'bg-cyan-600 text-white' : 'text-white/50'}`}>🔍 Find Ravers</button>
                            </div>

                            {friendMode === 'mine' ? (
                                <div>
                                    {friends.length > 0 && (
                                        <div className="relative mb-3">
                                            <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-white/40"/>
                                            <input value={friendSearch} onChange={e => setFriendSearch(e.target.value)} placeholder="Search your friends..." className="w-full bg-black/50 border border-white/20 rounded-lg pl-9 pr-3 py-2.5 text-sm focus:border-pink-500/60 outline-none"/>
                                        </div>
                                    )}
                                    <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-1">
                                        {loading ? <p className="text-center opacity-50 text-sm py-6">Loading your friends…</p> : friends.length === 0 ? (
                                            <div className="text-center py-8"><Users size={36} className="mx-auto text-white/20 mb-2"/><p className="text-sm opacity-60">No friends yet! Switch to <strong>Find Ravers</strong> to search for people, or tap "Add Friend" on any raver's profile.</p></div>
                                        ) : (() => {
                                            const fq = friendSearch.trim().toLowerCase();
                                            const shown = fq ? friends.filter(f => (f.displayName || '').toLowerCase().includes(fq) || (f.publicUid || '').toLowerCase().includes(fq)) : friends;
                                            if (shown.length === 0) return <p className="text-center opacity-50 text-sm py-6">No friends match "{friendSearch}".</p>;
                                            return shown.map(f => (
                                                <div key={f.id} className="flex items-center gap-3 bg-white/5 border border-white/10 rounded-lg p-3 hover:bg-white/10 transition">
                                                    <img src={f.photoURL || 'https://placehold.co/48?text=U'} className="w-12 h-12 rounded-full object-cover border-2 border-pink-500/40 cursor-pointer" onClick={() => { onClose(); onViewProfile(f.publicUid || f.id); }}/>
                                                    <div className="flex-1 min-w-0 cursor-pointer" onClick={() => { onClose(); onViewProfile(f.publicUid || f.id); }}>
                                                        <p className="text-sm font-bold truncate flex items-center gap-1">@{f.displayName || 'Raver'}{f.featuredBadge && <BadgeChip badge={f.featuredBadge} />}</p>
                                                        <p className="text-[10px] opacity-50">{f.itemsSold || 0} sold · {(f.friends||[]).length} friends</p>
                                                    </div>
                                                    <button onClick={() => { if (onMessageUser) { onClose(); onMessageUser(f.id, f.displayName); } }} className="text-cyan-400 p-2 hover:bg-white/10 rounded-lg" title="Message"><Mail size={18}/></button>
                                                    <button onClick={async () => { if (window.confirm('Remove @' + (f.displayName||'this raver') + ' from your friends?')) { try { await removeFriend(myUid, f.id); setFriends(friends.filter(x => x.id !== f.id)); } catch (e) {} } }} className="text-red-400 p-2 hover:bg-white/10 rounded-lg" title="Remove friend"><X size={18}/></button>
                                                </div>
                                            ));
                                        })()}
                                    </div>
                                </div>
                            ) : (
                                <div>
                                    <div className="relative mb-3">
                                        <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-white/40"/>
                                        <input value={friendSearch} onChange={e => { setFriendSearch(e.target.value); runUserSearch(e.target.value); }} placeholder="Search ravers by name or UID..." className="w-full bg-black/50 border border-cyan-500/30 rounded-lg pl-9 pr-3 py-2.5 text-sm focus:border-cyan-500/60 outline-none"/>
                                    </div>
                                    <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-1">
                                        {friendSearch.trim().length < 2 ? <p className="text-center opacity-50 text-sm py-8">Type at least 2 characters to search for ravers to add.</p>
                                        : searching ? <p className="text-center opacity-50 text-sm py-6">Searching…</p>
                                        : userResults.length === 0 ? <p className="text-center opacity-50 text-sm py-6">No ravers found matching "{friendSearch}".</p>
                                        : userResults.map(u => (
                                            <div key={u.id} className="flex items-center gap-3 bg-white/5 border border-white/10 rounded-lg p-3 hover:bg-white/10 transition">
                                                <img src={u.photoURL || 'https://placehold.co/48?text=U'} className="w-12 h-12 rounded-full object-cover border-2 border-cyan-500/40 cursor-pointer" onClick={() => { onClose(); onViewProfile(u.publicUid || u.id); }}/>
                                                <div className="flex-1 min-w-0 cursor-pointer" onClick={() => { onClose(); onViewProfile(u.publicUid || u.id); }}>
                                                    <p className="text-sm font-bold truncate flex items-center gap-1">@{u.displayName || 'Raver'}{u.featuredBadge && <BadgeChip badge={u.featuredBadge} />}</p>
                                                    <p className="text-[10px] opacity-50">{u.itemsSold || 0} sold · {(u.friends||[]).length} friends</p>
                                                </div>
                                                <AddFriendButton myProfile={profile} myUid={myUid} targetUid={u.id} targetName={u.displayName} />
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            )}
                        </div>
                    )}

                    {tab === 'tribes' && (
                        <div className="space-y-3 max-h-[55vh] overflow-y-auto pr-1">
                            <div className="bg-purple-900/20 border border-purple-500/30 rounded-lg p-3">
                                <p className="text-[10px] font-bold text-purple-300 mb-1">Start a new Vibe Tribe</p>
                                <p className="text-[8px] opacity-60 mb-2">A tribe is a named group of friends with a shared group chat. New members need a 2/3 vote of current members to join.</p>
                                <div className="flex gap-2">
                                    <Input value={newTribeName} onChange={setNewTribeName} placeholder="Tribe name (e.g. Bass Heads)" className="mb-0 flex-1"/>
                                    <Button onClick={doCreateTribe} color="lime" className="text-[10px]">Create</Button>
                                </div>
                            </div>
                            {tribes.length === 0 ? <p className="text-center opacity-50 text-xs py-4">You're not in any tribes yet. Create one above!</p> : tribes.map(t => {
                                const myFriendsNotIn = (friends || []).filter(f => !(t.members||[]).includes(f.id));
                                const pendingList = Object.entries(t.pendingVotes || {});
                                return (
                                    <div key={t.id} className="bg-white/5 border border-purple-500/30 rounded-lg p-3">
                                        <div className="flex items-center justify-between mb-2">
                                            <div><p className="text-sm font-black text-purple-200">🌈 {t.name}</p><p className="text-[8px] opacity-50">{t.memberCount || (t.members||[]).length} members</p></div>
                                            <button onClick={() => setActiveTribe(t)} className="text-[10px] font-bold bg-purple-600 text-white rounded-full px-3 py-1 flex items-center gap-1"><MessageSquare size={11}/> Group Chat</button>
                                        </div>
                                        {pendingList.length > 0 && (
                                            <div className="bg-yellow-900/20 border border-yellow-500/30 rounded p-2 mb-2">
                                                <p className="text-[9px] font-bold text-yellow-300 mb-1">🗳️ Pending votes:</p>
                                                {pendingList.map(([cid, info]) => {
                                                    const iVoted = (info.votes||[]).includes(myUid);
                                                    return (
                                                        <div key={cid} className="flex items-center justify-between text-[9px] mb-1">
                                                            <span>@{info.name} — {info.votes.length}/{info.needed} votes</span>
                                                            {!iVoted ? <button onClick={async () => { try { const r = await voteForTribeMember(t.id, cid, myUid); alert(r === 'approved' ? '✅ Approved — they joined!' : '✅ Vote counted.'); } catch (e) { alert(e.message); } }} className="bg-lime-600/40 text-lime-200 border border-lime-400/40 rounded px-2 py-0.5 font-bold">Vote Yes</button> : <span className="text-lime-400">✓ voted</span>}
                                                        </div>
                                                    );
                                                })}
                                            </div>
                                        )}
                                        {myFriendsNotIn.length > 0 && (
                                            <div>
                                                <p className="text-[8px] opacity-60 mb-1">Invite a friend (starts a vote):</p>
                                                <div className="flex flex-wrap gap-1">
                                                    {myFriendsNotIn.slice(0, 8).map(f => (
                                                        <button key={f.id} onClick={() => proposeFriend(t, f.id, f.displayName)} className="text-[9px] bg-pink-600/30 text-pink-200 border border-pink-400/40 rounded-full px-2 py-0.5">+ @{f.displayName}</button>
                                                    ))}
                                                </div>
                                            </div>
                                        )}
                                        <button onClick={async () => { if (window.confirm('Leave "' + t.name + '"?')) { try { await leaveTribe(t.id, myUid); } catch (e) {} } }} className="text-[8px] text-red-400 mt-2 underline">Leave tribe</button>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>
            ) : (
                <div>
                    <div className="flex items-center justify-between mb-2 bg-purple-900/30 border border-purple-500/40 rounded-lg p-2">
                        <button onClick={() => setActiveTribe(null)} className="text-cyan-400 text-xs font-bold flex items-center gap-1"><ChevronLeft size={16}/> Back</button>
                        <span className="text-sm font-black truncate px-2">🌈 {activeTribe.name}</span>
                        <button onClick={() => setShowMembers(true)} className="text-[10px] font-bold bg-purple-600/60 hover:bg-purple-600 border border-purple-400/40 rounded-full px-2 py-1 flex items-center gap-1" title="View members"><Users size={12}/> {activeTribe.memberCount || (activeTribe.members||[]).length}</button>
                    </div>
                    <div className="h-[46vh] overflow-y-auto bg-black/40 rounded-lg p-3 space-y-3 flex flex-col mb-2">
                        {tribeMsgs.length === 0 && <p className="text-center opacity-40 text-sm py-10">No messages yet. Say hi to your tribe! 🌈</p>}
                        {tribeMsgs.map(m => {
                            const mine = m.sender === myUid;
                            const ts = getUserTextStyle(m.style);
                            return (
                                <div key={m.id} className={`flex items-start gap-2 max-w-[88%] ${mine ? 'self-end flex-row-reverse' : 'self-start'}`}>
                                    <img src={m.photoURL || 'https://placehold.co/32?text=U'} onClick={() => { onClose(); onViewProfile(m.publicUid || m.sender); }} className="w-7 h-7 rounded-full object-cover border border-pink-500/40 cursor-pointer shrink-0 mt-0.5"/>
                                    <div className={mine ? 'items-end flex flex-col' : ''}>
                                        <div className="flex items-center gap-1 mb-0.5">
                                            <button onClick={() => { onClose(); onViewProfile(m.publicUid || m.sender); }} className={`text-[9px] font-bold ${mine ? 'text-lime-300' : 'text-pink-300'} hover:underline`}>@{m.senderName}</button>{m.badge && <BadgeChip badge={m.badge} />}
                                        </div>
                                        <div className={`px-3 py-2 rounded-2xl text-sm leading-relaxed ${mine ? 'bg-purple-600/70 rounded-br-md' : 'bg-white/15 rounded-bl-md'}`}><p className={'whitespace-pre-wrap break-words ' + ts.className} style={ts.style}>{m.text}</p></div>
                                        <p className="text-[8px] opacity-40 mt-0.5">{new Date(m.at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</p>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                    <div className="flex gap-2 items-center">
                        <button onClick={() => { if (!isEffVIP(profile)) { alert('🔤 The Font & Style selector is a VIP perk — unlock it, or enjoy it free during launch!'); return; } setTribeFontOpen(true); }} title="Chat font & style" className={"shrink-0 w-10 h-10 rounded-lg border flex items-center justify-center " + (isEffVIP(profile) ? "bg-fuchsia-600/30 border-fuchsia-500/40 text-fuchsia-200 hover:bg-fuchsia-600/50" : "bg-white/5 border-white/15 text-white/40")}><Type size={16}/></button>
                        <Input value={tribeInput} onChange={setTribeInput} placeholder="Message your tribe..." className="mb-0 flex-1"/>
                        <Button onClick={sendTMsg} disabled={!tribeInput.trim()} color="purple" className="px-4"><Send size={18}/></Button>
                    </div>

                    {/* Member list popup with search + add-by-search */}
                    <Modal isOpen={showMembers} onClose={() => { setShowMembers(false); setMemberSearch(''); setTribeAddSearch(''); setTribeAddResults([]); }} zClass="z-[130]" title={'🌈 ' + activeTribe.name + ' — Members'}>
                        <div className="space-y-3">
                            <div className="relative">
                                <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-white/40"/>
                                <input value={memberSearch} onChange={e => setMemberSearch(e.target.value)} placeholder="Search members in this tribe..." className="w-full bg-black/50 border border-white/20 rounded-lg pl-9 pr-3 py-2 text-sm outline-none focus:border-purple-500/60"/>
                            </div>
                            <div className="space-y-2 max-h-[40vh] overflow-y-auto pr-1">
                                {memberProfiles.length === 0 ? <p className="text-center opacity-50 text-xs py-4">Loading members…</p> : (() => {
                                    const mq = memberSearch.trim().toLowerCase();
                                    const shown = mq ? memberProfiles.filter(p => (p.displayName||'').toLowerCase().includes(mq) || (p.publicUid||'').toLowerCase().includes(mq)) : memberProfiles;
                                    if (shown.length === 0) return <p className="text-center opacity-50 text-xs py-4">No members match "{memberSearch}".</p>;
                                    return shown.map(p => (
                                        <div key={p.id} className="flex items-center gap-3 bg-white/5 border border-white/10 rounded-lg p-2.5 hover:bg-white/10 transition">
                                            <img src={p.photoURL || 'https://placehold.co/48?text=U'} onClick={() => { setShowMembers(false); onClose(); onViewProfile(p.publicUid || p.id); }} className="w-10 h-10 rounded-full object-cover border-2 border-purple-500/40 cursor-pointer"/>
                                            <div className="flex-1 min-w-0 cursor-pointer" onClick={() => { setShowMembers(false); onClose(); onViewProfile(p.publicUid || p.id); }}>
                                                <p className="text-sm font-bold truncate flex items-center gap-1">@{p.displayName || 'Raver'}{p.id === activeTribe.creatorId && <span className="text-[7px] bg-yellow-500/20 text-yellow-300 px-1 rounded">FOUNDER</span>}{p.featuredBadge && <BadgeChip badge={p.featuredBadge} />}</p>
                                                <p className="text-[10px] opacity-50">{p.itemsSold || 0} sold · {(p.friends||[]).length} friends</p>
                                            </div>
                                            {p.id !== myUid && <button onClick={() => { if (onMessageUser) { setShowMembers(false); onClose(); onMessageUser(p.id, p.displayName); } }} className="text-cyan-400 p-2 hover:bg-white/10 rounded-lg" title="Message"><Mail size={16}/></button>}
                                        </div>
                                    ));
                                })()}
                            </div>
                            <div className="border-t border-white/10 pt-3">
                                <p className="text-[10px] font-bold text-cyan-300 mb-2">➕ Add a raver to this tribe (starts a vote)</p>
                                <div className="relative mb-2">
                                    <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-white/40"/>
                                    <input value={tribeAddSearch} onChange={e => { setTribeAddSearch(e.target.value); runTribeAddSearch(e.target.value); }} placeholder="Search ravers by name or UID..." className="w-full bg-black/50 border border-cyan-500/30 rounded-lg pl-9 pr-3 py-2 text-sm outline-none focus:border-cyan-500/60"/>
                                </div>
                                <div className="space-y-2 max-h-[30vh] overflow-y-auto pr-1">
                                    {tribeAddSearch.trim().length < 2 ? <p className="text-center opacity-50 text-[11px] py-3">Type at least 2 characters to search.</p>
                                    : tribeAddResults.length === 0 ? <p className="text-center opacity-50 text-[11px] py-3">No ravers found.</p>
                                    : tribeAddResults.map(u => (
                                        <div key={u.id} className="flex items-center gap-2 bg-white/5 border border-white/10 rounded-lg p-2">
                                            <img src={u.photoURL || 'https://placehold.co/48?text=U'} className="w-8 h-8 rounded-full object-cover border border-cyan-500/40"/>
                                            <div className="flex-1 min-w-0"><p className="text-xs font-bold truncate">@{u.displayName || 'Raver'}</p></div>
                                            <button onClick={async () => { try { const needed = await proposeToTribe(activeTribe.id, u.id, u.displayName || 'Raver', myUid); alert('Proposed @' + (u.displayName||'raver') + '. Needs ' + needed + ' vote(s) to join.'); setTribeAddSearch(''); setTribeAddResults([]); } catch (e) { alert(e.message); } }} className="text-[10px] font-bold bg-cyan-600 text-white rounded-full px-3 py-1">Propose</button>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </Modal>

                    <FontSelectorModal user={user} profile={profile} isOpen={tribeFontOpen} onClose={() => setTribeFontOpen(false)} field="msgTextStyle" titleLabel="Tribe Chat Font" zClass="z-[130]" />
                </div>
            )}
        </Modal>
    );
};

const ProfileView = ({ user, onOpenSettings, onViewFeed, onViewProfile, onMessageUser, onReplayTutorial }) => {
    const [profile, setProfile] = useState({});
    const [modals, setModals] = useState({ username: false, bio: false, settings: false, collection: false, inventory: false, socials: false, referrals: false, analytics: false, vip: false, theme: false, font: false, vibeTribe: false });
    const [showCreatorHub, setShowCreatorHub] = useState(false);
    const [showAdminPortal, setShowAdminPortal] = useState(false);
    const [hideGuestPrompt, setHideGuestPrompt] = useState(false);
    
    const [pinnedItems, setPinnedItems] = useState([]);
    const [showBadges, setShowBadges] = useState(false);
    const [statDetail, setStatDetail] = useState(null);
    const [showRevShare, setShowRevShare] = useState(false);
    const [showBanner, setShowBanner] = useState(false);
    const [showBoost, setShowBoost] = useState(false);
    const [selectedPinned, setSelectedPinned] = useState(null);
    const [pinModalOpen, setPinModalOpen] = useState(false);
    
    useEffect(() => { 
        if(!user?.uid) return;
        ensureUserExists(user.uid); 
        const unsub = onSnapshot(doc(db, 'artifacts', appId, 'users', user.uid), s => setProfile(s.data() || {})); 
        return () => unsub();
    }, [user]);

    useEffect(() => {
        if(!user?.uid) return;
        const q = query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), where('isPinned', '==', true));
        return onSnapshot(q, s => setPinnedItems(s.docs.map(d => ({...d.data(), id: d.id}))));
    }, [user, profile]);
    
    const unpinItem = async (itemId) => { await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', itemId), { isPinned: false }); };

    if(!user?.uid) return <div className="p-10 text-center flex flex-col items-center gap-4"><LoadingBar progress={50} className="w-32"/><p className="text-white animate-pulse font-black italic tracking-widest uppercase">Connecting to Hive...</p></div>;
    const uploadPic = async (e) => { const f = e.target.files[0]; if(f) { const img = await compressImage(f); await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { photoURL: img }, { merge: true }); } };
    const copyUid = () => { navigator.clipboard.writeText(profile.publicUid || user.uid); alert("Public Friend ID Copied!"); };
    if(showCreatorHub) return <CreatorProjectHub user={user} onClose={() => setShowCreatorHub(false)} />;
    
    if(showAdminPortal && profile.isAdmin) return (
        <div className="fixed inset-0 bg-black z-[100] overflow-y-auto p-4">
            <div className="flex justify-between items-center mb-6">
                <h2 className="text-2xl font-black italic text-red-500 uppercase tracking-widest">Admin Portal</h2>
                <button onClick={() => setShowAdminPortal(false)} className="text-white"><XCircle size={32}/></button>
            </div>
            <AdminDashboard user={user} profile={profile} onMessageUser={(uid, name) => { if (onMessageUser) onMessageUser(uid, name || 'Applicant'); }}/>
        </div>
    );

    const refStats = getReferralTier(profile.referrals || 0);

    return (
        <div className="relative">
            <div className={`max-w-4xl mx-auto px-4 pb-20 space-y-6 ${user?.isAnonymous ? 'pointer-events-none filter blur-[2px] opacity-40 grayscale' : ''}`}>
                <UsernameModal user={user} profile={profile} isOpen={modals.username} onClose={()=>setModals({...modals, username:false})}/>
                <CollectionPopout user={user} type="posts" isOpen={modals.collection} onClose={()=>setModals({...modals, collection:false})} onViewFeed={onViewFeed} hideDIY={!!profile?.hideDIYFromOthers}/>
                <CollectionPopout user={user} type="stock" isOpen={modals.inventory} onClose={()=>setModals({...modals, inventory:false})}/>
                <MainSettingsModal user={user} profile={profile} isOpen={modals.settings} onClose={()=>setModals({...modals, settings:false})} onReplayTutorial={onReplayTutorial}/>
                <BioModal user={user} currentBio={profile.bio || ''} isOpen={modals.bio} onClose={()=>setModals({...modals, bio:false})}/>
                <EditSocialsModal user={user} profile={profile} isOpen={modals.socials} onClose={()=>setModals({...modals, socials:false})}/>
                <ReferralModal user={user} profile={profile} isOpen={modals.referrals} onClose={()=>setModals({...modals, referrals:false})}/>
                <ItemDetailModal item={selectedPinned} user={user} isOpen={!!selectedPinned} onClose={() => setSelectedPinned(null)} onViewFeed={onViewFeed}/>
                <PinSelectModal user={user} profile={profile} isOpen={pinModalOpen} onClose={() => setPinModalOpen(false)} />
                <UserStatsDashboard profile={profile} isOpen={modals.analytics} onClose={() => setModals({...modals, analytics: false})} />
                <VIPCheckoutModal user={user} isOpen={modals.vip} onClose={() => setModals({...modals, vip: false})} />
                <ThemeSelectorModal user={user} profile={profile} isOpen={modals.theme} onClose={() => setModals({...modals, theme: false})} />
                <VibeTribeModal user={user} profile={profile} isOpen={modals.vibeTribe} onClose={() => setModals({...modals, vibeTribe: false})} onViewProfile={onViewProfile} onMessageUser={onMessageUser} />
                <FontSelectorModal user={user} profile={profile} isOpen={modals.font} onClose={() => setModals({...modals, font: false})} field="textStyle" titleLabel="Profile Font & Style" zClass="z-[200]" />
                <BadgeSelectorModal user={user} profile={profile} isOpen={showBadges} onClose={() => setShowBadges(false)} />
                <StatDetailModal statKey={statDetail} uid={user.uid} profile={profile} isOpen={!!statDetail} onClose={() => setStatDetail(null)} />
                <RevShareShareModal user={user} profile={profile} isOpen={showRevShare} onClose={() => setShowRevShare(false)} />
                <BannerModal user={user} profile={profile} isOpen={showBanner} onClose={() => setShowBanner(false)} onGoVip={() => setModals({...modals, vip: true})} />
                <BoostModal user={user} profile={profile} isOpen={showBoost} onClose={() => setShowBoost(false)} onGoVip={() => setModals({...modals, vip: true})} onGoSell={() => onViewFeed(profile?.publicUid || user.uid)} />
                
                <div className="flex flex-col items-center md:flex-row gap-6 relative">
                    <div className="relative">
                        <div className="w-32 h-32 rounded-full border-4 border-pink-500 overflow-hidden bg-gray-800 group"><input type="file" onChange={uploadPic} className="absolute inset-0 opacity-0 z-10"/><img src={profile.photoURL || 'https://placehold.co/100?text=User'} className="w-full h-full object-cover"/></div>
                        {(profile.referrals > 0) && (
                            <div className={`absolute -bottom-2 -right-2 bg-black/90 px-3 py-1 rounded-full border border-white/20 text-[10px] font-black uppercase tracking-widest ${refStats.color} shadow-lg flex flex-col items-center leading-tight`}>
                                <span>{refStats.badge}</span>
                                <span className="text-[8px] opacity-80">{profile.customRevSharePct ?? refStats.sharePct}% RevShare</span>
                            </div>
                        )}
                        {isEffVIP(profile) && (
                            <div className="absolute -top-2 -left-2 bg-yellow-500/20 text-yellow-400 p-1.5 rounded-full border border-yellow-400 shadow-[0_0_10px_rgba(250,204,21,0.5)]">
                                <Crown size={14}/>
                            </div>
                        )}
                    </div>
                    <div className="text-center md:text-left flex-1 w-full">
                        <div className="mb-1"><UserRating sum={profile.ratingSum} count={profile.ratingCount} size="lg" /><div className="flex items-center justify-center md:justify-start gap-2"><h2 className="text-3xl font-black" style={getTextGlowStyle('primaryGlow')}>@{profile.displayName || 'Raver'}</h2><button onClick={() => setModals({...modals, username:true})}><Pencil size={16}/></button></div>{profile.featuredBadge && <div className="flex justify-center md:justify-start mt-1"><BadgeChip badge={profile.featuredBadge} /></div>}</div>
                        {!user?.isAnonymous && (() => {
                    // V55.1: unified pin box, available to ALL users. FREE tier = up to 3 pins.
                    // VIP tier = up to 6 pins (the 2nd row of 3). Non-VIP users see a VIP upsell
                    // where the 4th slot would be. The pin chooser is INSIDE the box.
                    const vip = isEffVIP(profile);
                    const maxPins = vip ? 6 : 3;
                    const pins = pinnedItems.slice(0, maxPins);
                    let slots = pins.length + 1; // trailing click-box
                    if (slots > maxPins) slots = maxPins;
                    slots = Math.ceil(slots / 3) * 3; // round up to full row
                    if (slots > maxPins) slots = maxPins;
                    if (slots < 3) slots = 3;
                    const showVipUpsell = !vip && pins.length >= 3; // free tier full -> tease row 2
                    return (
                        <div className="mt-2 bg-black/50 border border-pink-500/30 rounded-xl p-3">
                            <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-2 flex items-center gap-1"><Star size={12}/> Featured Pins <span className="opacity-50 normal-case font-normal">({pins.length}/{maxPins}){!vip ? ' · Free tier' : ''}</span></h4>
                            <div className="grid grid-cols-3 gap-2">
                                {Array.from({ length: slots }).map((_, index) => {
                                    const item = pins[index];
                                    if (item) {
                                        return (
                                            <div key={`pin-${item.id}`} onClick={() => setSelectedPinned(item)} className="bg-white/5 border border-pink-500/30 rounded-lg p-1 cursor-pointer hover:bg-white/10 transition-colors relative group aspect-square flex flex-col">
                                                <button onClick={(e) => { e.stopPropagation(); unpinItem(item.id); }} className="absolute top-1 right-1 bg-black/80 text-red-400 p-0.5 rounded-full opacity-80 hover:opacity-100 z-10"><XCircle size={14}/></button>
                                                <img src={item.mediaUrls?.[0]?.url || item.imageUrl || item.image || 'https://placehold.co/100?text=Pin'} className="w-full flex-1 object-cover rounded mb-1 border border-pink-500/20" />
                                                <p className="text-[8px] font-bold truncate text-white text-center">★ {item.name}</p>
                                            </div>
                                        );
                                    }
                                    const isChooser = index === pins.length;
                                    return (
                                        <button key={`pin-empty-${index}`} onClick={() => isChooser && setPinModalOpen(true)} disabled={!isChooser} className={`border border-dashed rounded-lg flex flex-col items-center justify-center aspect-square transition ${isChooser ? 'border-pink-400/60 bg-pink-500/5 hover:bg-pink-500/15 cursor-pointer' : 'border-white/10 opacity-30 cursor-default'}`}>
                                            <PlusCircle className={isChooser ? 'text-pink-400 mb-1' : 'text-white/40 mb-1'} size={18}/>
                                            <span className="text-[8px] text-center font-bold px-1">{isChooser ? 'Pin an item' : ''}</span>
                                        </button>
                                    );
                                })}
                            </div>
                            {showVipUpsell ? (
                                <button onClick={() => setModals({...modals, vip: true})} className="w-full mt-2 bg-gradient-to-r from-yellow-500/20 to-amber-500/10 border border-yellow-400/40 rounded-lg p-2 flex items-center justify-center gap-2 hover:from-yellow-500/30 transition">
                                    <Crown size={14} className="text-yellow-400"/><span className="text-[9px] font-black text-yellow-300 uppercase">Unlock 3 more pins with VIP</span>
                                </button>
                            ) : (
                                <p className="text-[8px] opacity-40 mt-2">Tap a + box to pin one of your items. {vip ? 'Pin up to 6 — a new row opens as you fill the current one.' : 'Free tier: up to 3 pins. VIP unlocks 6.'}</p>
                            )}
                        </div>
                    );
                })()}

                        
                        {(profile.isKandiCreator || profile.isAdmin) && (
                            <div className="mb-2 p-2 bg-white/5 border-l-2 border-lime-400 rounded-r flex items-center justify-between">
                                <span className="text-[10px] uppercase font-bold text-lime-400 tracking-wider">Creator Portal Access</span>
                                <button onClick={() => setShowCreatorHub(true)} className="bg-lime-500/20 text-lime-400 p-2 rounded hover:bg-lime-500/40"><Hammer size={16}/></button>
                            </div>
                        )}
                        
                        {profile.isAdmin && (
                            <div className="mb-4 p-2 bg-white/5 border-l-2 border-red-500 rounded-r flex items-center justify-between">
                                <span className="text-[10px] uppercase font-bold text-red-500 tracking-wider">Admin Portal Access</span>
                                <button onClick={() => setShowAdminPortal(true)} className="bg-red-500/20 text-red-500 p-2 rounded hover:bg-red-500/40"><Shield size={16}/></button>
                            </div>
                        )}


                        <div className="mb-3 w-full">
                            <div onClick={() => setShowRevShare(true)} className="bg-gradient-to-r from-lime-900/40 to-cyan-900/40 border-2 border-lime-400/40 px-5 py-3.5 rounded-xl font-mono text-base w-full text-center md:text-left cursor-pointer hover:border-lime-400 transition-colors flex items-center justify-center md:justify-start gap-2 flex-wrap">
                                <span className="font-bold">Friend UID:</span> <span className="text-lime-400 font-black text-lg break-all">{profile.publicUid || user.uid}</span> <Share2 size={15} className="text-cyan-400"/> <span className="text-[10px] text-cyan-400 uppercase font-bold">RevShare</span>
                            </div>
                            <p className="text-[10px] text-cyan-300/70 mt-1.5 text-center md:text-left">Tap the block to open the referral program 🎁</p>
                        </div>
                        
                        <div className="bg-gradient-to-br from-pink-500/10 via-purple-500/5 to-cyan-500/10 p-4 rounded-xl text-lg relative border-2 border-pink-500/40 flex items-start min-h-[72px] cursor-pointer hover:border-pink-400/70 transition-colors shadow-[0_0_15px_rgba(255,80,180,0.15)]" onClick={()=>setModals({...modals, bio:true})}>
                            {!profile.bio && <span className="text-xs uppercase font-bold opacity-40 mr-2 select-none self-center">✎ BIO</span>}
<p className={"opacity-90 italic flex-1 leading-relaxed " + getUserTextStyle(profile.textStyle).className} style={getUserTextStyle(profile.textStyle).style}>{profile.bio || "Tap to add your vibe check..."}</p>
                        </div>

                        <div className="flex gap-4 my-4 justify-center md:justify-start flex-wrap">
                            {SOCIAL_PLATFORMS.map(p => { if(profile.socialLinks && profile.socialLinks[p.id]) return (<a key={p.id} href={`https://${p.baseUrl}${profile.socialLinks[p.id]}`} target="_blank" rel="noreferrer" className="bg-white/10 p-2 rounded-full hover:bg-white/20 transition hover:scale-110"><p.icon size={20} color={p.color}/></a>); return null; })}
                        </div>
                        
                        <div className="grid grid-cols-4 gap-2 mb-2">
                             {[{ label: "Items Sold", val: profile.itemsSold || 0, onClick: () => setStatDetail('sold') }, { label: "Bought", val: profile.itemsBought || 0, onClick: () => setStatDetail('bought') }, { label: "$ Sold", val: "$" + Number(profile.totalSalesValue || 0).toFixed(2), onClick: () => setStatDetail('salesVal') }, { label: "$ Bought", val: "$" + Number(profile.totalBoughtValue || 0).toFixed(2), onClick: () => setStatDetail('boughtVal') }, { label: "Likes", val: profile.totalLikes || 0, onClick: () => setStatDetail('likes') }, { label: "Comments", val: profile.totalComments || 0, onClick: () => setStatDetail('comments') }, { label: "Badges", val: getDisplayAchievements(profile).filter(a=>a.unlocked).length, onClick: () => setShowBadges(true) }, { label: "Referrals", val: profile.referrals || 0, onClick: () => setModals({...modals, referrals:true}) }].map((s, i) => (
                                 <div key={i} onClick={s.onClick} className={`bg-black/80 border border-lime-400/50 shadow-[0_0_5px_rgba(163,230,53,0.4)] p-1 rounded text-center ${s.onClick ? 'cursor-pointer hover:bg-lime-900/40' : ''}`}><div className="text-[10px] font-bold text-lime-400">{s.val}</div><div className="text-[7px] opacity-70 uppercase leading-none text-white">{s.label}</div></div>
                             ))}
                        </div>
                        <button onClick={() => setModals({...modals, analytics: true})} className="w-full text-center text-[10px] text-cyan-400 hover:text-white mb-4 underline opacity-80">View Detailed Analytics</button>

                        <div className="flex gap-2 mt-4 justify-center md:justify-start"><Button onClick={()=>setModals({...modals, settings:true})} color="cyan" className="flex-1 text-xs flex justify-center items-center gap-2"><Settings size={14}/> Settings</Button><Button onClick={()=>setModals({...modals, socials:true})} color="purple" className="flex-1 text-xs flex justify-center items-center gap-2">My Socials</Button></div>
                        <button onClick={()=>setModals({...modals, vibeTribe:true})} className="w-full mt-2 rk-shimmer-border py-2.5 rounded-lg font-black text-sm flex justify-center items-center gap-2 active:scale-95 transition"><Users size={16} className="text-pink-400"/> 🌈 VIBE TRIBE <span className="text-[9px] bg-pink-600/40 rounded-full px-2 py-0.5">{(profile.friends||[]).length} friends</span></button>
                        
                        {/* PHASE 7: VIP Ecosystem Access */}
                        {!isEffVIP(profile) ? (
                            <div className="mt-4 p-3 bg-gradient-to-r from-yellow-500/10 to-transparent border border-yellow-500/30 rounded-xl flex items-center justify-between cursor-pointer hover:bg-yellow-500/20" onClick={() => setModals({...modals, vip: true})}>
                                <div><span className="text-[10px] font-bold text-yellow-400 block tracking-widest uppercase">Go VIP</span><span className="text-[8px] opacity-70">Radio · Themes · Banner Msgs · Post Boosts</span></div>
                                <Crown size={18} className="text-yellow-400"/>
                            </div>
                        ) : null}

                        <div className="mt-3 p-5 bg-gradient-to-r from-purple-500/10 to-transparent border border-purple-500/40 rounded-2xl">
                            <p className="text-lg font-black text-purple-300 tracking-widest uppercase mb-4 flex items-center gap-2"><Crown size={20} className="text-yellow-400"/> Subscriber Tools</p>
                            {profile?.isVIP && profile?.vipPlan === 'monthly' && profile?.vipExpires && (
                                <p className="text-[10px] text-yellow-300 mb-3">Monthly VIP active — expires {new Date(profile.vipExpires).toLocaleDateString()} · <button onClick={() => setModals({...modals, vip: true})} className="underline text-lime-300 font-bold">Renew +30 days</button></p>
                            )}
                            {profile?.vipPlan === 'expired' && !profile?.isVIP && !RK_CFG.launchPerks && (
                                <p className="text-[10px] text-red-300 mb-3">Your monthly VIP has expired. <button onClick={() => setModals({...modals, vip: true})} className="underline text-lime-300 font-bold">Renew now</button></p>
                            )}
                            {RK_CFG.launchPerks && (
                                <p className="text-[10px] text-lime-300 mb-3">🎉 Launch Perks active — VIP is free for every raver & seller commission is cut to 10%. <button onClick={() => setModals({...modals, vip: true})} className="underline">Details</button></p>
                            )}
                            <div className="grid grid-cols-2 gap-3">
                                <button onClick={() => setShowBanner(true)} className="p-4 bg-gradient-to-r from-cyan-500/10 to-transparent border border-cyan-500/30 rounded-xl text-left hover:bg-cyan-500/20 active:scale-95 transition"><span className="text-sm font-bold text-cyan-400 block uppercase tracking-widest mb-0.5">📢 Banner Msgs</span><span className="text-[11px] opacity-80">Post on the live marquee</span></button>
                                <button onClick={() => setShowBoost(true)} className="p-4 bg-gradient-to-r from-pink-500/10 to-transparent border border-pink-500/30 rounded-xl text-left hover:bg-pink-500/20 active:scale-95 transition"><span className="text-sm font-bold text-pink-400 block uppercase tracking-widest mb-0.5">⚡ Post Boosts</span><span className="text-[11px] opacity-80">Pin your item to the top</span></button>
                                <button onClick={() => setModals({...modals, font: true})} className="p-4 bg-gradient-to-r from-fuchsia-500/10 to-transparent border border-fuchsia-500/30 rounded-xl text-left hover:bg-fuchsia-500/20 active:scale-95 transition col-span-2"><span className="text-sm font-bold text-fuchsia-300 block uppercase tracking-widest mb-0.5">🔤 Font Selector</span><span className="text-[11px] opacity-80">Stylize your bio, posts, comments & messages</span></button>
                                <button onClick={() => setModals({...modals, theme: true})} className="p-4 bg-gradient-to-r from-cyan-500/10 to-transparent border border-cyan-500/30 rounded-xl text-left hover:bg-cyan-500/20 active:scale-95 transition col-span-2"><span className="text-sm font-bold text-cyan-300 block uppercase tracking-widest mb-0.5">🎨 Theme Selector</span><span className="text-[11px] opacity-80">Change your app background</span></button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div className="grid grid-cols-2 gap-4"><button onClick={() => setModals({...modals, collection:true})} className="rk-shimmer-border p-4 rounded-xl font-bold flex flex-col items-center transition active:scale-95"><Package className="text-pink-500 mb-1"/> Collection</button> <button onClick={() => setModals({...modals, inventory:true})} className="rk-shimmer-border p-4 rounded-xl font-bold flex flex-col items-center transition active:scale-95"><Box className="text-lime-400 mb-1"/> My Inventory</button> </div>

                <AchievementsCard profile={profile} editable={true} userUid={user.uid} />
                {(profile.isAdmin || profile.isKandiCreator) && <InventoryManager user={user} profile={profile}/>}
            </div>
            
            {user?.isAnonymous && !hideGuestPrompt && (
                <div className="absolute inset-0 z-50 flex flex-col items-center pt-20 bg-transparent pointer-events-auto">
                    <Card glow="primaryGlow" className="text-center p-6 m-4 w-full max-w-sm shadow-2xl bg-black/95 border border-pink-500/50 relative">
                        <button onClick={() => setHideGuestPrompt(true)} className="absolute top-3 right-3 text-white/50 hover:text-white"><XCircle size={20}/></button>
                        <Lock size={48} className="text-pink-500 mx-auto mb-4"/>
                        <h2 className="text-xl font-black mb-2 text-white uppercase italic">Account Required</h2>
                        <p className="text-xs text-white/70 mb-6">Guest accounts cannot view or edit profiles. Create a free account to unlock your DJ Name, build your collection, and manage inventory.</p>
                        <Button onClick={async () => { await signOut(auth); }} color="lime" className="w-full">Log In / Sign Up</Button>
                    </Card>
                </div>
            )}
        </div>
    );
};
EOF

# Block 17
cat << 'EOF' >> src/App.js
const AuthScreen = ({ setLoadMsg }) => {
    const [isReg, setIsReg] = useState(false);
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [djName, setDjName] = useState('');
    const [refCode, setRefCode] = useState(RK_URL_PARAMS.ref || '');
    const [loading, setLoading] = useState(false);
    const [rememberMe, setRememberMe] = useState(true);

    useEffect(() => {
        try {
            const savedEmail = localStorage.getItem('rk_auth_email');
            if(savedEmail) setEmail(savedEmail);
            localStorage.removeItem('rk_auth_pass');
        } catch (e) { /* in-app browsers may block storage — harmless */ }
        // Complete any social sign-in that used the redirect flow (in-app browsers).
        getRedirectResult(auth).catch(() => { /* redirect no longer used; swallow any stale pending-redirect error silently */ });
    }, []);
    const isInAppBrowser = (() => { try { return /Instagram|FBAN|FBAV|Messenger|TikTok|Line|Snapchat|Pinterest/i.test(navigator.userAgent || ''); } catch (e) { return false; } })();

    const handleAuth = async () => {
        // V52.1: trim whitespace — saved-password autofill often appends a stray space to
        // the email or password, which makes Firebase reject a perfectly correct login
        // with "invalid-login-credentials". Trimming fixes that class of failure.
        const cleanEmail = (email || '').trim().toLowerCase();
        const cleanPass = (password || '').trim();
        if(!cleanEmail || !cleanPass) return alert("Email and Password required");
        if(isReg && !djName) return alert("DJ Name required for registration");
        setLoading(true); setLoadMsg("Authenticating...");
        try {
            await safeSetPersistence(rememberMe);

            if (isReg) {
                // 1) Create the account FIRST — this signs the user in. (Looking up the
                //    referral code before this point ran with NO auth and was rejected by
                //    Firestore rules — that was the "Missing or insufficient permissions"
                //    error during signup whenever a referral code was entered.)
                const cred = await createUserWithEmailAndPassword(auth, cleanEmail, cleanPass);
                // 2) NOW that we're authenticated, resolve the referral code (best-effort).
                let referrerUid = null;
                if (refCode) {
                    try {
                        const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', refCode));
                        const snap = await getDocs(q);
                        if (!snap.empty) { referrerUid = snap.docs[0].id; }
                    } catch (e) { console.log('referral lookup skipped', e); }
                }
                // 3) Create the user's profile doc (+ best-effort referral credit).
                await ensureUserExists(cred.user.uid, djName, referrerUid);
            } else {
                await signInWithEmailAndPassword(auth, cleanEmail, cleanPass);
            }
            try { if (rememberMe) { localStorage.setItem('rk_auth_email', cleanEmail); } else { localStorage.removeItem('rk_auth_email'); } } catch (e) {}
        } catch(e) {
            const code = e?.code || '';
            if (code === 'auth/invalid-login-credentials' || code === 'auth/wrong-password' || code === 'auth/invalid-credential') {
                // Firebase's Email-Enumeration Protection makes fetchSignInMethodsForEmail
                // unreliable, so we DON'T guess registration from it. Most "wrong password
                // but I know it's right" cases are accounts created via Google (no password
                // exists). Offer the two real fixes: try Google, or reset the password.
                const choice = window.prompt(
                    "Login failed for " + cleanEmail + ".\n\nMost often this means:\n• Your account was created with GOOGLE (so it has no password) — close this and tap \"Continue with Google\".\n• Or the password is wrong / autofilled incorrectly.\n\nType:\n  R  → email me a password-reset link\n  G  → I'll use Google instead\n  (or Cancel)",
                    ""
                );
                if (choice && choice.trim().toUpperCase() === 'R') { doPasswordReset(cleanEmail); }
                else if (choice && choice.trim().toUpperCase() === 'G') { socialAuth('google'); }
            }
            else if (code === 'auth/email-already-in-use') { if (window.confirm("That email is already registered. Would you like to log in instead?")) { setIsReg(false); } }
            else if (code === 'auth/invalid-email') { alert("That doesn't look like a valid email address. Please check it and try again."); }
            else if (code === 'auth/weak-password') { alert("Please choose a password with at least 6 characters."); }
            else if (code === 'auth/too-many-requests') { alert("Too many attempts. Please wait a minute and try again, or reset your password."); }
            else if (code === 'auth/network-request-failed') { alert("Network issue — check your connection and try again."); }
            else { alert(e.message || "Sign-in failed. Please try again."); }
        } finally { setLoading(false); }
    };

    // V52.1: email a password-reset link. Used by the Forgot-Password link and the
    // wrong-password recovery prompt.
    const doPasswordReset = async (presetEmail) => {
        const target = (presetEmail || email || '').trim().toLowerCase();
        if (!target) { alert("Enter your email above first, then tap 'Forgot password?'"); return; }
        try {
            await sendPasswordResetEmail(auth, target);
            alert("📧 A password-reset link was sent to " + target + ".\n\n⚠️ IMPORTANT: it will most likely land in your SPAM / Junk folder (it comes from a Firebase/Google address) — check there if you don't see it in your inbox within a minute. Open the link to set a new password, then come back and log in.");
        } catch (e) {
            const c = e?.code || '';
            if (c === 'auth/user-not-found') { if (window.confirm("No account uses that email yet. Would you like to create one?")) setIsReg(true); }
            else if (c === 'auth/invalid-email') alert("That doesn't look like a valid email address.");
            else alert("Couldn't send reset email: " + (e.message || c));
        }
    };

    const guestAuth = async () => {
        setLoading(true); setLoadMsg("Entering as Guest...");
        try { await signInAnonymously(auth); }
        catch (e) { alert(e.message); } finally { setLoading(false); }
    };

    const socialAuth = async (providerName) => {
        setLoading(true); setLoadMsg("Connecting...");
        let provider;
        if (providerName === 'google') { provider = new GoogleAuthProvider(); provider.setCustomParameters({ prompt: 'select_account' }); }
        else if (providerName === 'apple') { setLoading(false); alert('Apple sign-in is coming soon! For now, please use Google or email & password.'); return; } // inert until Apple Sign-In is configured in Firebase
        else if (providerName === 'twitter') { provider = new TwitterAuthProvider(); }
        else { setLoading(false); return; }
        try {
            await safeSetPersistence(rememberMe);
            try { if (refCode) localStorage.setItem('pending_ref_code', refCode); } catch (e) {}
            // V52.0.4: ALWAYS use a popup. signInWithRedirect routes through
            // ravekandi.firebaseapp.com and fails in storage-partitioned browsers (Chrome,
            // Android webviews, in-app browsers) with a blank "missing initial state" page.
            // Popups complete on this same origin and avoid that entirely.
            await signInWithPopup(auth, provider);
            // (Success is also picked up by onAuthStateChanged, which creates the profile.)
        } catch (e) {
            const code = e?.code || '';
            if (code === 'auth/account-exists-with-different-credential') {
                alert("This email is already registered with a different sign-in method. Try that one (or email/password).");
            } else if (code === 'auth/popup-blocked' || code === 'auth/operation-not-supported-in-this-environment') {
                alert("Your browser blocked the sign-in popup. Please allow popups for this site and try again — or use email & password above.");
            } else if (code === 'auth/cancelled-popup-request' || code === 'auth/popup-closed-by-user') {
                // user closed it — no message needed
            } else if (code === 'auth/unauthorized-domain') {
                alert("This site isn't yet authorized for Google sign-in. (Admin: add the domain in Firebase Auth settings.) Please use email & password for now.");
            } else {
                alert("Sign-in couldn't complete: " + (e.message || code || 'unknown error'));
            }
        } finally { setLoading(false); }
    };

    return (
        <div className="min-h-screen bg-[#0a0014] flex flex-col items-center justify-center p-4 text-white">
            <Card glow="primaryGlow" className="w-full max-w-md p-6">
                <div className="flex justify-center mb-6"><Zap className="text-yellow-400" size={48} fill="currentColor"/></div>
                <h2 className="text-3xl font-black mb-1 text-center italic tracking-tighter" style={getTextGlowStyle('primaryGlow')}>{isReg ? 'JOIN THE RAVE' : 'WELCOME BACK'}</h2>
                <p className="text-center text-[9px] text-lime-400/70 mb-5 font-mono">build V63.03.04</p>
                
                <form onSubmit={(e) => { e.preventDefault(); handleAuth(); }} autoComplete="on">
                {isReg && <Input label="DJ Name" name="nickname" value={djName} onChange={setDjName} placeholder="TechnoViking" autoComplete="nickname" />}
                {isReg && <div>
                    <Input label="Friend UID (Optional)" value={refCode} onChange={setRefCode} placeholder="Enter Referral Code..." />
                    {RK_URL_PARAMS.ref && refCode === RK_URL_PARAMS.ref && <p className="text-[9px] text-lime-300 -mt-3 mb-3">✅ Referral auto-applied from your invite link — you and your inviter both earn RevShare!</p>}
                </div>}
                <Input label="Email" type="email" name="email" value={email} onChange={setEmail} placeholder="dj@rave.com" autoComplete={isReg ? "email" : "username"} />
                <Input label="Password" type="password" name="password" value={password} onChange={setPassword} placeholder="••••••••" autoComplete={isReg ? "new-password" : "current-password"} />
                
                <div className="mb-4 flex items-center justify-center gap-2">
                    <input type="checkbox" id="rememberMe" checked={rememberMe} onChange={e => setRememberMe(e.target.checked)} className="accent-lime-400" />
                    <label htmlFor="rememberMe" className="text-xs text-white/70 cursor-pointer">Save my info for faster login</label>
                </div>

                <Button type="submit" disabled={loading} color="lime" className="w-full mb-3 py-3">{loading ? "Processing..." : (isReg ? "Sign Up" : "Log In")}</Button>
                </form>
                {!isReg && <button onClick={() => doPasswordReset()} className="text-[11px] text-pink-300 w-full text-center hover:underline mb-3">Forgot password? Email me a reset link</button>}
                <button onClick={() => setIsReg(!isReg)} className="text-xs text-cyan-400 w-full text-center hover:underline mb-6">{isReg ? "Already have an account? Log In" : "Need an account? Sign Up"}</button>
                
                <div className="border-t border-white/20 pt-4 mb-4">
                    {isInAppBrowser && <div className="bg-amber-900/30 border border-amber-500/40 rounded-lg p-2 mb-3"><p className="text-[9px] text-amber-200 leading-relaxed">📱 You're in an in-app browser (e.g. Instagram). For the smoothest sign-in, tap the <strong>⋯ menu → "Open in Chrome/Safari"</strong> and sign in there. Email &amp; password and Google sign-in both work best in a full browser.</p></div>}
                    <p className="text-[10px] text-center opacity-50 mb-3 uppercase tracking-widest">Or {isReg ? 'sign up' : 'log in'} instantly with</p>
                    <div className="space-y-2">
                        <button onClick={() => socialAuth('google')} disabled={loading} className="w-full bg-white hover:bg-gray-100 text-gray-800 font-bold py-3 rounded-lg flex items-center justify-center gap-3 transition active:scale-[0.98] disabled:opacity-50">
                            <svg width="18" height="18" viewBox="0 0 48 48"><path fill="#FFC107" d="M43.6 20.5h-1.9V20H24v8h11.3c-1.6 4.7-6.1 8-11.3 8-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.9 1.2 8 3.1l5.7-5.7C34.6 6.1 29.6 4 24 4 12.9 4 4 12.9 4 24s8.9 20 20 20 20-8.9 20-20c0-1.3-.1-2.3-.4-3.5z"/><path fill="#FF3D00" d="M6.3 14.7l6.6 4.8C14.7 16 19 13 24 13c3.1 0 5.9 1.2 8 3.1l5.7-5.7C34.6 6.1 29.6 4 24 4 16.3 4 9.7 8.3 6.3 14.7z"/><path fill="#4CAF50" d="M24 44c5.5 0 10.5-2.1 14.3-5.6l-6.6-5.6C29.7 34.5 27 35.5 24 35.5c-5.2 0-9.6-3.3-11.3-7.9l-6.6 5.1C9.6 39.6 16.2 44 24 44z"/><path fill="#1976D2" d="M43.6 20.5H24v8h11.3c-.8 2.3-2.2 4.2-4.1 5.6l6.6 5.6C41.4 36.8 44 31 44 24c0-1.3-.1-2.3-.4-3.5z"/></svg>
                            Continue with Google
                        </button>
                        <button onClick={() => socialAuth('twitter')} disabled={loading} className="w-full bg-black hover:bg-gray-900 text-white font-bold py-3 rounded-lg flex items-center justify-center gap-3 border border-white/20 transition active:scale-[0.98] disabled:opacity-50">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
                            Continue with X
                        </button>
                    </div>
                    <p className="text-[8px] text-center opacity-40 mt-3">Secure sign-in powered by Google, Apple & X. We never see your password.</p>
                </div>
                
                <Button onClick={guestAuth} disabled={loading} color="accent" className="w-full mt-4 py-2 border-dashed">Continue as Guest</Button>
            </Card>
        </div>
    );
};
EOF

# Block 18
cat << 'EOF' >> src/App.js
const selectStyle = "w-full bg-white/10 border border-white/20 rounded p-1 text-[10px] h-7 focus:outline-none text-white";
const App = () => {
    const [page, setPage] = useState('home'); const [tab, setTab] = useState('custom');
    const [user, setUser] = useState(null); const [profile, setProfile] = useState({}); const [items, setItems] = useState([]); const [loading, setLoading] = useState(true);
    const [filters, setFilters] = useState({ postType: 'all', itemTypes: [], sort: 'recent', searchUid: '' });
    const [forceSettings, setForceSettings] = useState(false);
    const [cartOpen, setCartOpen] = useState(false);
    const [viewingProfileId, setViewingProfileId] = useState(null);
    const [creatorAppOpen, setCreatorAppOpen] = useState(false);
    const [openReferrals, setOpenReferrals] = useState(false);
    const [showAlphaModal, setShowAlphaModal] = useState(false);
    const [tutorialActive, setTutorialActive] = useState(false);
    const [tutorialPending, setTutorialPending] = useState(false);
    const [tutorialReminder, setTutorialReminder] = useState(false);
    const [showVipModal, setShowVipModal] = useState(false);
    
    // PHASE 8: Rave Radio State
    const [isRadioPlaying, setIsRadioPlaying] = useState(false);
    const [radioOpen, setRadioOpen] = useState(false);
    // V42.19 Phase 4: draggable floating radio button. Starts under the banner.
    const [radioBtnPos, setRadioBtnPos] = useState(() => { try { const s = JSON.parse(localStorage.getItem('rk_radio_btn_pos')); if (s && typeof s.x === 'number') return s; } catch (e) {} return { x: 8, y: 150 }; });
    const radioDragRef = useRef({ dragging: false, moved: false, offX: 0, offY: 0 });
    const topBarRef = useRef(null);
    const [ticketOpen, setTicketOpen] = useState(false);
    const [viewingItem, setViewingItem] = useState(null);
    const [nowPlaying, setNowPlaying] = useState(null);
    
    // PHASE 7: Global Stats Hook
    const [globalStats, setGlobalStats] = useState({ userCount: 0 });
    useEffect(() => {
        const unsub = onSnapshot(doc(db, 'artifacts', appId, 'global', 'stats'), s => { if(s.exists()) setGlobalStats(s.data()); });
        return () => unsub();
    }, []);
    // V53.2: biggest Vibe Tribe gets a banner shout-out.
    const [topTribe, setTopTribe] = useState(null);
    useEffect(() => {
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tribes')), s => {
            let best = null;
            s.docs.forEach(d => { const t = d.data(); const c = t.memberCount || (t.members || []).length; if (!best || c > best.count) best = { name: t.name, count: c }; });
            setTopTribe(best && best.count >= 2 ? best : null);
        }, e => {});
        return () => unsub();
    }, []);
    
    // V37.12: full active-time logging. Every minute the app is open is counted into a
    // local buffer, then synced to the database in ONE write per 6-hour window — all
    // session time is captured (even short sessions) without per-minute database traffic.
    useEffect(() => {
        if (!user?.uid || user.isAnonymous) return;
        const uid = user.uid;
        const bufKey = 'rk_act_buf_' + uid, openKey = 'rk_act_opens_' + uid, flushKey = 'rk_act_flush_' + uid;
        const num = (k) => parseInt(localStorage.getItem(k) || '0') || 0;
        localStorage.setItem(openKey, String(num(openKey) + 1));
        // V52.2: lightweight heartbeat — stamp lastActive every few minutes so the admin
        // directory can tell who's online now. (Separate from the 6h stats roll-up below.)
        const beat = () => { try { setDoc(doc(db, 'artifacts', appId, 'users', uid), { lastActive: Date.now() }, { merge: true }).catch(()=>{}); } catch(e){} };
        beat();
        const heartbeat = setInterval(beat, 180000); // every 3 min while app is open
        const flush = () => {
            const last = num(flushKey);
            if (last && (Date.now() - last) < 21600000) return; // stats roll-up window: 6h
            const radioKey = 'rk_radio_buf_' + uid;
            const mins = num(bufKey), opens = num(openKey), rmins = num(radioKey);
            const ref = doc(db, 'artifacts', appId, 'users', uid);
            setDoc(ref, { lastActive: Date.now(), activeMinutes: increment(mins), activeOpens: increment(opens), radioMinutes: increment(rmins) }, { merge: true })
                .then(() => { localStorage.setItem(bufKey, '0'); localStorage.setItem(openKey, '0'); localStorage.setItem(radioKey, '0'); localStorage.setItem(flushKey, String(Date.now())); })
                .catch(() => {});
        };
        flush();
        const tick = setInterval(() => { localStorage.setItem(bufKey, String(num(bufKey) + 1)); flush(); }, 60000);
        return () => { clearInterval(tick); clearInterval(heartbeat); };
    }, [user]);

    const syncMsgs = ["Synching Posts...", "Loading Creations...", "PLUR'ing the Posts", "💕 Catching a Vibe 🌈", "Finding the Gear 👕", "Locating Art 🎨"];
    const [syncMsgIdx, setSyncMsgIdx] = useState(0);
    const [isSyncing, setIsSyncing] = useState(true);

    const [loadPct, setLoadPct] = useState(0);
    const [loadMsg, setLoadMsg] = useState('Initializing RaveKandi OS...');

    useEffect(() => {
        if(page === 'feed' && isSyncing) {
            const int = setInterval(() => setSyncMsgIdx(prev => (prev + 1) % syncMsgs.length), 2000);
            return () => clearInterval(int);
        }
    }, [page, isSyncing]);

    const manualRefresh = () => { setIsSyncing(true); setTimeout(() => setIsSyncing(false), 1500); };

    useEffect(() => {
        const intRefresh = setInterval(() => manualRefresh(), 15000);
        return () => clearInterval(intRefresh);
    }, []);

    useEffect(() => {
        const msgs = ["Reticulating Splines...", "Sorting Kandi Beads by color...", "Tuning the Bass to 140BPM...", "Finding the PLUR...", "Waking up the AI Kandi Maker...", "Untangling Elastic String...", "Checking VIP guest list...", "Applying neon paint..."];
        let p = 0;
        const intLoad = setInterval(() => {
            p += Math.floor(Math.random() * 15) + 5;
            if(p > 99) p = 99;
            setLoadPct(p);
            if(Math.random() > 0.4) setLoadMsg(msgs[Math.floor(Math.random() * msgs.length)]);
        }, 300);

        const unsubAuth = onAuthStateChanged(auth, async (u) => { 
            setUser(u); 
            if(u && !u.isAnonymous) { 
                let rUid = null;
                let savedRef = null;
                try { savedRef = localStorage.getItem('pending_ref_code'); } catch (e) {}
                if (savedRef) {
                    try {
                        const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', savedRef));
                        const snap = await getDocs(q);
                        if (!snap.empty) { rUid = snap.docs[0].id; }
                    } catch (e) {}
                    try { localStorage.removeItem('pending_ref_code'); } catch (e) {}
                }
                ensureUserExists(u.uid, null, rUid); 
            } 
            if(u) { try{ await SplashScreen.hide(); }catch(e){} }
        });
        setTimeout(() => { 
            clearInterval(intLoad); setLoadPct(100); setLoadMsg("Ready to Rave!");
            if (localStorage.getItem('hideAlphaWarning') !== 'true') setShowAlphaModal(true);
            // V60: tutorial gating. New signed-in users get the guided tutorial (after the
            // alpha modal closes). Users who've already seen it get a one-time reminder that
            // it lives in Settings.
            if (user && !user.isAnonymous) {
                if (localStorage.getItem('rk_tutorial_done') !== 'true') { setTutorialPending(true); }
                else if (localStorage.getItem('rk_tut_reminder_seen') !== 'true') { setTutorialReminder(true); localStorage.setItem('rk_tut_reminder_seen', 'true'); }
            }
            setTimeout(() => setLoading(false), 200); 
        }, 2500);
        return () => { clearInterval(intLoad); unsubAuth(); };
    }, []);

    // V60: replay the tutorial from scratch (used by the Settings button).
    const replayTutorial = () => {
        try { localStorage.removeItem('rk_tutorial_done'); } catch (e) {}
        setPage('home');
        setTutorialReminder(false);
        setTimeout(() => setTutorialActive(true), 250);
    };

    useEffect(() => { if(!user || user.isAnonymous) return; const unsub = onSnapshot(doc(db, 'artifacts', appId, 'users', user.uid), s => setProfile(s.data() || {})); return () => unsub(); }, [user]);
    
    // V37.10 FEED SYNC FIX: the feed listener now attaches only AFTER auth resolves and
    // re-attaches whenever the user changes. Previously it attached pre-auth on fresh
    // installs; if Firestore rejected the unauthenticated read, the listener died silently
    // and old posts (including official merch) never loaded. Includes auto-retry on errors.
    const [feedRetry, setFeedRetry] = useState(0);
    useEffect(() => { 
        if (!user) return;
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems')), s => {
            setItems(s.docs.map(d => ({...d.data(), id: d.id})));
            setIsSyncing(false);
        }, err => {
            console.error('Feed listener error, retrying in 4s...', err);
            setTimeout(() => setFeedRetry(r => r + 1), 4000);
        });
        const timeout = setTimeout(() => setIsSyncing(false), 10000);
        return () => { unsub(); clearTimeout(timeout); };
    }, [user, feedRetry]);

    // V37.12: User Directory for the feed "User Profiles" mode
    const [usersDir, setUsersDir] = useState([]);
    useEffect(() => {
        // Load the directory for User Profiles mode OR whenever there's a search term
        // (so user cards can appear under "All" search too). V42.16 Phase 2.
        const hasSearch = (filters.searchUid || '').trim().length >= 2;
        if (page !== 'feed' || !user || (filters.postType !== 'users' && !hasSearch)) return;
        getDocs(query(collection(db, 'artifacts', appId, 'users'), orderBy('joined', 'desc'), limit(50)))
            .then(s => setUsersDir(s.docs.map(d => ({ ...d.data(), id: d.id }))))
            .catch(e => console.log('User dir load failed', e));
    }, [page, filters.postType, filters.searchUid, user]);
    useEffect(() => {
        // Exact UID/username lookup so a searched raver who isn't in the recent-50
        // directory still surfaces. Runs for any post type when searching.
        const term = (filters.searchUid || '').trim();
        if (page !== 'feed' || term.length < 3) return;
        const t = setTimeout(async () => {
            try {
                let snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', term)));
                if (snap.empty) snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('displayName', '==', term)));
                if (!snap.empty) setUsersDir(prev => { const found = { ...snap.docs[0].data(), id: snap.docs[0].id }; return prev.some(p => p.id === found.id) ? prev : [found, ...prev]; });
            } catch (e) {}
        }, 600);
        return () => clearTimeout(t);
    }, [filters.searchUid, page]);

    // V37.12: live marquee leaderboards (top seller / RevShare earner / referrer)
    const [topStats, setTopStats] = useState({});
    useEffect(() => {
        if (!user) return;
        const pull = async () => {
            try {
                const grab = async (field) => { const s = await getDocs(query(collection(db, 'artifacts', appId, 'users'), orderBy(field, 'desc'), limit(1))); return s.empty ? null : { ...s.docs[0].data(), id: s.docs[0].id }; };
                const [seller, earner, referrer, buyer, active, listener, ach, creator] = await Promise.all([grab('totalSalesValue'), grab('totalRevShareEarned'), grab('referrals'), grab('itemsBought'), grab('activeMinutes'), grab('radioMinutes'), grab('achievementsUnlocked'), grab('creatorPoints')]);
                setTopStats({ seller, earner, referrer, buyer, active, listener, ach, creator });
            } catch (e) { console.log('Marquee stats unavailable', e); }
        };
        pull();
        const int = setInterval(pull, 300000);
        return () => clearInterval(int);
    }, [user]);

    // V37.13: unique view registration — fires the moment a post is opened. One view per
    // UID forever (viewedBy ledger), never the owner. Optimistic local bump so the count
    // visibly updates instantly, with a merge-write fallback if the update is rejected.
    useEffect(() => {
        const it = viewingItem;
        if (!it || !user?.uid) return;
        if (user.uid === it.ownerId) return;
        if (it.viewedBy?.includes(user.uid)) return;
        setItems(prev => prev.map(p => p.id === it.id ? { ...p, viewCount: (p.viewCount || 0) + 1, viewedBy: [...(p.viewedBy || []), user.uid] } : p));
        const ref = doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', it.id);
        updateDoc(ref, { viewCount: increment(1), viewedBy: arrayUnion(user.uid) })
            .catch(() => { /* item isn't in public tradeItems (e.g. private AI creation) — view count not tracked there; ignore quietly */ });
    }, [viewingItem, user]);

    // V37.12: fairness window — auto-release pending requests whose priority window expired
    const releasedRef = useRef(new Set());
    useEffect(() => {
        items.filter(i => i.requestStatus === 'pending' && i.idleExpiresAt && Date.now() > i.idleExpiresAt && !releasedRef.current.has(i.id))
            .forEach(i => { releasedRef.current.add(i.id); updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', i.id), { requestStatus: 'awaiting_assignment', autoReleasedAt: Date.now() }).catch(()=>{}); });
    }, [items]);

    // V37.13: Messenger — live threads + notifications (powers the header badge too)
    const [msgOpen, setMsgOpen] = useState(false);
    const [msgTarget, setMsgTarget] = useState(null);
    const [threads, setThreads] = useState([]);
    const [notifs, setNotifs] = useState([]);
    useEffect(() => {
        if (!user?.uid) return;
        const tq = query(collection(db, 'artifacts', appId, 'public', 'data', 'threads'), where('participants', 'array-contains', user.uid));
        const u1 = onSnapshot(tq, s => setThreads(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('threads', e));
        const nq = query(collection(db, 'artifacts', appId, 'users', user.uid, 'notifications'), orderBy('at', 'desc'), limit(60));
        const u2 = onSnapshot(nq, s => setNotifs(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('notifs', e));
        return () => { u1(); u2(); };
    }, [user]);

    // V37.14: VIP banner & boost slot feeds + minute ticker for window math + merch popup
    const [bannerSlots, setBannerSlots] = useState([]);
    const [boostSlots, setBoostSlots] = useState([]);
    const [nowTick, setNowTick] = useState(Date.now());
    const [merchPopup, setMerchPopup] = useState(false);
    const [videoSubmitOpen, setVideoSubmitOpen] = useState(false);
    const [videoSlotsForSubmit, setVideoSlotsForSubmit] = useState([]);
    useEffect(() => {
        if (!videoSubmitOpen) return;
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'videoSlots')), s => setVideoSlotsForSubmit(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log(e));
        return () => unsub();
    }, [videoSubmitOpen]);
    useEffect(() => {
        if (!user) return;
        const u3 = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'bannerSlots')), s => setBannerSlots(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('banners', e));
        const u4 = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'boostSlots')), s => setBoostSlots(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('boosts', e));
        return () => { u3(); u4(); };
    }, [user]);
    useEffect(() => { const t = setInterval(() => setNowTick(Date.now()), 30000); return () => clearInterval(t); }, []);
    useEffect(() => {
        if (page === 'shop' && tab === 'official') {
            try { if (localStorage.getItem('rk_hide_merch_popup') !== '1') setMerchPopup(true); } catch (e) { setMerchPopup(true); }
        }
    }, [page, tab]);

    // V42.09: monthly VIP enforcement — auto-downgrade the moment the paid window ends.
    // Re-checks every 30s via nowTick while the app is open and on every fresh launch.
    useEffect(() => {
        if (!user?.uid || !profile?.isVIP) return;
        if (profile.vipPlan === 'monthly' && profile.vipExpires && Date.now() > profile.vipExpires) {
            setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { isVIP: false, vipPlan: 'expired' }, { merge: true }).catch(() => {});
            pushNotif(user.uid, 'admin', '👑 Your VIP monthly subscription has expired — renew anytime to restore 6 Profile Pins, Themes, Banner Messages & Post Boosts. (Your first 3 pins stay free!)');
        }
    }, [user, profile?.isVIP, profile?.vipPlan, profile?.vipExpires, nowTick]);

    // V42.11: remote config — admin-controlled kill switches, maintenance & version gate
    const [rkConfig, setRkConfig] = useState(RK_CFG);
    useEffect(() => {
        const unsub = onSnapshot(doc(db, 'artifacts', appId, 'global', 'config'), s => {
            if (s.exists()) { const c = { ...RK_CFG, ...s.data() }; RK_CFG = c; setRkConfig(c); }
        }, e => console.log('config', e));
        return () => unsub();
    }, []);

    // V60/V61: start the pending tutorial only once the alpha modal AND any forced pop-in are
    // dismissed, so the guided tour never overlaps the launch sequence. (Declared after
    // rkConfig to avoid a temporal-dead-zone crash.)
    useEffect(() => {
        if (!tutorialActive && tutorialPending) {
            let popInUp = false;
            try { popInUp = !!(rkConfig?.popInActive && rkConfig?.popInId && !(rkConfig.popInExpiry > 0 && Date.now() > rkConfig.popInExpiry) && localStorage.getItem('rk_popin_seen') !== rkConfig.popInId); } catch (e) {}
            if (!showAlphaModal && !popInUp) {
                const t = setTimeout(() => { setTutorialActive(true); setTutorialPending(false); }, 400);
                return () => clearTimeout(t);
            }
        }
    }, [tutorialPending, showAlphaModal, rkConfig, tutorialActive]);
    // V52.2: count this device as a unique visitor (once ever) + daily-active ping.
    useEffect(() => { trackUniqueVisit(); }, []);

    // V42.16: any browser-tab user (iOS or Android) who hasn't installed gets a one-time
    // guide to add RaveKandi to their home screen as an app.
    const [iosGuide, setIosGuide] = useState(false);
    const [helpOpen, setHelpOpen] = useState(false);
    useEffect(() => {
        if (IS_STANDALONE) return; // already installed — never nag
        try { if (localStorage.getItem('rk_ios_a2hs') !== '1') setIosGuide(true); } catch (e) { setIosGuide(true); }
    }, []);

    // V42.21 Phase 6: if opened via a shared item link (?item=ID), open that item once
    // the feed has loaded. One-shot via a ref so it doesn't reopen on every render.
    const itemDeepLinkRef = useRef(false);
    useEffect(() => {
        if (itemDeepLinkRef.current || !RK_URL_PARAMS.item || !items || items.length === 0) return;
        const found = items.find(i => i.id === RK_URL_PARAMS.item);
        if (found) { itemDeepLinkRef.current = true; setViewingItem(found); }
    }, [items]);

    // V37.13: self-sync computed stats so the marquee leaderboards can query them,
    // and self-notify on newly unlocked achievements.
    useEffect(() => {
        if (!user?.uid || user.isAnonymous || !profile?.joined) return;
        const unlocked = getDisplayAchievements(profile).filter(a => a.unlocked).length;
        const pts = profile.isKandiCreator ? Math.round((profile.itemsSold || 0) * 5 + (profile.totalSalesValue || 0) * 0.5 + (profile.totalLikes || 0) + (profile.completedTrades || 0) * 3) : 0;
        const upd = {};
        if ((profile.achievementsUnlocked || 0) !== unlocked) upd.achievementsUnlocked = unlocked;
        if ((profile.creatorPoints || 0) !== pts) upd.creatorPoints = pts;
        if (Object.keys(upd).length === 0) return;
        if (unlocked > (profile.achievementsUnlocked || 0) && (profile.achievementsUnlocked !== undefined)) pushNotif(user.uid, 'achievement', '🏅 You unlocked a new achievement! (' + unlocked + ' total)');
        setDoc(doc(db, 'artifacts', appId, 'users', user.uid), upd, { merge: true }).catch(() => {});
    }, [user, profile?.itemsSold, profile?.totalSalesValue, profile?.totalLikes, profile?.completedTrades, profile?.isKandiCreator, profile?.joined]);

    // V42.23 Phase 7: PERMANENT early-adopter VIP. While Launch Perks are ON, grant every
    // active raver real lifetime VIP exactly once. Because this writes isVIP:true (not just
    // relying on the launchPerks flag), turning perks OFF later keeps these users VIP forever.
    useEffect(() => {
        if (!user?.uid || user.isAnonymous || !profile?.joined) return;
        if (!RK_CFG.launchPerks) return;           // only grant during the free period
        if (profile.isVIP && profile.lifetimeVipGranted) return; // already locked in
        setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { isVIP: true, vipPlan: 'lifetime', lifetimeVipGranted: true, vipSince: profile.vipSince || Date.now(), vipExpires: null }, { merge: true })
            .then(() => { if (!profile.lifetimeVipGranted) pushNotif(user.uid, 'admin', '🎉 Early Adopter perk: your VIP is now PERMANENT — Radio, Themes, Banners, Boosts & Font Selector are yours forever, even after launch pricing returns. PLUR! 💖'); })
            .catch(() => {});
    }, [user, profile?.joined, profile?.isVIP, profile?.lifetimeVipGranted]);

    // V47 Stage E: PERMANENT launch commission lock-in. While Launch Perks are ON, lock every
    // active user to a 10% (or lower, if they have a better custom rate) commission FOREVER.
    // Writing lockedCommissionRate means turning perks OFF later keeps launch users at 10%,
    // while users who join AFTER perks are off get no lock and pay the standard 20%.
    useEffect(() => {
        if (!user?.uid || user.isAnonymous || !profile?.joined) return;
        if (!RK_CFG.launchPerks) return;                 // only lock in during the launch period
        if (profile.commissionLockedIn) return;          // already locked
        const lockRate = Math.min(0.10, (profile.customCommissionRate !== null && profile.customCommissionRate !== undefined) ? profile.customCommissionRate : 0.10);
        setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { lockedCommissionRate: lockRate, commissionLockedIn: true, commissionLockedAt: Date.now() }, { merge: true })
            .then(() => pushNotif(user.uid, 'admin', '🔒 Early Adopter perk: your seller commission is now LOCKED at ' + (lockRate * 100).toFixed(0) + '% forever — even after launch ends and new sellers move to 20%. PLUR! 💖'))
            .catch(() => {});
    }, [user, profile?.joined, profile?.commissionLockedIn]);

    // V37.13: Crowned Creator — permanent unlock when you hit #1 on Creator Points
    useEffect(() => {
        if (!user?.uid || !topStats.creator) return;
        if (topStats.creator.id === user.uid && (topStats.creator.creatorPoints || 0) > 0 && !profile?.topCreatorUnlocked) {
            setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { topCreatorUnlocked: 1 }, { merge: true }).catch(() => {});
            pushNotif(user.uid, 'achievement', '👑 CROWNED CREATOR unlocked — you are the #1 Creator on RaveKandi! This badge is yours forever.');
        }
    }, [topStats, user, profile?.topCreatorUnlocked]);
    
    const addToCart = async (i) => { 
        if(!user?.uid) return; 
        if(user.isAnonymous) { alert("Please create an account to purchase items."); return; }
        const { id: _srcId, ...cartPayload } = i; await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'cart'), { ...cartPayload, addedAt: Date.now(), originalId: i.id }); if (i.ownerId && i.ownerId !== user.uid) pushNotif(i.ownerId, 'cart', (profile?.displayName || 'A raver') + ' added "' + i.name + '" to their cart', i.id); alert("Added to Cart!"); 
    };
    
    const handleViewItem = (item) => { setViewingItem(item); };

    // V42.10: homepage promo-video callout — opens a DM straight to the admin team
    const contactAdmin = async () => {
        try {
            const s = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('isAdmin', '==', true), limit(1)));
            if (s.empty) return alert('No admin account is set up yet — use the Feedback button below instead!');
            const a = { id: s.docs[0].id, ...s.docs[0].data() };
            setMsgTarget({ uid: a.id, name: a.displayName || 'RaveKandi Admin' });
            setMsgOpen(true);
        } catch (e) { alert('Could not reach the admin directory: ' + e.message); }
    };
    
    const handleViewFeed = (targetUid) => {
        if (items.length === 0 || isSyncing) { alert("Posts are currently syncing. Please wait a moment."); return; }
        setFilters({...filters, searchUid: targetUid});
        setPage('feed');
    };

    // V42.15.03 FIX: these hooks MUST run on every render. They were below the
    // early returns (loading/!user/ban), so hook count changed once loading
    // finished → React #310 crash on launch, every platform. Moved above guards.
    const [textScale, setTextScale] = useState(() => { try { return parseFloat(localStorage.getItem('rk_text_scale')) || 1; } catch (e) { return 1; } });
    useEffect(() => {
        const handler = (e) => { if (e.detail) { setTextScale(e.detail); try { localStorage.setItem('rk_text_scale', String(e.detail)); } catch (er) {} } };
        window.addEventListener('rk-text-scale', handler);
        return () => window.removeEventListener('rk-text-scale', handler);
    }, []);
    
    if(loading) return ( <div className="fixed inset-0 bg-[#0a0014] flex flex-col items-center justify-center p-8 z-[9999]"><h1 className="text-7xl font-black mb-8 animate-pulse text-center" style={getTextGlowStyle('primaryGlow')}>RAVEKANDI</h1><div className="w-full max-w-xs text-center"><LoadingBar progress={loadPct} className="h-2"/><p className="text-lime-400 font-mono text-lg mt-3 font-bold">{loadPct}%</p><p className="text-pink-400 text-sm mt-2 animate-bounce">{loadMsg}</p></div></div> );
    if(!user) return <AuthScreen setLoadMsg={setLoadMsg} />;

    const banActive = profile?.bannedUntil && (profile.bannedUntil === 'permanent' || profile.bannedUntil > Date.now());
    if (banActive) return (
        <div className="fixed inset-0 bg-[#0a0014] flex flex-col items-center justify-center p-8 text-center z-[9999]">
            <Lock size={64} className="text-red-500 mb-6"/>
            <h1 className="text-3xl font-black text-red-500 uppercase italic mb-3">Account Suspended</h1>
            <p className="text-sm text-white mb-2">{profile.bannedUntil === 'permanent' ? 'Your account has been permanently banned.' : `Your account is suspended until ${new Date(profile.bannedUntil).toLocaleString()}.`}</p>
            {profile.banReason && <p className="text-xs text-white/60 mb-6">Reason: {profile.banReason}</p>}
            <Button onClick={async () => { await signOut(auth); }} color="accent" className="px-8">Log Out</Button>
        </div>
    );
    
    const filteredItems = items.filter(i => {
        if(i.status === 'pending' || i.status === 'request') return false; 
        if(i.isDIYRequest || i.isRequest) return false; 
        if(filters.searchUid && i.ownerPublicUid !== filters.searchUid && i.ownerId !== filters.searchUid) return false;
        if(filters.postType === 'official' && !i.isAppProduct) return false;
        if(filters.itemTypes.length > 0 && !filters.itemTypes.includes(i.type || 'Other')) return false;
        return true;
    }).sort((a, b) => {
        if (filters.sort === 'recent') return b.timestamp - a.timestamp;
        if (filters.sort === 'popular') return (b.likes?.length || 0) - (a.likes?.length || 0);
        if (filters.sort === 'priceHigh') return b.price - a.price;
        if (filters.sort === 'priceLow') return a.price - b.price;
        if (filters.sort === 'commented') return (b.comments?.length || 0) - (a.comments?.length || 0);
        if (filters.sort === 'viewed') return (b.viewCount || 0) - (a.viewCount || 0);
        return 0;
    });
    
    const officialItems = items.filter(i => i.isAppProduct && i.status === 'approved').sort((a,b)=>b.timestamp - a.timestamp);

    const uTerm = (filters.searchUid || '').toLowerCase();
    const visibleUsers = usersDir.filter(u => !uTerm || (u.displayName || '').toLowerCase().includes(uTerm) || (u.publicUid || u.id || '').toLowerCase().includes(uTerm));

    // V37.14: marquee data — entries are {t, uid} so user references are tappable links
    const mqTotalSales = items.reduce((s, i) => s + ((i.price || 0) * (i.purchaseCount || 0)), 0);
    const mqItemsListed = items.filter(i => !i.isRequest && !i.isDIYRequest).length;
    const mqCommission = mqTotalSales * effCommissionRate(null);
    const topPoster = (() => { const c = {}; items.forEach(i => { if (i.ownerName && !i.isRequest && !i.isDIYRequest) { c[i.ownerName] = c[i.ownerName] || { n: 0, uid: i.ownerPublicUid || i.ownerId }; c[i.ownerName].n++; } }); const e = Object.entries(c).sort((a, b) => b[1].n - a[1].n)[0]; return e ? { name: e[0], n: e[1].n, uid: e[1].uid } : null; })();
    const RAVE_EMOJIS = ['🤘😝 ROCK ON RAVER', '🪩✨ DISCO MODE ENGAGED', '🌈🤝 TRADE THE VIBE', '🔊🦄 BASS UNICORN SPOTTED', '😎🕺 GROOVE SECURED', '🫶💚 KANDI LOVE', '👽🎛️ ALIEN ON THE DECKS', '🍄⚡ MUSH MODE', '🧚‍♀️🔥 FAIRY ON FIRE', '🐸🎧 BASS FROG VIBES', '🦋💜 FLUTTER & FLOW', '🥽🌌 GOGGLES TO THE GALAXY', '💞🔆 SPREAD THE PLUR', '🎶🌟 LOST IN THE MUSIC', '🤝✨ HANDSHAKE = NEW FAMILY', '🌈🦋 STAY KANDi, STAY KIND', '🔥💃 MELT INTO THE BEAT', '🫂💖 HUG A RAVER TODAY', '⚡🧡 ENERGY NEVER DIES', '🪩💫 ONE LOVE, ONE DANCEFLOOR', '🌸🎀 KANDI KID FOREVER', '🛸💚 VIBE TRIBE ASSEMBLE', '🎆🌀 FEEL THE FREQUENCY', '💜🔊 BASS IN YOUR HEART'];
    const plurLine = (() => {
        const A = ['PLUR', 'Peace', 'Love', 'Unity', 'Respect', 'Good vibes', 'Kandi magic', 'The bassline', 'Your aura', 'The rave fam', 'Kindness', 'The melody', 'Pure joy', 'The drop', 'Your energy', 'The afterglow', 'Festival magic', 'The rhythm', 'Every heartbeat', 'The light show'];
        const B = ['recharges', 'heals', 'uplifts', 'connects', 'electrifies', 'glows through', 'amplifies', 'protects', 'inspires', 'unites', 'lifts up', 'carries', 'celebrates', 'embraces', 'awakens', 'ignites', 'soothes', 'empowers', 'flows through', 'illuminates'];
        const C = ['the dancefloor', 'every raver', 'your crew', 'the night', 'the universe', 'all of us', 'strangers into family', 'the main stage', 'your spirit', 'the kandi kids', 'the whole crowd', 'this moment', 'the sunrise set', 'your festival fam', 'the bass heads', 'the glow sticks', 'the trade circle', 'the wandering souls', 'the front row', 'the silent disco'];
        const E = ['💖', '🌈', '✨', '⚡', '🪩', '🫶', '🔮', '🌀'];
        const s = Math.floor(Date.now() / 600000);
        return E[s % E.length] + ' ' + A[s % A.length].toUpperCase() + ' ' + B[(s * 7 + 3) % B.length].toUpperCase() + ' ' + C[(s * 13 + 5) % C.length].toUpperCase() + ' ' + E[(s * 3 + 1) % E.length];
    })();
    const uref = (x) => x ? (x.publicUid || x.id) : null;
    const activeBanner = bannerSlots.find(s => s.start <= nowTick && nowTick < s.end) || null;
    const mq = [
        activeBanner ? { t: (activeBanner.linkUrl ? '🔗 @' : '📢 @') + (activeBanner.name || 'VIP') + ': ' + activeBanner.text + (activeBanner.linkUrl ? ' 🔗' : ' 📢'), uid: activeBanner.linkUrl ? null : (activeBanner.ownerPublicUid || activeBanner.uid), href: activeBanner.linkUrl || null, slotId: activeBanner.id } : null,
        { t: '⚡ GLOBAL VOLUME: ' + (globalStats.userCount * 1337) + ' KANDI ⚡' },
        { t: '🚀 ACTIVE RAVERS: ' + globalStats.userCount + ' 🚀' },
        topTribe ? { t: '🌈 BIGGEST VIBE TRIBE: "' + topTribe.name + '" with ' + topTribe.count + ' members! 🌈' } : null,
        { t: '💰 TOTAL PLATFORM SALES: $' + mqTotalSales.toFixed(2) },
        { t: '🧾 COMMISSION POOL: $' + mqCommission.toFixed(2) },
        { t: '📦 ITEMS LISTED: ' + mqItemsListed },
        topStats.seller && (topStats.seller.totalSalesValue > 0) ? { t: '🏆 TOP SELLER: @' + topStats.seller.displayName + ' ($' + Number(topStats.seller.totalSalesValue || 0).toFixed(0) + ' SOLD)', uid: uref(topStats.seller) } : null,
        topStats.earner && (topStats.earner.totalRevShareEarned > 0) ? { t: '💎 TOP REVSHARE EARNER: @' + topStats.earner.displayName + ' ($' + Number(topStats.earner.totalRevShareEarned || 0).toFixed(2) + ')', uid: uref(topStats.earner) } : null,
        topStats.referrer && (topStats.referrer.referrals > 0) ? { t: '🤝 MOST REFERRALS: @' + topStats.referrer.displayName + ' (' + topStats.referrer.referrals + ')', uid: uref(topStats.referrer) } : null,
        topPoster ? { t: '📣 TOP POSTER: @' + topPoster.name + ' (' + topPoster.n + ' posts)', uid: topPoster.uid } : null,
        topStats.creator && (topStats.creator.creatorPoints > 0) ? { t: '👑 TOP CREATOR: @' + topStats.creator.displayName + ' (' + topStats.creator.creatorPoints + ' PTS)', uid: uref(topStats.creator) } : null,
        topStats.active && ((topStats.active.activeMinutes || 0) > 0) ? { t: '🔥 MOST ACTIVE: @' + topStats.active.displayName + ' (' + (((topStats.active.activeMinutes || 0) / 60) + (topStats.active.activeHours || 0)).toFixed(1) + ' HRS)', uid: uref(topStats.active) } : null,
        topStats.listener && ((topStats.listener.radioMinutes || 0) > 0) ? { t: '🎧 TOP LISTENER: @' + topStats.listener.displayName + ' (' + ((topStats.listener.radioMinutes || 0) / 60).toFixed(1) + ' HRS)', uid: uref(topStats.listener) } : null,
        topStats.buyer && ((topStats.buyer.itemsBought || 0) > 0) ? { t: '🛍️ HIGHEST ORDERS: @' + topStats.buyer.displayName + ' (' + topStats.buyer.itemsBought + ')', uid: uref(topStats.buyer) } : null,
        topStats.ach && ((topStats.ach.achievementsUnlocked || 0) > 0) ? { t: '🏅 MOST ACHIEVEMENTS: @' + topStats.ach.displayName + ' (' + topStats.ach.achievementsUnlocked + ')', uid: uref(topStats.ach) } : null,
        topStats.seller && (topStats.seller.totalSalesValue > 0) ? { t: '📈 HIGHEST NET PROFIT: @' + topStats.seller.displayName + ' ($' + (Number(topStats.seller.totalSalesValue || 0) * (1 - effCommissionRate(topStats.seller.customCommissionRate))).toFixed(2) + ')', uid: uref(topStats.seller) } : null,
        { t: RAVE_EMOJIS[Math.floor(Date.now() / 60000) % RAVE_EMOJIS.length] },
        { t: plurLine },
        { t: '💖 PLUR FACT: Handshakes end with a trade! 💖' },
        { t: '🤝 PLUR FACT: Peace, Love, Unity & Respect — the rave code 🤝' },
        { t: '🌈 PLUR TIP: Check on the raver sitting alone — make a friend 🌈' },
        { t: '💧 STAY HYDRATED & LOOK OUT FOR YOUR CREW 💧' },
        { t: '🫶 KINDNESS IS THE BEST ACCESSORY 🫶' },
        { t: '✨ TRADE KANDI, TRADE LOVE, NEVER TRADE YOUR SAFETY ✨' },
        { t: '🦋 BE SOMEONE\'S REASON TO SMILE TONIGHT 🦋' },
    ].filter(Boolean);

    // V37.14: boosted posts — pinned to the top 5 feed slots during their hour window
    const activeBoosts = boostSlots.filter(s => s.start <= nowTick && nowTick < s.end).sort((a, b) => (a.start - b.start) || ((a.lane || 0) - (b.lane || 0))).slice(0, 5);
    const boostRank = new Map(activeBoosts.map((s, i) => [s.itemId, i]));
    const displayedFeedItems = filteredItems.map(i => boostRank.has(i.id) ? { ...i, _boosted: true } : i).sort((a, b) => { const ra = boostRank.has(a.id) ? boostRank.get(a.id) : 99; const rb = boostRank.has(b.id) ? boostRank.get(b.id) : 99; return ra - rb; });

    const unreadMsgs = threads.reduce((s, t) => s + ((t.unread && t.unread[user?.uid]) || 0), 0);
    const unreadNotifs = notifs.filter(n => !n.read).length;
    const inboxBadge = unreadMsgs + unreadNotifs;
    
    const WelcomeAlphaModal = () => {
        if(!showAlphaModal) return null;
        const facts = ["PLUR stands for Peace, Love, Unity, Respect!", "Kandi trading originated in the 90s rave scene.", "Neon colors glow under UV light because of phosphors!", "The PLUR handshake ends with a bracelet trade."];
        const fact = facts[Math.floor(Math.random() * facts.length)];
        return (
            <div className="fixed inset-0 bg-black/95 z-[999] flex items-center justify-center p-4">
                <div className="bg-yellow-500/10 border-4 border-dashed border-yellow-500 p-6 rounded-xl text-center space-y-4 shadow-[0_0_40px_rgba(234,179,8,0.3)] max-w-sm w-full">
                    <AlertTriangle size={48} className="text-yellow-400 mx-auto mb-2 animate-pulse"/>
                    <h2 className="text-xl font-black text-yellow-400 uppercase tracking-widest bg-black/50 p-2 rounded">RaveKandi Alpha</h2>
                    <p className="text-xs font-mono text-white/50 mb-4">V63.03.04</p>
                    <p className="text-sm text-white leading-relaxed">We are currently in active Alpha Development. Please be aware that functions may break, load slowly, or spontaneously shift as we build the ecosystem.</p>
                    <div className="bg-red-900/30 border border-red-500/50 p-3 rounded text-left">
                        <p className="text-[10px] text-red-300 leading-relaxed font-bold uppercase mb-1">⚠ Payments: Test Mode</p>
                        <p className="text-[10px] text-white/80 leading-relaxed">The payment system is currently in <strong>TEST MODE</strong> and all transactions cannot be processed. If a glitch or bug allows a transaction to be processed, you may not receive the items or may experience issues as a result. The payment system will be removed from test mode after rollout from Alpha to Beta.</p>
                    </div>
                    <p className="text-sm font-black text-pink-400 italic py-2">Thank you for being part of our beginnings! 💖</p>
                    <div className="bg-black/60 p-3 rounded text-[10px] italic text-cyan-400 border border-cyan-500/30">Fun Fact: {fact}</div>
                    <Button onClick={() => { localStorage.setItem('hideAlphaWarning', 'true'); setShowAlphaModal(false); }} color="lime" className="w-full mt-4">Acknowledge & Enter</Button>
                </div>
            </div>
        );
    };
EOF

# Block 19
cat << 'EOF' >> src/App.js
    const bgUrl = isEffVIP(profile) ? profile.customBackground : null;
    // V59.2: video wallpapers are enabled ONLY for hosted URLs (a pasted .mp4/.webm link
    // streams from the USER's own host — zero bandwidth cost to us). We deliberately do NOT
    // support data:video (embedded/uploaded video) as a background, so no large video file
    // ever lands in our Firebase Storage/Firestore. Image backgrounds work via upload or URL.
    const isHostedVideoUrl = typeof bgUrl === 'string' && /^https?:\/\/.+\.(mp4|webm|mov|m4v)(\?|$)/i.test(bgUrl);
    const isVideoBg = !!(bgUrl && isHostedVideoUrl);
    const isImageBg = bgUrl && !isHostedVideoUrl && !(typeof bgUrl === 'string' && bgUrl.startsWith('data:video'));
    const appBackgroundStyle = isImageBg ? { backgroundImage: `url(${bgUrl})`, backgroundSize: 'cover', backgroundPosition: 'center', backgroundAttachment: 'fixed', fontSize: (textScale * 100) + '%' } : { backgroundColor: '#0f001e', fontSize: (textScale * 100) + '%' };
    // V59: hide the scrolling marquee when an admin banner is set to "announce only" mode.
    const bannerMsgActive = rkConfig.maintenanceMessage && !(rkConfig.maintenanceExpiry > 0 && Date.now() > rkConfig.maintenanceExpiry);
    const hideMarquee = rkConfig.bannerAnnounceOnly && bannerMsgActive;

    return (
        <div className="min-h-screen pb-24 text-white selection:bg-pink-500/30 relative" style={appBackgroundStyle}>
            {isVideoBg && <video src={bgUrl} autoPlay loop muted playsInline className="fixed inset-0 w-full h-full object-cover -z-10" style={{ pointerEvents: 'none' }}/>}
            <WelcomeAlphaModal />
            <AnnouncementPopIn cfg={rkConfig} />
            <DiscoveryTip cfg={rkConfig} />
            <TutorialOverlay active={tutorialActive} onFinish={() => { try { localStorage.setItem('rk_tutorial_done', 'true'); localStorage.setItem('rk_tut_reminder_seen', 'true'); } catch (e) {} setTutorialActive(false); }} />
            <TutorialReminderPopIn active={tutorialReminder} onClose={() => setTutorialReminder(false)} />
            <VIPCheckoutModal user={user} isOpen={showVipModal} onClose={() => setShowVipModal(false)} />
            {user && <PublicProfilePage uid={viewingProfileId} viewerUid={user.uid} viewerProfile={profile} onClose={() => setViewingProfileId(null)} onMessage={(tid, tname) => { setViewingProfileId(null); setMsgTarget({ uid: tid, name: tname }); setMsgOpen(true); }} onViewFeedItem={(it) => { setViewingProfileId(null); handleViewItem(it); }} />}
            {user && <MainSettingsModal user={user} profile={profile} isOpen={forceSettings} onClose={() => setForceSettings(false)} onReplayTutorial={replayTutorial}/>}
            {user && <ShoppingCartModal user={user} items={items} isOpen={cartOpen} onClose={() => setCartOpen(false)}/>}
            <KandiCreatorApplicationModal user={user} isOpen={creatorAppOpen} onClose={() => setCreatorAppOpen(false)} />
            <ReferralModal user={user} profile={profile} isOpen={openReferrals} onClose={() => setOpenReferrals(false)} />
            <TicketModal user={user} profile={profile} isOpen={ticketOpen} onClose={() => setTicketOpen(false)} />
            <ItemDetailModal item={viewingItem ? (items.find(x => x.id === viewingItem.id) || viewingItem) : null} user={user} isOpen={!!viewingItem} onClose={() => setViewingItem(null)} onViewFeed={(uid) => { setViewingItem(null); handleViewFeed(uid); }} />
            {user && <MessengerModal user={user} profile={profile} isOpen={msgOpen} onClose={() => setMsgOpen(false)} threads={threads} notifs={notifs} initialTarget={msgTarget} onConsumeTarget={() => setMsgTarget(null)} onViewProfile={(uid) => setViewingProfileId(uid)} onNotifNav={(n) => {
                // Route a tapped notification to the right place. Profile hosts achievements,
                // Vibe Tribe & referrals; feed hosts comments/likes/sales/DIY.
                const t = n.type;
                if (t === 'comment' || t === 'like' || t === 'sold' || t === 'cart' || t === 'diy' || t === 'queue') { setMsgOpen(false); setPage('feed'); }
                else if (t === 'achievement' || t === 'friendreq' || t === 'referral' || t === 'ticket' || t === 'admin') { setMsgOpen(false); setPage('profile'); }
            }} />}
            <Modal isOpen={merchPopup} onClose={() => setMerchPopup(false)} title="Official Merch">
                <div className="text-center space-y-4">
                    {['OFFICIAL', 'DROPS', 'SOON'].map((word, i) => (<h1 key={i} className="text-4xl font-black animate-text-shimmer opacity-90" style={{ backgroundImage: 'linear-gradient(45deg, #00ffff, #ffffff, #00ffff)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent' }}>{word}.</h1>))}
                    <p className="text-sm opacity-70">Official Items are still under construction, design, and fabrication. They will be added in a future update.</p>
                    <Button onClick={() => { setMerchPopup(false); setForceSettings(true); }} color="cyan" className="w-full">Enable Drop Notifications</Button>
                    <div className="flex gap-2">
                        <Button onClick={() => { try { localStorage.setItem('rk_hide_merch_popup', '1'); } catch(e) {} setMerchPopup(false); }} color="accent" className="flex-1 text-xs">Don't Show Again</Button>
                        <Button onClick={() => setMerchPopup(false)} color="purple" className="flex-1 text-xs">Close</Button>
                    </div>
                </div>
            </Modal>
            {user && <VideoSubmitModal user={user} profile={profile} isOpen={videoSubmitOpen} onClose={() => setVideoSubmitOpen(false)} slots={videoSlotsForSubmit} />}
            <HelpModal isOpen={helpOpen} onClose={() => setHelpOpen(false)} />
            <Modal isOpen={iosGuide} onClose={() => setIosGuide(false)} title="📲 Get RaveKandi">
                <div className="space-y-3 text-sm">
                    <p className="text-xs opacity-80">RaveKandi works right here in your browser — or install it for a fullscreen, app-like experience. Pick whatever suits your device:</p>

                    {/* Always-available: open / continue on the web version */}
                    <a href={WEB_APP_URL} target="_blank" rel="noreferrer" className="block">
                        <div className="bg-gradient-to-r from-cyan-600/30 to-blue-600/30 border border-cyan-400/50 rounded-lg p-3 flex items-center gap-3 hover:from-cyan-600/50 hover:to-blue-600/50 transition">
                            <Globe size={26} className="text-cyan-300 shrink-0"/>
                            <div><p className="font-black text-sm text-cyan-200">Use the Web Version</p><p className="text-[10px] text-white/70">Open ravekandi.web.app in your browser — nothing to install. Works on any device.</p></div>
                        </div>
                    </a>

                    {/* iPhone install steps */}
                    <div className="bg-white/5 border border-white/10 rounded p-3 space-y-1.5 text-xs">
                        <p className="font-bold text-pink-300 uppercase text-[10px] flex items-center gap-1">🍏 On iPhone (Safari) — Install to Home Screen</p>
                        <p><strong className="text-pink-300">1.</strong> Tap the <strong>Share</strong> button (square with an up-arrow).</p>
                        <p><strong className="text-pink-300">2.</strong> Scroll down, tap <strong>"Add to Home Screen."</strong></p>
                        <p><strong className="text-pink-300">3.</strong> Tap <strong>Add</strong> — it launches fullscreen with its own icon. 🌈</p>
                    </div>

                    {/* Android options: PWA install + direct APK */}
                    <div className="bg-white/5 border border-white/10 rounded p-3 space-y-1.5 text-xs">
                        <p className="font-bold text-lime-300 uppercase text-[10px] flex items-center gap-1">🤖 On Android — Two Options</p>
                        <p><strong className="text-lime-300">A.</strong> <strong>Install from browser:</strong> Chrome <strong>⋮ menu</strong> → <strong>"Install app"</strong> / "Add to Home screen."</p>
                        <p><strong className="text-lime-300">B.</strong> <strong>Download the APK</strong> for the native app:</p>
                        <a href={ANDROID_APK_URL} target="_blank" rel="noreferrer" className="block mt-1">
                            <div className="bg-lime-600/20 border border-lime-400/50 rounded p-2 flex items-center gap-2 hover:bg-lime-600/40 transition">
                                <Download size={18} className="text-lime-300 shrink-0"/>
                                <span className="text-[11px] font-bold text-lime-200">Download Android APK</span>
                            </div>
                        </a>
                        <p className="text-[8px] opacity-50 mt-1">APK installs may ask you to allow "install from unknown sources" — that's normal for direct downloads outside the Play Store.</p>
                    </div>

                    {/* App-store placeholders (hidden until launch) */}
                    <div className="bg-black/40 border border-dashed border-white/15 rounded p-3 text-center">
                        <p className="text-[10px] text-white/40 font-bold uppercase tracking-wide">Coming soon</p>
                        <p className="text-[9px] text-white/40 mt-1">📱 App Store &amp; Google Play downloads are on the way — for now, use the web version or the Android APK above.</p>
                    </div>

                    <div className="flex gap-2">
                        <Button onClick={() => { try { localStorage.setItem('rk_ios_a2hs', '1'); } catch (e) {} setIosGuide(false); }} color="accent" className="flex-1 text-xs">Don't Show Again</Button>
                        <Button onClick={() => setIosGuide(false)} color="cyan" className="flex-1 text-xs">Got It!</Button>
                    </div>
                </div>
            </Modal>
            
            <RadioPlayerModal user={user} profile={profile} isOpen={radioOpen} onClose={() => setRadioOpen(false)} onGoVip={() => { setRadioOpen(false); setShowVipModal(true); }} onPlayingChange={setIsRadioPlaying} onNowPlaying={setNowPlaying} onViewProfileFromRadio={(uid) => { setRadioOpen(false); setViewingProfileId(uid); }} />

            <div className="sticky top-0 z-50" ref={topBarRef}>
            <header className="bg-black/80 backdrop-blur border-b border-white/10 px-2 py-3 flex items-end justify-between gap-1">
                <div data-tut="home" onClick={() => setPage('home')} className="flex flex-col items-start cursor-pointer transition-transform active:scale-95 pb-1"><div className="flex items-center gap-1.5"><Zap className="text-yellow-400" size={28} fill="currentColor"/><h1 className="text-xl font-black italic tracking-tighter" style={{ textShadow: '0 0 15px #ff00ff' }}>RaveKandi</h1></div><span className="text-[8px] text-white/50 uppercase tracking-wide pl-1">tap for home</span></div>
                <div className="flex gap-1 items-start">
                    <button data-tut="inbox" onClick={() => setMsgOpen(true)} className="relative flex flex-col items-center gap-1 group w-11"><span className="rk-msg-icon w-10 h-10 rounded-xl flex items-center justify-center"><Mail size={22} className="text-white drop-shadow"/></span><span className="text-[9px] font-bold uppercase tracking-wide text-white/80 leading-none">Inbox</span>{inboxBadge > 0 && <span className="absolute -top-1.5 -right-1 bg-pink-600 text-white text-[9px] font-black rounded-full px-1 min-w-[16px] text-center">{inboxBadge > 99 ? '99+' : inboxBadge}</span>}</button>
                    <button data-tut="feed" onClick={() => setPage('feed')} className="flex flex-col items-center gap-1 w-11"><span className="h-10 flex items-center"><LayoutList className={page==='feed'?'text-pink-500 shadow-neon-pink':'text-white/80'} size={26}/></span><span className={`text-[9px] font-bold uppercase tracking-wide leading-none ${page==='feed'?'text-pink-400':'text-white/60'}`}>Feed</span></button>
                    <button data-tut="shop" onClick={() => setPage('shop')} className="flex flex-col items-center gap-1 w-11"><span className="h-10 flex items-center"><FlaskConical className={page==='shop'?'text-cyan-400 shadow-neon-blue':'text-white/80'} size={26}/></span><span className={`text-[9px] font-bold uppercase tracking-tight leading-none text-center ${page==='shop'?'text-cyan-400':'text-white/60'}`}>Custom<br/>Lab</span></button>
                    <button data-tut="profile" onClick={() => setPage('profile')} className="flex flex-col items-center gap-1 w-11"><span className="h-10 flex items-center"><User className={page==='profile'?'text-purple-500 shadow-neon-purple':'text-white/80'} size={26}/></span><span className={`text-[9px] font-bold uppercase tracking-wide leading-none ${page==='profile'?'text-purple-400':'text-white/60'}`}>Profile</span></button>
                    <button data-tut="cart" onClick={() => setCartOpen(true)} className="flex flex-col items-center gap-1 w-11"><span className="h-10 flex items-center"><ShoppingCart className="text-lime-400 shadow-neon-green" size={26}/></span><span className="text-[9px] font-bold uppercase tracking-wide leading-none text-lime-400/80">Cart</span></button>
                </div>
            </header>
            {!hideMarquee && <div className="w-full bg-black border-b border-white/10 text-[11px] py-1.5 text-lime-400 font-mono overflow-hidden h-9 flex items-center">
                <div className="rk-marquee-track items-center whitespace-nowrap" style={{ animationDuration: (RK_CFG.marqueeSpeed || 60) + 's' }}>
                    {[0, 1].map(copy => (
                        <div key={copy} className="flex gap-12 items-center pr-12">
                            {mq.map((m, i) => <span key={i} className="inline-flex items-center gap-1"><span onClick={m.href ? () => { try { window.open(m.href, '_blank', 'noopener'); } catch (e) {} } : m.uid ? () => setViewingProfileId(m.uid) : undefined} className={(i % 3 === 2 ? 'text-pink-400 ' : i % 3 === 1 ? 'text-cyan-300 ' : '') + ((m.uid || m.href) ? 'underline decoration-dotted underline-offset-2 cursor-pointer' : '')}>{m.t}</span>{profile?.isAdmin && m.slotId && <button onClick={(e) => { e.stopPropagation(); adminDeleteBanner(m.slotId); }} className="text-red-500 hover:text-red-300" title="Admin: remove banner">✕</button>}</span>)}
                        </div>
                    ))}
                </div>
            </div>}
            </div>
            
            <button
                onClick={() => { if (!radioDragRef.current.moved) setRadioOpen(true); }}
                onPointerDown={(e) => { const r = radioDragRef.current; r.dragging = true; r.moved = false; r.offX = e.clientX - radioBtnPos.x; r.offY = e.clientY - radioBtnPos.y; try { e.currentTarget.setPointerCapture(e.pointerId); } catch (er) {} }}
                onPointerMove={(e) => { const r = radioDragRef.current; if (!r.dragging) return; const nx = e.clientX - r.offX, ny = e.clientY - r.offY; if (Math.abs(nx - radioBtnPos.x) > 3 || Math.abs(ny - radioBtnPos.y) > 3) r.moved = true; const topGuard = (topBarRef.current ? topBarRef.current.offsetHeight : 120) + 8; const maxX = window.innerWidth - 56, maxY = window.innerHeight - 56; setRadioBtnPos({ x: Math.max(0, Math.min(nx, maxX)), y: Math.max(topGuard, Math.min(ny, maxY)) }); }}
                onPointerUp={(e) => { const r = radioDragRef.current; r.dragging = false; try { localStorage.setItem('rk_radio_btn_pos', JSON.stringify(radioBtnPos)); } catch (er) {} try { e.currentTarget.releasePointerCapture(e.pointerId); } catch (er) {} }}
                className={`fixed z-40 w-16 h-16 rounded-full flex flex-col items-center justify-center border-2 transition-colors touch-none cursor-grab active:cursor-grabbing ${isRadioPlaying ? 'rk-radio-on border-lime-300' : 'rk-radio-off border-red-400'}`}
                style={{ left: radioBtnPos.x + 'px', top: radioBtnPos.y + 'px' }}
                title="Rave Radio — drag to move, tap to open">
                <Radio size={18} className="text-white drop-shadow pointer-events-none -mb-0.5"/>
                <span className="text-[6px] font-black uppercase tracking-tight text-white/90 leading-none pointer-events-none">Rave Radio</span>
                <span className={`text-[9px] font-black leading-none pointer-events-none mt-0.5 ${isRadioPlaying ? 'text-lime-200' : 'text-red-200'}`}>{isRadioPlaying ? 'ON' : 'OFF'}</span>
            </button>
            {bannerMsgActive ? <div className="bg-amber-500 text-black text-center text-xs font-bold px-3 py-2 relative z-40">⚠ {rkConfig.maintenanceMessage}</div> : null}
            {rkConfig.minVersion && cmpVer(APP_VERSION, rkConfig.minVersion) < 0 ? (
                <div className="fixed inset-0 z-[200] bg-black/95 flex items-center justify-center p-6 text-center">
                    <div>
                        <h2 className="text-2xl font-black text-pink-500 mb-2">UPDATE REQUIRED</h2>
                        <p className="text-sm opacity-80 max-w-xs mx-auto">This build (V{APP_VERSION}) is below the minimum supported version (V{rkConfig.minVersion}). Grab the latest from the official RaveKandi download link to keep raving!</p>
                    </div>
                </div>
            ) : null}
            <main className="p-4 bg-black/50 min-h-screen">
                {page === 'home' && (
                    <div className="text-center pt-8 flex flex-col gap-8 pb-10">
                        <div className="space-y-3">{['TRADE', 'RAVE', 'PLUR'].map((word, i) => (<h1 key={i} className="text-7xl font-black animate-text-shimmer" style={{ backgroundImage: 'linear-gradient(45deg, #ff80bf, #80ffff, #bf80ff, #ff80bf)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent', filter: 'drop-shadow(0 0 10px rgba(255,100,255,0.4))', backgroundSize: '200% 200%' }}>{word}.</h1>))}</div>
                        
                        <div className="px-4 opacity-90 text-sm max-w-md mx-auto leading-relaxed"><p className="bg-gradient-to-r from-pink-400 via-purple-400 to-cyan-400 bg-clip-text text-transparent font-bold">Welcome to your digital festival grounds! 🌈✨ The ultimate PLUR-powered marketplace to trade, sell, and discover magical, one-of-a-kind Kandi creations. Spread the vibe!</p></div>

                        <p className="px-4 text-xl font-black uppercase tracking-wider bg-gradient-to-r from-lime-300 via-cyan-300 to-pink-400 bg-clip-text text-transparent max-w-md mx-auto" style={{ filter: 'drop-shadow(0 0 8px rgba(0,255,200,0.45))' }}>Want to sell your wares? Click Enter Exchange below ⬇</p>
                        
                        <div className="flex flex-col gap-4">
                            <Button onClick={() => setPage('feed')} color="cyan" className="mx-auto px-8 py-3 text-lg shadow-neon-blue w-3/4 max-w-xs">Enter Exchange</Button>
                            <div className="flex flex-col items-center gap-1">
                                <p className="text-sm font-black italic animate-pulse drop-shadow-[0_0_8px_rgba(255,255,255,0.8)]" style={{ backgroundImage: 'linear-gradient(90deg, #ff80bf, #80ffff, #bef264)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent' }}>
                                    ↑ CLICK HERE, CREATE ➔ 💵 EARN ↑
                                </p>
                                <a href="https://t.me/RaveKandiFriends" target="_blank" rel="noreferrer" className="w-3/4 max-w-xs mt-2">
                                    <Button color="purple" className="w-full flex items-center justify-center gap-2 py-2 text-xs border-dashed"><MessageSquare size={16}/> Join Telegram Group</Button>
                                </a>
                            </div>
                        </div>

                        <div className="py-6 w-full max-w-md mx-auto">
                            <h2 className="text-2xl font-black mb-4 italic tracking-tighter" style={{ textShadow: '0 0 15px #ff00ff', backgroundImage: 'linear-gradient(45deg, #ff80bf, #80ffff)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent' }}>Festival Spotlight 🎬</h2>
                            <FeaturedVideoBlock user={user} profile={profile} nowTick={nowTick} onViewProfile={setViewingProfileId} onOpenSubmit={() => setVideoSubmitOpen(true)} />
                        </div>
                        
                        <div className="w-full border-t border-white/10 pt-8 mt-2 px-1 text-left">
                            <InfoSection />
                            <CreatorPerksSection onApply={() => setCreatorAppOpen(true)} />
                            <ReferralProgramSection onNavigateToProfile={() => setOpenReferrals(true)} />
                        </div>

                        <div className="max-w-md mx-auto w-full bg-black/60 border-2 border-dashed border-purple-400/50 rounded-xl p-4 text-center" style={{ boxShadow: '0 0 18px rgba(216,180,254,0.35)' }}>
                            <p className="text-lg font-black uppercase tracking-wide rk-pastel-shift bg-clip-text text-transparent" style={{ backgroundImage: 'linear-gradient(90deg, #ffd1f7, #c4f0ff, #d8ffd1, #fff3c4, #ffd1f7)' }}>🎬 Share your festival vibe!</p>
                            <p className="text-xs text-gray-100 mt-1 mb-3">Got a clip from a show — pyro, a stage moment, a kandi trade? Feature it in the Festival Spotlight above and put your profile in front of every raver.</p>
                            <Button onClick={() => setVideoSubmitOpen(true)} color="purple" className="w-full text-xs">🎬 Feature Your Clip</Button>
                        </div>

                        <div className="max-w-md mx-auto w-full">
                            <h3 className="text-lg font-black uppercase tracking-widest text-center mb-2 animate-text-shimmer" style={{ backgroundImage: 'linear-gradient(45deg, #fde047, #fff7c2, #facc15, #fde047)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent', backgroundSize: '200% 200%', filter: 'drop-shadow(0 0 8px rgba(250,204,21,0.5))' }}>Custom and DIY Requests</h3>
                            <div className="w-full bg-yellow-900/15 border-2 border-yellow-400/70 rounded-xl p-4 text-left shadow-[0_0_14px_rgba(250,204,21,0.25)]">
                                <p className="text-sm text-yellow-300 font-bold uppercase mb-2">⚖ Creator Fairness Window</p>
                                <p className="text-xs text-gray-100 leading-relaxed">Custom & DIY requests sent to a specific Creator stay exclusive to them for <strong>24–72 hours</strong> (scaled by price and complexity). If unaccepted in that window, the request automatically opens to ALL Creators — keeping commissions fair for users and Creators alike.</p>
                                <Button onClick={() => { setPage('shop'); setTab('diy'); }} color="gold" className="w-full mt-3 text-sm font-black uppercase tracking-wide flex items-center justify-center gap-2"><Hammer size={16}/> Start a DIY Request</Button>
                            </div>
                        </div>

                        <Card className="border-yellow-500/30 text-center max-w-md mx-auto w-full">
                            <HelpCircle size={28} className="mx-auto mb-2 text-yellow-400"/>
                            <h3 className="font-black uppercase text-sm mb-1 text-yellow-400">Found a bug? Have an idea?</h3>
                            <p className="text-sm text-gray-100 mb-3">Help shape RaveKandi during Alpha — send the team your feedback, bug reports, and help requests.</p>
                            <Button onClick={() => setTicketOpen(true)} color="gold" className="w-full text-sm">Send Feedback / Report Issue</Button>
                        </Card>
                    </div>
                )}
                {page === 'feed' && (<div className="max-w-2xl mx-auto space-y-4">
                    <div className="bg-gradient-to-br from-pink-600/20 via-purple-600/15 to-cyan-600/20 border border-pink-500/40 rounded-xl p-3 mb-2 shadow-[0_0_15px_rgba(255,80,180,0.15)]">
                        <p className="text-lg font-black flex items-center gap-2 mb-2"><LayoutList size={20} className="text-pink-200"/> <span className="rkfx-pastel" style={{ filter: 'drop-shadow(0 0 6px rgba(255,200,240,0.5))' }}>Welcome to the Feed</span> 🌈</p>
                        <p className="text-sm text-white/90 leading-relaxed">This is the community marketplace feed — every post here is an item a raver is <strong>selling or showcasing</strong>: handmade kandi, clothing, accessories, custom pieces and more. Tap any post to view details, like it, comment, or buy. Tap a creator's <strong>@name</strong> to visit their profile, add them as a friend, or message them. Use the filters below to find exactly what you're after!</p>
                    </div>
                    <Card className="bg-[#1a0033]/95 shadow-2xl border-white/20 py-3 mb-4">
                        <div className="grid grid-cols-3 gap-3 mb-3">
                            <div><label className="text-[8px] font-bold opacity-50 uppercase ml-1">Post Type</label><select value={filters.postType} onChange={e=>setFilters({...filters, postType: e.target.value})} className={selectStyle}><option value="all">All</option><option value="official">Official</option><option value="users">User Profiles</option></select></div>
                            <div>
                                <label className="text-[8px] font-bold opacity-50 uppercase ml-1">Sort</label>
                                <select value={filters.sort} onChange={e=>setFilters({...filters, sort: e.target.value})} className={selectStyle}>
                                    <option value="all">All</option>
                                    <option value="recent">Recent</option>
                                    <option value="popular">Most Liked</option>
                                    <option value="commented">Most Commented</option>
                                    <option value="viewed">Most Viewed</option>
                                    <option value="priceHigh">Price: High - Low</option>
                                    <option value="priceLow">Price: Low - High</option>
                                </select>
                            </div>
                            <div><label className="text-[8px] font-bold opacity-50 uppercase ml-1">Item Type</label><MultiSelectDropdown options={KANDI_TYPES} selected={filters.itemTypes} onChange={v => setFilters({...filters, itemTypes: v})}/></div>
                        </div>
                        <div className="flex justify-between items-center border-t border-white/10 pt-3">
                            <div className="flex gap-2 flex-1 mr-2"><Search size={16} className="mt-2 text-white/50"/><Input placeholder="Search UID or Username..." value={filters.searchUid} onChange={v=>setFilters({...filters, searchUid: v})} className="mb-0 w-full"/></div>
                            <div className="flex gap-2 items-center">
                                <button onClick={manualRefresh} className={`text-white/50 hover:text-white transition-transform ${isSyncing ? 'animate-spin text-lime-400' : ''}`}><RefreshCw size={16}/></button>
                                <button onClick={() => setFilters({ postType: 'all', itemTypes: [], sort: 'recent', searchUid: '' })} className="bg-white/10 hover:bg-white/20 text-[10px] font-bold uppercase tracking-widest px-3 py-2 rounded">Clear Filters</button>
                            </div>
                        </div>
                    </Card>
                    {filters.postType !== 'users' && <SellKandiForm user={user} profile={profile}/>}
                    {isSyncing && (
                        <div className="flex flex-col items-center justify-center py-6 mb-4 bg-black/40 border border-white/10 rounded-xl">
                            <RefreshCw size={32} className="animate-spin text-lime-400 mb-3" />
                            <p className="text-transparent bg-clip-text bg-gradient-to-r from-pink-400 via-purple-400 to-cyan-400 font-bold animate-pulse text-sm">{syncMsgs[syncMsgIdx]}</p>
                        </div>
                    )}
                    {filters.postType === 'users' ? (
                        <div className="grid grid-cols-1 gap-3">
                            {visibleUsers.length === 0 && <p className="text-center opacity-50 py-6 text-xs">No ravers match that search.</p>}
                            {visibleUsers.map(u => (
                                <Card key={u.id} className="flex items-center gap-3 border-purple-500/30">
                                    <button onClick={() => setViewingProfileId(u.publicUid || u.id)} className="shrink-0"><img src={u.photoURL || 'https://placehold.co/80?text=User'} className="w-14 h-14 rounded-full object-cover border-2 border-pink-500/60 cursor-pointer hover:border-lime-400 transition-colors"/></button>
                                    <div className="flex-1 min-w-0 cursor-pointer" onClick={() => setViewingProfileId(u.publicUid || u.id)}>
                                        <div className="min-w-0"><UserRating sum={u.ratingSum} count={u.ratingCount} /><p className="font-bold text-sm truncate">@{u.displayName || 'Raver'}</p>{u.featuredBadge && <span className="flex"><BadgeChip badge={u.featuredBadge} /></span>}<div className="mt-1"><AddFriendButton myProfile={profile} myUid={user?.uid} targetUid={u.id} targetName={u.displayName} /></div></div>
                                        <p className="text-[9px] font-mono opacity-50 truncate">UID: {u.publicUid || u.id}</p>
                                        <p className="text-[10px] text-gray-100 opacity-80 truncate italic">{u.bio || 'No vibe check yet.'}</p>
                                        {SOCIAL_PLATFORMS.filter(p => u.socialLinks?.[p.id]).length > 0 && (
                                            <div className="flex gap-2.5 mt-1.5">
                                                {SOCIAL_PLATFORMS.filter(p => u.socialLinks?.[p.id]).slice(0, 6).map(p => (
                                                    <button key={p.id} onClick={(e) => { e.stopPropagation(); try { window.open('https://' + p.baseUrl + u.socialLinks[p.id], '_blank', 'noopener'); } catch (err) {} }} title={p.name} className="hover:scale-125 transition-transform"><p.icon size={13} color={p.color}/></button>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                    <Button onClick={() => setViewingProfileId(u.publicUid || u.id)} color="purple" className="text-[10px] py-1 px-3 shrink-0">View Profile</Button>
                                </Card>
                            ))}
                        </div>
                    ) : (
                    <div className="space-y-6">
                        {(filters.searchUid || '').trim().length >= 2 && visibleUsers.length > 0 && (
                            <div className="space-y-3">
                                <p className="text-[10px] font-black uppercase tracking-widest text-purple-300">Ravers matching "{filters.searchUid}"</p>
                                {visibleUsers.slice(0, 10).map(u => (
                                    <Card key={u.id} className="flex items-center gap-3 border-purple-500/30">
                                        <button onClick={() => setViewingProfileId(u.publicUid || u.id)} className="shrink-0"><img src={u.photoURL || 'https://placehold.co/80?text=User'} className="w-14 h-14 rounded-full object-cover border-2 border-pink-500/60 cursor-pointer hover:border-lime-400 transition-colors"/></button>
                                        <div className="flex-1 min-w-0 cursor-pointer" onClick={() => setViewingProfileId(u.publicUid || u.id)}>
                                            <div className="min-w-0"><UserRating sum={u.ratingSum} count={u.ratingCount} /><p className="font-bold text-sm truncate">@{u.displayName || 'Raver'}</p>{u.featuredBadge && <span className="flex"><BadgeChip badge={u.featuredBadge} /></span>}<div className="mt-1"><AddFriendButton myProfile={profile} myUid={user?.uid} targetUid={u.id} targetName={u.displayName} /></div></div>
                                            <p className="text-[9px] font-mono opacity-50 truncate">UID: {u.publicUid || u.id}</p>
                                            <p className="text-[10px] text-gray-100 opacity-80 truncate italic">{u.bio || 'No vibe check yet.'}</p>
                                        </div>
                                        <Button onClick={() => setViewingProfileId(u.publicUid || u.id)} color="purple" className="text-[10px] py-1 px-3 shrink-0">View Profile</Button>
                                    </Card>
                                ))}
                                <div className="h-px bg-white/10 my-2"/>
                            </div>
                        )}
                        <div className="grid grid-cols-1 gap-6">{displayedFeedItems.map(item => <ItemCard key={item.id} item={item} user={user} profile={profile} onViewProfile={setViewingProfileId} onAddToCart={addToCart} onViewItem={handleViewItem}/>)}</div>
                    </div>
                    )}</div>)}
                {page === 'shop' && (
                    <div className="max-w-4xl mx-auto">
                        <div className="flex gap-2 justify-center mb-6">{['custom', 'diy', 'official'].map(t => (<button key={t} onClick={() => setTab(t)} className={`px-4 py-2 rounded-full font-black uppercase text-[10px] tracking-widest ${tab===t ? 'bg-pink-600 shadow-neon-pink text-white' : 'bg-white/5 text-white/50'}`}>{t === 'custom' ? 'AI KANDI LAB' : t}</button>))}</div>
                        {tab === 'custom' && <AICustomLab user={user} profile={profile} onSubmitRequest={(i) => addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), {...i, ownerId: user.uid, timestamp: Date.now()})}/>}
                        {tab === 'diy' && <DIYBuilder onSubmitRequest={async (i) => { await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), {...i, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', ownerBadge: profile?.featuredBadge || null, timestamp: Date.now()}); if (i.assignedCreatorId) pushNotif(i.assignedCreatorId, 'queue', '🔨 New direct build request from ' + (profile?.displayName || 'a raver') + ' — $' + (i.price || 0).toFixed(2) + ' (' + (i.idleWindowHours || 24) + 'h priority window)'); }}/>}
                        {tab === 'official' && ( 
                            <div>
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    {officialItems.map(item => <ItemCard key={item.id} item={item} user={user} profile={profile} onViewProfile={setViewingProfileId} onAddToCart={addToCart} onViewItem={handleViewItem}/>)}
                                </div>
                            </div>
                        )}
                   </div>
                )}
                {page === 'profile' && <ProfileView user={user} onOpenSettings={() => setForceSettings(true)} onViewFeed={handleViewFeed} onViewProfile={(id) => setViewingProfileId(id)} onMessageUser={(uid, name) => { setMsgTarget({ uid, name: name || 'Raver' }); setMsgOpen(true); }} onReplayTutorial={replayTutorial}/>}
            </main>
            <div className="fixed bottom-0 w-full bg-black/95 border-t border-white/10 font-mono uppercase z-50 px-3 py-1.5">
                {nowPlaying && (
                    <div className="flex items-center justify-center gap-2 text-[11px] font-bold pb-1 mb-1 border-b border-white/10" style={{ color: nowPlaying.color || '#bef264' }}>
                        <Radio size={12} className="shrink-0 animate-pulse"/>
                        <span className="truncate">{nowPlaying.name} · {nowPlaying.song}</span>
                    </div>
                )}
                <div className="flex items-center justify-between text-[10px] text-white/40">
                    <PingBar show={profile?.showPing !== false} />
                    <span className="flex-1 text-center">V63.03.04 Phase 55: lock horizontal page scroll (no left/right scroll)</span>
                    <button onClick={() => setHelpOpen(true)} className="w-14 flex items-center justify-end gap-0.5 text-cyan-400 hover:text-cyan-300" title="Help & How It Works"><HelpCircle size={13}/><span className="text-[9px] font-bold">HELP</span></button>
                </div>
            </div>
        </div>
    );
};
export default App;
EOF

mkdir -p ~/RaveKandi-Build/public
mkdir -p ~/RaveKandi-Build/src
cp -r ~/ravekandi-app/public/* ~/RaveKandi-Build/public/
cp -r ~/ravekandi-app/src/* ~/RaveKandi-Build/src/
cp ~/ravekandi-app/tailwind.config.js ~/RaveKandi-Build/ 2>/dev/null || :

cd ~/RaveKandi-Build

if [ ! -f "public/index.html" ]; then
  echo "CRITICAL ERROR: public/index.html is missing! Please re-run Block 1."
  exit 1
fi

cat << 'EOF' > package.json
{
  "name": "ravekandi",
  "version": "1.0.0",
  "dependencies": {
    "@capacitor/android": "5.7.4",
    "@capacitor/core": "5.7.4",
    "@capacitor/splash-screen": "5.0.7",
    "@stripe/react-stripe-js": "^2.6.2",
    "@stripe/stripe-js": "^3.3.0",
    "firebase": "^9.0.0",
    "lucide-react": "^0.263.1",
    "qrcode.react": "^3.1.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "tailwindcss": "^3.3.0"
  },
  "devDependencies": {
    "@capacitor/cli": "5.7.4"
  },
  "scripts": { "start": "react-scripts start", "build": "react-scripts build" },
  "browserslist": { "production": [ ">0.2%", "not dead", "not op_mini all" ], "development": [ "last 1 chrome version" ] }
}
EOF

cat << 'EOF' > capacitor.config.json
{
  "appId": "com.ravekandi.app",
  "appName": "RaveKandi",
  "webDir": "build",
  "bundledWebRuntime": false,
  "server": { "cleartext": true }
}
EOF

# Block 20
cd ~/RaveKandi-Build

echo "Verifying Termux Native Toolchain..."
TERMUX_PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
command -v node >/dev/null 2>&1 || pkg install -y nodejs-lts
command -v java >/dev/null 2>&1 || pkg install -y openjdk-21
command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1 || pkg install -y imagemagick

if [ ! -f "$TERMUX_PREFIX/bin/aapt2" ]; then
    echo "Native AAPT2 missing. Installing from Termux repository..."
    pkg update -y || true
    pkg install -y aapt2 || pkg install -y aapt || true
fi

if [ ! -f "$TERMUX_PREFIX/bin/aapt2" ]; then
    echo "==========================================================="
    echo "CRITICAL ERROR: AAPT2 could not be installed automatically."
    echo "Run these two commands manually, then re-run this script:"
    echo "  pkg update -y"
    echo "  pkg install -y aapt2 aapt"
    echo "==========================================================="
    exit 1
fi
echo "AAPT2 verified: $TERMUX_PREFIX/bin/aapt2"

if [ ! -d "$HOME/android-sdk" ]; then
    echo "WARNING: ~/android-sdk folder not found. The Gradle build may fail without the Android SDK."
fi

echo "Deep cleaning build environment..."
rm -rf node_modules package-lock.json build android
npm cache clean --force

echo "Installing core dependencies..."
npm install --legacy-peer-deps --no-audit

echo "Applying Webpack compilation fixes..."
npm install ajv@8.12.0 ajv-keywords@5.1.0 --save-dev --legacy-peer-deps --no-audit

echo "Compiling Native React Bundle (with OOM Protection)..."
export GENERATE_SOURCEMAP=false
export NODE_OPTIONS="--max-old-space-size=2048"
node node_modules/react-scripts/bin/react-scripts.js build

if [ ! -f "build/index.html" ]; then
    echo "CRITICAL ERROR: React build failed. Check for hidden syntax errors."
    exit 1
fi

echo "Initializing Android Platform..."
npx @capacitor/cli add android

echo "Upgrading Gradle Wrapper to support Java 21 (Termux default)..."
sed -i 's/gradle-[0-9\.]*-all\.zip/gradle-8.7-all.zip/g' android/gradle/wrapper/gradle-wrapper.properties

echo "Syncing Capacitor Native Bridge..."
npx @capacitor/cli sync android

echo "Adding Android audio permissions to Manifest..."
MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST" ] && ! grep -q "MODIFY_AUDIO_SETTINGS" "$MANIFEST"; then
    sed -i 's|<uses-permission android:name="android.permission.INTERNET" */>|<uses-permission android:name="android.permission.INTERNET" />\n    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />\n    <uses-permission android:name="android.permission.WAKE_LOCK" />|' "$MANIFEST"
fi

echo "Installing Custom App Icon (Icon.jpg from Downloads)..."
IMG_TOOL=""
command -v magick >/dev/null 2>&1 && IMG_TOOL="magick"
[ -z "$IMG_TOOL" ] && command -v convert >/dev/null 2>&1 && IMG_TOOL="convert"

ICON_SRC=""
for P in "/storage/emulated/0/Download/Icon.jpg" "$HOME/storage/downloads/Icon.jpg" "$HOME/storage/shared/Download/Icon.jpg" "$HOME/Icon.jpg"; do
    if [ -f "$P" ]; then ICON_SRC="$P"; break; fi
done

if [ -n "$ICON_SRC" ] && [ -n "$IMG_TOOL" ]; then
    echo "Icon found at: $ICON_SRC"
    rm -rf android/app/src/main/res/mipmap-anydpi-v26
    for entry in mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192; do
        D="${entry%%:*}"; S="${entry##*:}"
        DIR="android/app/src/main/res/mipmap-$D"
        mkdir -p "$DIR"
        $IMG_TOOL "$ICON_SRC" -auto-orient -resize "${S}x${S}^" -gravity center -extent "${S}x${S}" "$DIR/ic_launcher.png"
        cp "$DIR/ic_launcher.png" "$DIR/ic_launcher_round.png"
        cp "$DIR/ic_launcher.png" "$DIR/ic_launcher_foreground.png"
    done
    echo "Custom icon installed for all screen densities."
else
    echo "WARNING: Icon.jpg not found in Downloads (or imagemagick unavailable). Keeping default icon."
fi

echo "Enforcing Termux Native AAPT2 globally..."
mkdir -p ~/.gradle
sed -i '/android.aapt2FromMavenOverride/d' ~/.gradle/gradle.properties 2>/dev/null || true

echo "Injecting TLS Fix for Termux JVM..."
sed -i '/systemProp.https.protocols/d' ~/.gradle/gradle.properties 2>/dev/null || true
sed -i '/systemProp.javax.net.ssl/d' ~/.gradle/gradle.properties 2>/dev/null || true
sed -i '/systemProp.sun.security.ssl/d' ~/.gradle/gradle.properties 2>/dev/null || true
sed -i '/org.gradle.jvmargs/d' ~/.gradle/gradle.properties 2>/dev/null || true

cat >> ~/.gradle/gradle.properties << 'TLSEOF'
android.aapt2FromMavenOverride=/data/data/com.termux/files/usr/bin/aapt2
systemProp.https.protocols=TLSv1.2,TLSv1.3
systemProp.javax.net.ssl.trustStoreType=JKS
systemProp.sun.security.ssl.allowUnsafeRenegotiation=true
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8 -Dhttps.protocols=TLSv1.2,TLSv1.3
TLSEOF

echo "Patching Capacitor Java 14+ Switch Expressions for Java 8 Termux compatibility..."
node -e '
const fs = require("fs");
const file = "node_modules/@capacitor/android/capacitor/src/main/java/com/getcapacitor/WebViewLocalServer.java";
if (fs.existsSync(file)) {
    let code = fs.readFileSync(file, "utf8");
    const startMarker = "private String getReasonPhraseFromResponseCode(int code) {";
    const startIndex = code.indexOf(startMarker);
    if (startIndex !== -1) {
        let braceCount = 0; let endIndex = -1;
        for (let i = startIndex + startMarker.length; i < code.length; i++) {
            if (code[i] === "{") braceCount++;
            if (code[i] === "}") {
                if (braceCount === 0) { endIndex = i + 1; break; }
                braceCount--;
            }
        }
        if (endIndex !== -1) {
            const newMethod = `private String getReasonPhraseFromResponseCode(int code) {
        switch (code) { case 100: return "Continue"; case 101: return "Switching Protocols"; case 200: return "OK"; case 201: return "Created"; case 202: return "Accepted"; case 203: return "Non-Authoritative Information"; case 204: return "No Content"; case 205: return "Reset Content"; case 206: return "Partial Content"; case 300: return "Multiple Choices"; case 301: return "Moved Permanently"; case 302: return "Found"; case 303: return "See Other"; case 304: return "Not Modified"; case 305: return "Use Proxy"; case 307: return "Temporary Redirect"; case 400: return "Bad Request"; case 401: return "Unauthorized"; case 402: return "Payment Required"; case 403: return "Forbidden"; case 404: return "Not Found"; case 405: return "Method Not Allowed"; case 406: return "Not Acceptable"; case 407: return "Proxy Authentication Required"; case 408: return "Request Time-out"; case 409: return "Conflict"; case 410: return "Gone"; case 411: return "Length Required"; case 412: return "Precondition Failed"; case 413: return "Request Entity Too Large"; case 414: return "Request-URI Too Large"; case 415: return "Unsupported Media Type"; case 500: return "Internal Server Error"; case 501: return "Not Implemented"; case 502: return "Bad Gateway"; case 503: return "Service Unavailable"; case 504: return "Gateway Time-out"; case 505: return "HTTP Version not supported"; default: return "Unknown Reason"; } }`;
            code = code.substring(0, startIndex) + newMethod + code.substring(endIndex);
            fs.writeFileSync(file, code);
        }
    }
}
'

echo "Applying Android Version Patch (V63.03.04)..."
sed -i "s/versionCode 1/versionCode 132/g" android/app/build.gradle
sed -i 's/versionName "1.0"/versionName "63.03.04"/g' android/app/build.gradle

echo "Enforcing Strict AAPT2/API 34 Dependency Matrix..."
sed -i "s/compileSdkVersion = [0-9]*/compileSdkVersion = 34/g" android/variables.gradle
sed -i "s/targetSdkVersion = [0-9]*/targetSdkVersion = 34/g" android/variables.gradle

echo "Patching R8 Compiler to fix JDK 21 DexBuilder NullPointerException..."
sed -i '/com.android.tools.build:gradle:/a \        classpath "com.android.tools:r8:8.3.37"' android/build.gradle

echo "android.aapt2FromMavenOverride=/data/data/com.termux/files/usr/bin/aapt2" >> android/gradle.properties

echo "Injecting Java 8 compilation fallback..."
cat << 'EOF' >> android/build.gradle

subprojects {
    project.configurations.all {
        resolutionStrategy.eachDependency { details ->
            if (details.requested.group == 'androidx.core' && details.requested.name == 'core-splashscreen') {
                details.useVersion '1.0.1'
            }
            if (details.requested.group == 'androidx.activity') {
                details.useVersion '1.8.2'
            }
            if (details.requested.group == 'androidx.core' && (details.requested.name == 'core' || details.requested.name == 'core-ktx')) {
                details.useVersion '1.12.0'
            }
        }
    }
    afterEvaluate { project ->
        if (project.hasProperty('android')) {
            project.android.compileOptions.sourceCompatibility = JavaVersion.VERSION_1_8
            project.android.compileOptions.targetCompatibility = JavaVersion.VERSION_1_8
        }
        project.tasks.matching { it.name.startsWith("compile") && it.name.endsWith("Kotlin") }.configureEach {
            it.kotlinOptions.jvmTarget = "1.8"
        }
    }
}
EOF

echo "Linking Android SDK to Gradle..."
echo "sdk.dir=/data/data/com.termux/files/home/android-sdk" > android/local.properties

echo "Building APK natively via Gradle..."
cd android && chmod +x gradlew
bash ./gradlew clean assembleDebug --no-daemon --max-workers=1 < /dev/null

APK_NAME="RaveKandi_V63_03_04_$(date +%H%M%S).apk"
OUT_DIR="$HOME/RaveKandi_Output"
mkdir -p "$OUT_DIR"

cp app/build/outputs/apk/debug/app-debug.apk "$OUT_DIR/$APK_NAME"

echo "Attempting to export APK to public Downloads folder..."

termux-setup-storage
sleep 3

if cp "$OUT_DIR/$APK_NAME" "/storage/emulated/0/Download/$APK_NAME" 2>/dev/null; then
    APK_PATH="/storage/emulated/0/Download/$APK_NAME"
elif cp "$OUT_DIR/$APK_NAME" "$HOME/storage/downloads/$APK_NAME" 2>/dev/null; then
    APK_PATH="$HOME/storage/downloads/$APK_NAME"
elif cp "$OUT_DIR/$APK_NAME" "$HOME/storage/shared/Download/$APK_NAME" 2>/dev/null; then
    APK_PATH="$HOME/storage/shared/Download/$APK_NAME"
else
    APK_PATH=""
fi

if [ -n "$APK_PATH" ]; then
    chmod 644 "$APK_PATH"
    am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file://$APK_PATH" >/dev/null 2>&1 || true
    termux-media-scan "$APK_PATH" >/dev/null 2>&1 || true
    echo "==========================================================="
    echo "SUCCESS! APK is saved in your Android Downloads folder:"
    echo "$APK_PATH"
    echo "==========================================================="
else
    echo "==========================================================="
    echo "TERMUX STORAGE NOT FULLY LINKED"
    echo "The APK built perfectly, but Android blocked the transfer."
    echo "To retrieve it, open the standard Android Files app,"
    echo "navigate to Internal Storage -> Android -> data -> com.termux -> files -> home -> RaveKandi_Output"
    echo "Or run: termux-setup-storage, then try copying manually."
    echo "==========================================================="
fi

# Block 21 — Web deploy (Firebase Hosting), STAGING-GATED.
# Always deploys to a private staging URL first; production is a separate,
# explicit confirmation AFTER you've tested staging (e.g. on a real iPhone via
# BrowserStack). Users never see an untested build.
echo ""
echo "============================================"
RK_WEB="n"
read -t 45 -p "🌐 Deploy the WEB version now? (y/N) " RK_WEB || RK_WEB="n"
if [ "$RK_WEB" = "y" ] || [ "$RK_WEB" = "Y" ]; then
    cd ~/RaveKandi-Build
    # Block 20 already produced ./build here for the APK. If it's somehow
    # missing (e.g. web-only run), build it now.
    if [ ! -f "build/index.html" ]; then
        echo "Production build not found — compiling it now..."
        export GENERATE_SOURCEMAP=false
        export NODE_OPTIONS="--max-old-space-size=2048"
        node node_modules/react-scripts/bin/react-scripts.js build
    fi
    if [ ! -f "build/index.html" ]; then
        echo "⚠ Could not produce build/index.html — web deploy aborted."
    else
    cat << 'EOF' > firebase.json
{
  "hosting": {
    "public": "build",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [ { "source": "**", "destination": "/index.html" } ]
  }
}
EOF
    cat << 'EOF' > .firebaserc
{ "projects": { "default": "ravekandi" } }
EOF
    command -v firebase >/dev/null 2>&1 || npm install -g firebase-tools
    if ! firebase projects:list >/dev/null 2>&1; then
        echo "First-time Firebase login — follow the URL it prints, sign in, paste the code back here:"
        firebase login --no-localhost
    fi

    # ---- STAGE 1: deploy to a private preview channel ----
    echo ""
    echo "🧪 Deploying to STAGING (private test URL)..."
    # 'staging' channel kept alive 30 days; re-deploys reuse the same URL.
    STAGE_OUT=$(firebase hosting:channel:deploy staging --expires 30d 2>&1)
    echo "$STAGE_OUT"
    STAGE_URL=$(echo "$STAGE_OUT" | grep -oE 'https://[a-zA-Z0-9.-]*--staging[a-zA-Z0-9.-]*\.web\.app' | head -1)
    if [ -z "$STAGE_URL" ]; then
        echo "⚠ Couldn't capture the staging URL automatically — look for the 'Channel URL' line above."
        STAGE_URL="(see the Channel URL printed above)"
    fi
    echo ""
    echo "============================================"
    echo "🧪 STAGING IS LIVE — TEST IT FIRST:"
    echo "   $STAGE_URL"
    echo ""
    echo "   Open this URL on a REAL iPhone (BrowserStack/LambdaTest free trial,"
    echo "   or any borrowed device). Check: app loads, sign-up works, messaging,"
    echo "   the homepage, and the Festival Spotlight. Watch for ANY crash."
    echo "   This URL is private — your live users do NOT see it."
    echo "============================================"
    echo ""

    # ---- STAGE 2: promote to production ONLY on explicit confirmation ----
    RK_PROD="n"
    read -p "✅ Did STAGING test cleanly? Push to LIVE users now? (y/N) " RK_PROD || RK_PROD="n"
    if [ "$RK_PROD" = "y" ] || [ "$RK_PROD" = "Y" ]; then
        if firebase deploy --only hosting; then
            echo ""
            echo "🌐 PRODUCTION IS LIVE AT: https://ravekandi.web.app"
            echo "   (alias: https://ravekandi.firebaseapp.com)"
            echo "   iPhone users: open that link in Safari → Share → Add to Home Screen."
        else
            echo "⚠ Production deploy failed — check the error above. Staging is unaffected."
        fi
    else
        echo ""
        echo "⏸  Held at staging — production NOT updated, live users untouched."
        echo "   Re-run the build (or: cd ~/RaveKandi-Build && firebase deploy --only hosting) to go live when ready."
        echo "   Test staging again anytime: cd ~/RaveKandi-Build && firebase hosting:channel:deploy staging"
    fi
    fi
else
    echo "Skipped web deploy."
    echo "  Staging:    cd ~/RaveKandi-Build && firebase hosting:channel:deploy staging"
    echo "  Production: cd ~/RaveKandi-Build && firebase deploy --only hosting"
fi
