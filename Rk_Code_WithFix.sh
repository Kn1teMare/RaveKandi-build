#!/bin/bash
# set -e removed — non-zero exits from pkg/gradle killed the build silently
echo "============================================"
echo " RaveKandi V42.10.01 Build Script Starting"
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
    <title>RaveKandi V42.10.01</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
      body { background-color: #0a0014; color: white; margin: 0; padding: 0; }
      @keyframes rkMarquee { from { transform: translateX(0); } to { transform: translateX(-50%); } }
      .rk-marquee-track { display: flex; width: max-content; animation: rkMarquee 60s linear infinite; will-change: transform; }
      @keyframes rkGhostFlash { 0%, 100% { opacity: 0.25; } 50% { opacity: 0.95; } }
      @keyframes rkCascade { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
      .rk-radio-on { background: linear-gradient(60deg, #16ff8e, #00c853, #7CFC00, #16ff8e); background-size: 300% 300%; animation: rkCascade 2.2s linear infinite; box-shadow: 0 0 18px rgba(0,255,140,0.8); }
      .rk-radio-off { background: linear-gradient(45deg, #ff1744, #b71c1c); box-shadow: 0 0 16px rgba(255,23,68,0.75); }
      .rk-pastel-shift { background-size: 300% 300%; -webkit-background-clip: text; background-clip: text; animation: rkCascade 5s ease infinite; }
      .rk-ghost-flash { animation: rkGhostFlash 1.6s ease-in-out infinite; }
    </style>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

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
              {minimized ? `🐞 Bugs (${errorLogs.length})` : 'System Diagnostic Log V42.10.01'}
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
import { getAuth, onAuthStateChanged, setPersistence, browserLocalPersistence, indexedDBLocalPersistence, browserSessionPersistence, signOut, updateEmail, signInWithEmailAndPassword, createUserWithEmailAndPassword, GoogleAuthProvider, TwitterAuthProvider, OAuthProvider, signInWithPopup, signInAnonymously } from 'firebase/auth';
import { getFirestore, initializeFirestore, doc, collection, query, onSnapshot, addDoc, updateDoc, setDoc, deleteDoc, arrayUnion, arrayRemove, where, getDoc, getDocs, orderBy, limit, increment, runTransaction, writeBatch } from 'firebase/firestore';
import { getStorage, ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage';
import { SplashScreen } from '@capacitor/splash-screen';
import { loadStripe } from '@stripe/stripe-js';
import { Elements, CardElement, useStripe, useElements } from '@stripe/react-stripe-js';
import { QRCodeCanvas } from 'qrcode.react';
import { 
  AlertTriangle, Award, Bell, Bot, Box, Briefcase, Calendar, Camera, Check, CheckCircle, ChevronDown, ChevronUp, ChevronLeft, ChevronRight, 
  Clock, Code, Copy, CreditCard, DollarSign, Edit, Eye, Facebook, FileText, Filter, Gift, Globe, Hammer, Heart, 
  Image as ImageIcon, Info, Instagram, LayoutList, Link, Lock, LogOut, Mail, MapPin, MessageSquare, 
  Package, Pencil, Play, PlusCircle, MinusCircle, Receipt, RefreshCw, Save, Send, Settings, Share2, Shield, ShieldCheck, 
  ShoppingBag, Smartphone, Sparkles, Star, Tag, Trash2, Truck, Twitch, Twitter, User, Video, Wallet, 
  Wand2, XCircle, Youtube, Zap, HelpCircle, Search, Phone, Music, Ghost, CheckSquare, Square, Activity, WifiOff, Users, ThumbsUp, MoreHorizontal, ShoppingCart, 
  Trash, Maximize2, List, BarChart3, TrendingUp, Radio, Crown, Music as MusicIcon, Star as StarIcon, Disc
} from 'lucide-react';

const appId = 'ravekandi-core-prod'; 

const firebaseConfig = {
  apiKey: "AIzaSyAg6iiyr3EUXLilmC9O4Mt5oJ4AVbihdr4",
  authDomain: "ravekandi.firebaseapp.com",
  projectId: "ravekandi",
  storageBucket: "ravekandi.firebasestorage.app",
  messagingSenderId: "188727793702",
  appId: "1:188727793702:web:cda6938da639ea61fb2ee7"
};
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
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
const KANDI_TYPES = ['Bracelet', 'Cuff', 'Perler', 'Mask', 'Necklace', 'Clothing', 'Other'];
const NAME_CHANGE_LIMIT_DAYS = 30;
const BIO_CHAR_LIMIT = 200;
const DEV_PIN = "666420";
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
    { id: 'kandi_creator', name: 'Official Creator', tier: 1, metric: 'isKandiCreator', threshold: 1, icon: Hammer, desc: "Submit application and get approved as a Verified Creator." },
    { id: 'collector_1', name: 'Kandi Collector', tier: 1, metric: 'totalItems', threshold: 5, icon: Package, desc: "List at least 5 unique Kandi items in your collection." },
    { id: 'sales_1', name: 'Hustler (Iron)', tier: 1, metric: 'totalSalesValue', threshold: 100, icon: DollarSign, desc: "Complete $100 USD in total processed sales." },
    { id: 'social_1', name: 'Vibe Spreader', tier: 1, metric: 'socialInteractions', threshold: 10, icon: MessageSquare, desc: "Interact with the community." },
    { id: 'ref_1', name: 'PLUR Ambassador', tier: 1, metric: 'referrals', threshold: 1, icon: Users, desc: "Bring 1 new friend to RaveKandi.", isHidden: true },
    { id: 'top_creator', name: 'Crowned Creator', tier: 1, metric: 'topCreatorUnlocked', threshold: 1, icon: Crown, desc: "Reach #1 on the Creator Points leaderboard (sales, value, likes & trades). The badge is yours forever — but the marquee crown passes to whoever currently leads." },
    { id: 'banner_5', name: 'Marquee Mogul', tier: 1, metric: 'bannerPosts', threshold: 5, icon: Zap, desc: "Post 5 banner messages on the live marquee." },
];
const NOTIF_INAPP_TYPES = [{id:'message',label:'Direct Messages'},{id:'comment',label:'Comments'},{id:'like',label:'Likes'},{id:'cart',label:'Cart Adds'},{id:'sold',label:'Item Sold'},{id:'diy',label:'DIY / Requests'},{id:'queue',label:'Creator Queue'},{id:'achievement',label:'Achievements'},{id:'referral',label:'Referrals'},{id:'ticket',label:'Ticket Replies'},{id:'admin',label:'Admin Alerts'}];

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

const Volume = ({size, color}) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2"><path d="M11 5L6 9H2v6h4l5 4V5zM19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"/></svg>;
const SOCIAL_PLATFORMS = [
    { id: 'instagram', name: 'Instagram', icon: Instagram, color: '#E1306C', baseUrl: 'instagram.com/' }, { id: 'twitter', name: 'X / Twitter', icon: Twitter, color: '#1DA1F2', baseUrl: 'twitter.com/' }, { id: 'tiktok', name: 'TikTok', icon: MusicIcon, color: '#00F2EA', baseUrl: 'tiktok.com/@' }, { id: 'snapchat', name: 'Snapchat', icon: Ghost, color: '#FFFC00', baseUrl: 'snapchat.com/add/' }, { id: 'soundcloud', name: 'SoundCloud', icon: Volume, color: '#FF5500', baseUrl: 'soundcloud.com/' }, { id: 'youtube', name: 'YouTube', icon: Youtube, color: '#FF0000', baseUrl: 'youtube.com/@' }, { id: 'twitch', name: 'Twitch', icon: Twitch, color: '#9146FF', baseUrl: 'twitch.tv/' }, { id: 'telegram', name: 'Telegram', icon: MessageSquare, color: '#0088cc', baseUrl: 't.me/' }, { id: 'whatsapp', name: 'WhatsApp', icon: Phone, color: '#25D366', baseUrl: 'wa.me/' }, { id: 'radiate', name: 'Radiate', icon: Activity, color: '#ff00ff', baseUrl: 'radiate.app/' }
];
const ITEM_CATEGORIES = { 'Bead': ['Pony', 'Perler', 'Glass', 'Letter', 'Neon', 'Glow', 'Metallic'], 'String': ['Elastic', 'Nylon', 'Fabric'], 'Charm': ['Plastic', 'Metal', 'Enamel'], 'Trinket': ['Alien head', 'Mushroom', 'Doll'], 'Other': ['Custom'] };
const ITEM_SIZES = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'Huge'];
EOF

# Block 5
cat << 'EOF' >> src/App.js
const getTextGlowStyle = (color = 'primaryGlow') => ({ textShadow: `0 0 10px ${NEON_COLORS[color]}, 0 0 20px ${NEON_COLORS[color]}`, fontFamily: '"Inter", sans-serif' });
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
const SAFE_SOCIAL_HOSTS = ['instagram.com','tiktok.com','twitter.com','x.com','youtube.com','youtu.be','facebook.com','twitch.tv','soundcloud.com','spotify.com','open.spotify.com','discord.gg','discord.com','linktr.ee','threads.net','snapchat.com','reddit.com','t.me','wa.me','radiate.app'];
const BLOCKED_SHORTENERS = ['bit.ly','tinyurl.com','t.co','goo.gl','rb.gy','cutt.ly','is.gd','shorturl.at','ow.ly','rebrand.ly'];
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

export const pushNotif = async (toUid, type, text, refId = null) => {
    if (!toUid || toUid === 'guest') return;
    try { await addDoc(collection(db, 'artifacts', appId, 'users', toUid, 'notifications'), { type, text, refId, read: false, at: Date.now() }); } catch (e) {}
};

export const sendDirectMessage = async (fromUid, fromName, toUid, toName, text) => {
    const tid = [fromUid, toUid].sort().join('_');
    const key = rkKey(fromUid, toUid);
    const enc = rkEnc(text, key);
    const tRef = doc(db, 'artifacts', appId, 'public', 'data', 'threads', tid);
    await setDoc(tRef, { participants: [fromUid, toUid].sort(), names: { [fromUid]: fromName || 'Raver', [toUid]: toName || 'Raver' }, lastMessage: enc, lastAt: Date.now(), lastSender: fromUid, unread: { [toUid]: increment(1) } }, { merge: true });
    await addDoc(collection(tRef, 'messages'), { sender: fromUid, text: enc, at: Date.now() });
    pushNotif(toUid, 'message', (fromName || 'Someone') + ' sent you a message', tid);
    return tid;
};

export const ensureUserExists = async (uid, customName = null, referrerUid = null) => {
    if (!uid) return;
    const userRef = doc(db, 'artifacts', appId, 'users', uid);
    const globalStatsRef = doc(db, 'artifacts', appId, 'global', 'stats');
    let createdName = null;
    try {
        await runTransaction(db, async (transaction) => {
            const userDoc = await transaction.get(userRef);
            if (!userDoc.exists()) {
                let globalStats = await transaction.get(globalStatsRef);
                let currentCount = 0;
                if (globalStats.exists()) { currentCount = globalStats.data().userCount || 0; } 
                else { transaction.set(globalStatsRef, { userCount: 0 }); }

                const newCount = currentCount + 1;
                const newUsername = customName || `Raver${String(currentCount).padStart(2, '0')}`;
                createdName = newUsername;

                transaction.set(userRef, { 
                    displayName: newUsername, publicUid: uid, publicUidChanged: false, pastPublicUids: [],
                    usernameChangesLeft: 3, pastUsernames: [], joined: Date.now(), items: [], totalSalesValue: 0, totalBoughtValue: 0,
                    itemsSold: 0, itemsBought: 0, totalLikes: 0, totalComments: 0, badgesCollected: 0,
                    referrals: 0, completedTrades: 0, socialInteractions: 0, aiUsageCount: 0, lastAiReset: 0,
                    referredBy: referrerUid || null, totalRevShareEarned: 0, customCommissionRate: null,
                    isVIP: false, customBackground: null, showPing: true, featuredBadge: null, customRevSharePct: null, bannedUntil: null
                });
                transaction.update(globalStatsRef, { userCount: newCount });
                
                if (referrerUid) {
                    const refUserRef = doc(db, 'artifacts', appId, 'users', referrerUid);
                    const refUserDoc = await transaction.get(refUserRef);
                    if (refUserDoc.exists()) {
                        transaction.update(refUserRef, { referrals: (refUserDoc.data().referrals || 0) + 1 });
                        const refListRef = doc(db, 'artifacts', appId, 'users', referrerUid, 'myReferrals', uid);
                        transaction.set(refListRef, { uid: uid, displayName: newUsername, earnedFromThisUser: 0, timestamp: Date.now() });
                    }
                }
            }
        });
        if (createdName && referrerUid) pushNotif(referrerUid, 'referral', '🎉 ' + createdName + ' just joined RaveKandi using your code! +1 referral');
    } catch (e) { console.error("User Creation Error", e); }
};

const compressImage = (file, onProgress) => new Promise((resolve, reject) => {
    const reader = new FileReader(); 
    reader.onprogress = (data) => { if (data.lengthComputable && onProgress) { onProgress(parseInt(((data.loaded / data.total) * 50), 10)); } };
    reader.readAsDataURL(file);
    reader.onload = (e) => { 
        if(onProgress) onProgress(60);
        const img = new Image(); 
        img.src = e.target.result; 
        img.onload = () => { 
            if(onProgress) onProgress(80);
            const cvs = document.createElement('canvas'); 
            const scale = Math.min(1, 400 / img.width);
            cvs.width = img.width * scale; cvs.height = img.height * scale; 
            cvs.getContext('2d').drawImage(img, 0, 0, cvs.width, cvs.height); 
            const result = cvs.toDataURL('image/jpeg', 0.5);
            if(onProgress) onProgress(100);
            resolve(result); 
        }; 
    }; 
    reader.onerror = reject;
});

const generateCustomKandi = async (prompt, onProgress = () => {}) => {
    try {
        const seed = Math.floor(Math.random() * 9999999);
        const safePrompt = encodeURIComponent(`Rave kandi beads, festival apparel: ${prompt}`);
        const textUrl = `https://text.pollinations.ai/prompt/You%20are%20a%20master%20Rave%20Kandi%20builder.%20The%20user%20wants:%20${safePrompt}.%20Return%20ONLY%20a%20JSON%20object%20with%20NO%20MARKDOWN.%20Format:%20{%22visual_description%22:%22detailed%20description%22,%22total_bead_count%22:150,%22difficulty_1_to_10%22:6,%22estimated_materials%22:[{%22name%22:%22string%22,%22qty%22:%22string%22}]}`;
        
        // V37.11: the text endpoint intermittently returns 5xx / rate-limits — retry with
        // backoff, then fall back to a structural template instead of crashing the Lab
        // (was: "AI Assembly Failed: AI Text endpoint failed").
        onProgress(8);
        let rawText = '';
        for (let tAttempt = 0; tAttempt < 3; tAttempt++) {
            try {
                const response = await fetch(textUrl, { cache: 'no-store' });
                if (response.ok) { rawText = await response.text(); if (rawText && rawText.length > 5) break; }
            } catch (tErr) { console.log('AI text attempt ' + (tAttempt + 1) + ' failed.'); }
            await new Promise(r => setTimeout(r, 4000));
        }
        
        let analysis;
        try {
            const cleanText = rawText.replace(/```json/g, '').replace(/```/g, '').trim();
            const jsonMatch = cleanText.match(/\{[\s\S]*\}/);
            if (jsonMatch) { analysis = JSON.parse(jsonMatch[0]); } 
            else { analysis = JSON.parse(cleanText); }
        } catch (parseError) {
            console.warn("AI returned malformed JSON. Using structural fallback.", rawText);
            analysis = {
                visual_description: prompt.substring(0, 150),
                total_bead_count: 150,
                difficulty_1_to_10: 5,
                estimated_materials: [{ name: "Assorted Kandi Beads", qty: "150" }, { name: "Elastic String", qty: "12 inches" }]
            };
        }

        const cleanVisual = (analysis.visual_description || prompt).replace(/[^a-zA-Z0-9 ]/g, '').substring(0, 100);
        const visualStr = encodeURIComponent(`Macro photography rave kandi ${cleanVisual}`);
        const imageUrl = `https://image.pollinations.ai/prompt/${visualStr}?width=512&height=512&seed=${seed}&nologo=true`;

        // V37.14: pre-fetch with 6 retries (~60s budget) and progress reporting.
        // Pollinations generates on first request and can take a full minute while queued.
        onProgress(32);
        let displayUrl = imageUrl;
        for (let attempt = 0; attempt < 6; attempt++) {
            onProgress(Math.min(90, 36 + attempt * 9));
            try {
                const imgResp = await fetch(imageUrl, { cache: 'no-store' });
                if (imgResp.ok) {
                    const blob = await imgResp.blob();
                    if (blob && blob.size > 2000) { displayUrl = URL.createObjectURL(blob); break; }
                }
            } catch (imgErr) { console.log('AI image attempt ' + (attempt + 1) + ' failed, retrying...'); }
            await new Promise(r => setTimeout(r, 8000));
        }
        onProgress(95);
        
        const beads = analysis.total_bead_count || 100;
        const diff = analysis.difficulty_1_to_10 || 5;
        let estCost = ((beads * 0.05) + (diff * 2.00)) * PROFIT_MARGIN;
        if(estCost < 4.00) estCost = 4.00;
        
        return { ...analysis, imageUrl, displayUrl, estimated_cost: estCost.toFixed(2), difficulty: diff };
    } catch (e) { throw new Error("AI Assembly Failed: " + e.message); }
};

const getDisplayAchievements = (profile) => {
    const stats = { totalItems: profile?.items?.length || 0, totalSalesValue: profile?.totalSalesValue || 0, isKandiCreator: profile?.isKandiCreator?1:0, socialInteractions: profile?.socialInteractions||0, referrals: profile?.referrals||0, topCreatorUnlocked: profile?.topCreatorUnlocked?1:0, bannerPosts: profile?.bannerPosts||0 };
    return ACHIEVEMENT_TIERS.filter(ach => ach.tier === 1 || stats[ach.metric] >= ach.threshold).map(ach => ({ ...ach, unlocked: stats[ach.metric] >= ach.threshold }));
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

const Input = ({ label, value, onChange, type = 'text', options, className, placeholder, maxLength, disabled, autoComplete, name }) => ( <div className={`mb-4 ${className}`}>{label && <label className="block text-sm font-bold mb-1" style={getTextGlowStyle('purpleGlow')}>{label}</label>}{type === 'select' ? (<select disabled={disabled} value={value} onChange={e => onChange(e.target.value)} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none text-white"><option value="">Select</option>{options.map(o => <option key={o} value={o} className="text-black">{o}</option>)}</select>) : type === 'textarea' ? (<textarea disabled={disabled} value={value} onChange={e => onChange(e.target.value)} rows="3" maxLength={maxLength} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none" placeholder={placeholder}/>) : (<input name={name} autoComplete={autoComplete} disabled={disabled} type={type} value={value} onChange={e => onChange(e.target.value)} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none" placeholder={placeholder}/>)}</div> );

const Modal = ({ isOpen, onClose, title, children }) => { if (!isOpen) return null; return createPortal( <div className="fixed inset-0 bg-black/90 z-50 overflow-y-auto" onClick={(e) => e.stopPropagation()}><div className="flex min-h-full items-center justify-center p-4"><Card className="max-w-md w-full my-4" glow="primaryGlow"><div className="flex justify-between items-center mb-4 border-b border-white/20 pb-2"><h3 className="text-xl font-bold" style={getTextGlowStyle('primaryGlow')}>{title}</h3><button onClick={onClose}><XCircle/></button></div>{children}</Card></div></div>, document.body ); };

const MediaCarousel = ({ media, fallback }) => {
    const [idx, setIdx] = useState(0);
    if (!media || media.length === 0) return <img src={fallback} className="w-full h-full object-cover" />;
    const current = media[idx];
    return (
        <div className="relative group w-full h-full bg-black overflow-hidden flex items-center justify-center">
            {current.type === 'video' ? (
                <video src={current.url} controls autoPlay muted loop className="max-w-full max-h-full object-contain" />
            ) : (
                <img src={current.url} className="max-w-full max-h-full object-contain" />
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
        const newComment = { text: comment, user: profile?.displayName || user.displayName || 'Raver', uid: profile?.publicUid || user.uid, badge: profile?.featuredBadge || null, time: Date.now() }; 
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
                    <div key={i} className="bg-white/5 p-2 rounded text-sm">
                        <span className="font-bold text-pink-400 cursor-pointer hover:underline" onClick={() => { onClose(); onViewProfile(c.uid); }}>{c.user}</span><BadgeChip badge={c.badge} />: {c.text}
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
        if(!u || u.length < 3) return alert("Min 3 characters");
        setLoading(true);
        try {
            let newChangesLeft = changesLeft;
            let newLastChange = lastChange;
            if(changesLeft > 0) { newChangesLeft -= 1; if(newChangesLeft === 0) newLastChange = Date.now(); } 
            else if (cooldownOver) { newLastChange = Date.now(); }

            const newPastNames = [...pastNames, profile.displayName];
            const batch = writeBatch(db);
            const userRef = doc(db, 'artifacts', appId, 'users', user.uid);
            batch.update(userRef, { displayName: u, usernameChangesLeft: newChangesLeft, lastUsernameChange: newLastChange, pastUsernames: newPastNames });
            
            const qTradeAll = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'));
            const allPosts = await getDocs(qTradeAll);
            allPosts.forEach(docSnap => {
                const data = docSnap.data();
                let changed = false;
                let updatedComments = data.comments || [];
                if (updatedComments.some(c => c.uid === user.uid || c.uid === profile?.publicUid)) {
                    updatedComments = updatedComments.map(c => (c.uid === user.uid || c.uid === profile?.publicUid) ? { ...c, user: u } : c);
                    changed = true;
                }
                if (data.ownerId === user.uid) changed = true;
                if (changed) {
                    batch.update(docSnap.ref, { ...(data.ownerId === user.uid ? { ownerName: u } : {}), comments: updatedComments });
                }
            });

            const qInv = query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'));
            const invs = await getDocs(qInv);
            invs.forEach(doc => { batch.update(doc.ref, { ownerName: u }); });

            await batch.commit();
            alert("Username synced across the app!"); 
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
    useEffect(() => {
        setTarg(null); // V37.13.01: clear stale profile between opens
        if(!uid) return;
        const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', uid));
        getDocs(q).then(snap => {
            if(!snap.empty) { setTarg({ ...snap.docs[0].data(), id: snap.docs[0].id }); }
            else {
                getDoc(doc(db, 'artifacts', appId, 'users', uid))
                    .then(s => { if(s.exists()) setTarg({ ...s.data(), id: s.id }); else setTarg('not_found'); })
                    .catch(e => { console.log('Profile load (direct) failed', e); setTarg('error'); });
            }
        }).catch(e => { console.log('Profile load failed', e); setTarg('error'); });
    }, [uid]);
    if(!uid) return null;
    return (
        <Modal isOpen={!!uid} onClose={onClose} title={targ === 'not_found' ? "Not Found" : targ === 'error' ? "Connection Issue" : (targ?.displayName ? '@' + targ.displayName : 'Loading...')}>
            {targ === 'not_found' ? <p className="opacity-50 text-center">User no longer exists.</p>
            : targ === 'error' ? <p className="text-red-300 text-xs text-center py-4">Couldn't load this profile. Check your connection and try again.</p>
            : !targ ? <div className="py-6"><LoadingBar className="w-full"/><p className="text-center text-[10px] opacity-50 mt-2">Loading profile...</p></div> : (
                <div className="text-center space-y-4">
                    <img src={targ.photoURL || 'https://placehold.co/100?text=User'} className="w-24 h-24 rounded-full mx-auto object-cover border-2 border-pink-500"/>
                    <div>
                        <p className="font-black text-lg flex items-center justify-center" style={getTextGlowStyle('primaryGlow')}>@{targ.displayName || 'Raver'}<BadgeChip badge={targ.featuredBadge} /></p>
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
                alert(plan === 'monthly' ? "VIP Monthly active until " + new Date(vipExpires).toLocaleDateString() + "! Renewing later stacks +30 days." : "VIP Lifetime unlocked! Enjoy Radio, Themes, Banner Messages & Post Boosts forever.");
            } catch(err) { console.error(err); }
            setLoading(false);
            onClose();
        }, 1500);
    };

    return (
        <form onSubmit={handleVIPSuccess} className="text-center space-y-4">
            <Crown size={48} className="mx-auto text-yellow-400 mb-2" />
            <div className="text-left bg-white/5 p-3 rounded border border-white/10 text-[11px] space-y-1">
                <p className="font-bold text-yellow-400 uppercase text-[10px] tracking-widest mb-1">VIP unlocks:</p>
                <p>🎧 Global EDM Radio Player</p>
                <p>🖼️ Custom App Backgrounds & Themes</p>
                <p>📢 Banner Messages on the live marquee</p>
                <p>⚡ Post Boosts — pin your items to the top of the feed</p>
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
                <p className="text-xs opacity-70">Paste an image URL, or upload a file directly to replace the app's default dark background.</p>
                <div className="bg-black/50 border border-purple-500/40 p-3 rounded">
                    <h4 className="text-[10px] uppercase font-bold text-purple-400 mb-2 flex items-center gap-1"><Sparkles size={12}/> RaveKandi Official Themes</h4>
                    <div className="grid grid-cols-3 gap-2">
                        {[1,2,3].map(n => (
                            <div key={n} className="h-16 rounded border border-dashed border-white/20 bg-white/5 flex flex-col items-center justify-center opacity-60">
                                <Lock size={12} className="text-purple-400 mb-1"/>
                                <span className="text-[7px] uppercase font-bold text-center leading-tight">HD Animated<br/>Coming Soon</span>
                            </div>
                        ))}
                    </div>
                    <p className="text-[8px] opacity-50 mt-2">Exclusive animated HD backgrounds made by the RaveKandi team — dropping in a future update.</p>
                </div>
                <Input value={url} onChange={setUrl} placeholder="https://my-custom-gif.com/image.gif" />
                <div className="bg-white/5 p-3 rounded border border-white/10">
                    <label className="text-[10px] font-bold text-pink-400 mb-1 block">Upload Background</label>
                    <input type="file" accept="image/*" onChange={handleFile} className="text-[10px] w-full" disabled={uploading}/>
                    {uploading && <p className="text-[10px] text-lime-400 mt-1">Processing...</p>}
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

const EqSlider = ({ label, value, min, max, onChange, suffix }) => (
    <div className="mb-3">
        <div className="flex justify-between text-[10px] font-bold mb-1"><span className="text-cyan-400 uppercase tracking-widest">{label}</span><span className="text-lime-400">{value}{suffix}</span></div>
        <input type="range" min={min} max={max} value={value} onChange={e => onChange(parseInt(e.target.value))} className="w-full accent-pink-500 h-2" />
    </div>
);

const RadioPlayerModal = ({ user, profile, isOpen, onClose, onGoVip, onPlayingChange, onNowPlaying }) => {
    const [consent, setConsent] = useState(() => { try { return localStorage.getItem('rk_audio_consent') === 'true'; } catch(e) { return false; } });
    const [station, setStation] = useState(RADIO_STATIONS[0]);
    const [playing, setPlaying] = useState(false);
    const [status, setStatus] = useState('Select a station and press play.');
    const [volume, setVolume] = useState(80);
    const [bass, setBass] = useState(0);
    const [mid, setMid] = useState(0);
    const [treble, setTreble] = useState(0);
    const [eqActive, setEqActive] = useState(false);

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
            <audio ref={audioRef} crossOrigin="anonymous" onError={() => { if (playing) { setPlaying(false); setStatus('Station unreachable. Try another.'); } }} />
            {isOpen && (
                <div className="fixed inset-0 bg-black/90 z-[200] flex items-center justify-center p-4 overflow-y-auto">
                    <Card className="max-w-md w-full my-8 bg-[#0f001e]/95" glow="purpleGlow">
                        <div className="flex justify-between items-center mb-4 border-b border-white/20 pb-2">
                            <h3 className="text-xl font-black italic flex items-center gap-2" style={getTextGlowStyle('purpleGlow')}><Radio size={20}/> RAVE RADIO</h3>
                            <button onClick={onClose}><XCircle/></button>
                        </div>
                        {!profile?.isVIP ? (
                            <div className="text-center py-6 space-y-4">
                                <Crown size={48} className="mx-auto text-yellow-400"/>
                                <p className="text-sm text-white">Rave Radio is a <strong>VIP</strong> feature. Unlock 8 live electronic stations, a full EQ, and custom backgrounds for a one-time $5.</p>
                                <Button onClick={onGoVip} color="gold" className="w-full">Unlock VIP</Button>
                            </div>
                        ) : !consent ? (
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
                                <div className="grid grid-cols-2 gap-2 max-h-44 overflow-y-auto pr-1">
                                    {RADIO_STATIONS.map(st => (
                                        <button key={st.id} onClick={() => playStation(st)} className={'p-2 rounded-lg border text-left transition-all ' + (station.id === st.id ? 'bg-white/10' : 'bg-black/40 hover:bg-white/5')} style={{ borderColor: station.id === st.id ? st.color : 'rgba(255,255,255,0.15)', boxShadow: station.id === st.id ? '0 0 10px ' + st.color : 'none' }}>
                                            <p className="text-xs font-black" style={{ color: st.color }}>{st.name}</p>
                                            <p className="text-[8px] text-white/60 uppercase">{st.genre}</p>
                                        </button>
                                    ))}
                                </div>
                                <div className="flex justify-center">
                                    <button onClick={togglePlay} className="w-16 h-16 rounded-full border-2 flex items-center justify-center transition-transform active:scale-90 bg-black/50" style={{ borderColor: station.color, boxShadow: '0 0 15px ' + station.color, color: station.color }}>
                                        {playing ? <span className="font-black text-[10px] tracking-widest">PAUSE</span> : <Play size={28} fill="currentColor"/>}
                                    </button>
                                </div>
                                <div className="bg-white/5 p-3 rounded border border-white/10">
                                    <EqSlider label="Volume" value={volume} min={0} max={100} onChange={setVolume} suffix="%" />
                                    <EqSlider label="Bass" value={bass} min={-12} max={12} onChange={setBass} suffix=" dB" />
                                    <EqSlider label="Mid" value={mid} min={-12} max={12} onChange={setMid} suffix=" dB" />
                                    <EqSlider label="Treble" value={treble} min={-12} max={12} onChange={setTreble} suffix=" dB" />
                                    {!eqActive && <p className="text-[8px] text-yellow-400/80 text-center mt-1">EQ activates when playback starts.</p>}
                                </div>
                                <p className="text-[8px] text-center text-white/40">Live streams powered by SomaFM.com</p>
                            </div>
                        )}
                    </Card>
                </div>
            )}
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
    if (!isOpen) return null;
    const code = profile?.publicUid || user?.uid || '';
    const shareText = 'Join me on RaveKandi! Use my Friend UID "' + code + '" when you sign up and we both earn RevShare on the marketplace. PLUR!';
    const doCopy = () => { try { navigator.clipboard.writeText(code); alert("Friend UID copied!"); } catch(e) { alert(code); } };
    const doShare = async () => {
        try { await navigator.share({ title: 'RaveKandi RevShare', text: shareText }); }
        catch (e) { try { navigator.clipboard.writeText(shareText); alert("Share text copied! Paste it anywhere."); } catch(e2) {} }
    };
    const doStory = async () => {
        try { await navigator.share({ title: 'RaveKandi', text: shareText + ' #RaveKandi #PLUR' }); }
        catch (e) { try { navigator.clipboard.writeText(shareText + ' #RaveKandi #PLUR'); alert("Story caption copied! Open your social app and paste it into a new Story."); } catch(e2) {} }
    };
    const pct = profile?.customRevSharePct ?? getReferralTier(profile?.referrals || 0).sharePct;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="RevShare Program">
            <div className="space-y-4">
                <div className="bg-lime-900/20 border border-lime-500/40 p-3 rounded text-sm text-gray-100 leading-relaxed">
                    Share your Friend UID. When friends sign up with it, you earn a percentage of the app's commission on <strong>everything they buy — for life</strong>. More referrals = higher tier = bigger cut, up to <strong>25% of the commission</strong> at Eternal Rave.
                </div>
                <div className="bg-black/60 border border-white/20 rounded p-3 text-center">
                    <p className="text-[9px] uppercase opacity-60 mb-1">Your Friend UID</p>
                    <p className="font-mono text-lg font-black text-lime-400 break-all">{code}</p>
                    <p className="text-[9px] mt-1 text-cyan-400">Current RevShare Rate: {pct}%</p>
                </div>
                <div className="grid grid-cols-3 gap-2">
                    <Button onClick={doCopy} color="cyan" className="text-[10px] flex flex-col items-center gap-1 py-3"><Copy size={16}/> Copy</Button>
                    <Button onClick={doShare} color="purple" className="text-[10px] flex flex-col items-center gap-1 py-3"><Share2 size={16}/> Share</Button>
                    <Button onClick={doStory} color="primary" className="text-[10px] flex flex-col items-center gap-1 py-3"><Camera size={16}/> Story</Button>
                </div>
                <p className="text-[9px] text-center opacity-50">Share opens your phone's share sheet — send to any app, DM, or post straight to your Story.</p>
            </div>
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
                category, subject: subject.trim(), message: message.trim(), status: 'open', createdAt: Date.now(), appVersion: 'V42.10.01'
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

const NOTIF_ICONS = { message: Mail, comment: MessageSquare, like: Heart, cart: ShoppingCart, sold: DollarSign, diy: Hammer, queue: Briefcase, achievement: Award, referral: Users, ticket: HelpCircle, admin: Shield };

const MessengerModal = ({ user, profile, isOpen, onClose, threads, notifs, initialTarget, onConsumeTarget }) => {
    const [tab, setTab] = useState('msgs');
    const [activeThread, setActiveThread] = useState(null);
    const [activeName, setActiveName] = useState('');
    const [msgs, setMsgs] = useState([]);
    const [input, setInput] = useState('');
    const [term, setTerm] = useState('');
    const [sortMode, setSortMode] = useState('recent');
    const [notifFilter, setNotifFilter] = useState('all');
    const [searchHit, setSearchHit] = useState(null);
    const [sending, setSending] = useState(false);

    const myUid = user?.uid;
    const otherOf = (t) => (t.participants || []).find(p => p !== myUid) || myUid;

    // live messages for the open thread
    useEffect(() => {
        if (!isOpen || !activeThread) { setMsgs([]); return; }
        const q = query(collection(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread, 'messages'), orderBy('at', 'asc'));
        const unsub = onSnapshot(q, s => setMsgs(s.docs.map(d => ({ ...d.data(), id: d.id }))), e => console.log('msgs', e));
        // mark thread read
        setDoc(doc(db, 'artifacts', appId, 'public', 'data', 'threads', activeThread), { unread: { [myUid]: 0 } }, { merge: true }).catch(()=>{});
        return () => unsub();
    }, [isOpen, activeThread]);

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
            setActiveThread(tid); setActiveName(initialTarget.name || 'Raver'); setTab('msgs');
            if (onConsumeTarget) onConsumeTarget();
        }
    }, [isOpen, initialTarget]);

    // user search (exact Friend UID, then exact username); button = loud, typing = quiet
    const runSearch = async (tv, loud) => {
        const t = (tv || '').trim();
        setSearchHit(null);
        if (t.length < 2) { if (loud) alert('Type a Friend UID or exact username first.'); return; }
        try {
            let snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', t)));
            if (snap.empty) snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('displayName', '==', t)));
            if (!snap.empty && snap.docs[0].id !== myUid) setSearchHit({ id: snap.docs[0].id, ...snap.docs[0].data() });
            else if (loud) alert('No raver found with that exact UID or username.');
        } catch (e) { if (loud) alert('Search failed: ' + e.message); }
    };
    useEffect(() => {
        if (!isOpen || tab !== 'msgs' || term.trim().length < 3) { setSearchHit(null); return; }
        const h = setTimeout(() => runSearch(term, false), 600);
        return () => clearTimeout(h);
    }, [term, isOpen, tab]);

    if (!isOpen) return null;

    const openThreadWith = (otherUid, otherName) => {
        const tid = [myUid, otherUid].sort().join('_');
        setActiveThread(tid); setActiveName(otherName || 'Raver'); setTerm(''); setSearchHit(null);
    };

    const send = async () => {
        if (!input.trim() || !activeThread || sending) return;
        setSending(true);
        try {
            const otherUid = activeThread.split('_').find(p => p !== myUid) || myUid;
            await sendDirectMessage(myUid, profile?.displayName || 'Raver', otherUid, activeName, input.trim());
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
            setActiveThread(null);
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
    list = list.sort((a, b) => ((b.favorites?.[myUid] ? 1 : 0) - (a.favorites?.[myUid] ? 1 : 0)) || ((b.lastAt || 0) - (a.lastAt || 0)));

    const visNotifs = notifs.filter(n => (profile?.inAppNotifs?.[n.type] !== false) && (notifFilter === 'all' || n.type === notifFilter));
    const unreadAlertCount = notifs.filter(n => !n.read).length;
    const threadKey = activeThread ? rkKey(...activeThread.split('_')) : null;

    return createPortal(
        <div className="fixed inset-0 bg-black/90 z-[70] overflow-y-auto" onClick={(e) => e.stopPropagation()}>
            <div className="flex min-h-full items-center justify-center p-3">
                <Card className="max-w-md w-full my-2 flex flex-col" glow="purpleGlow">
                    <div className="flex justify-between items-center mb-3 border-b border-white/20 pb-2">
                        <h3 className="text-lg font-black uppercase italic tracking-widest" style={getTextGlowStyle('purpleGlow')}>Messenger</h3>
                        <button onClick={() => { setActiveThread(null); onClose(); }}><XCircle/></button>
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
                            <select value={sortMode} onChange={e => setSortMode(e.target.value)} className="bg-black border border-white/20 text-[10px] p-2 rounded">
                                <option value="recent">Recent</option><option value="favorites">Favorites</option><option value="unread">Unread</option><option value="read">Read</option>
                            </select>
                        </div>
                        {searchHit && (
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
                                    <div key={t.id} className={`flex items-center gap-2 p-2 rounded border ${un > 0 ? 'bg-purple-900/30 border-purple-400/50' : 'bg-white/5 border-white/10'}`}>
                                        <button onClick={() => toggleFav(t)} className={t.favorites?.[myUid] ? 'text-yellow-400' : 'text-white/20'}><Star size={14} fill={t.favorites?.[myUid] ? 'currentColor' : 'none'}/></button>
                                        <button onClick={() => openThreadWith(other, t.names?.[other])} className="flex-1 min-w-0 text-left">
                                            <p className="text-xs font-bold truncate flex items-center gap-1">@{t.names?.[other] || 'Raver'} {un > 0 && <span className="bg-pink-600 text-white text-[8px] font-black rounded-full px-1.5">{un}</span>}</p>
                                            <p className="text-[10px] opacity-50 truncate">{t.lastSender === myUid ? 'You: ' : ''}{preview}</p>
                                        </button>
                                        <span className="text-[8px] opacity-40 shrink-0">{t.lastAt ? new Date(t.lastAt).toLocaleDateString() : ''}</span>
                                    </div>
                                );
                            })}
                        </div>
                        <p className="text-[8px] text-center text-lime-400/70 mt-3">🔒 All chats are encrypted — only you and the recipient can read them.</p>
                    </>)}

                    {tab === 'msgs' && activeThread && (<>
                        <div className="flex items-center justify-between mb-2 bg-white/5 rounded p-2">
                            <button onClick={() => setActiveThread(null)} className="flex items-center gap-1 text-[10px] text-cyan-400 font-bold"><ChevronLeft size={14}/> Back</button>
                            <span className="text-xs font-black">@{activeName}</span>
                            <button onClick={delThread} className="text-red-400" title="Delete chat log"><Trash2 size={14}/></button>
                        </div>
                        <div className="h-[40vh] overflow-y-auto bg-black/40 rounded p-2 space-y-2 flex flex-col">
                            {msgs.length === 0 && <p className="text-center opacity-40 text-[10px] py-8">No messages yet. Say hi! 👋</p>}
                            {msgs.map(m => {
                                const mine = m.sender === myUid;
                                return (
                                    <div key={m.id} className={`max-w-[80%] ${mine ? 'self-end' : 'self-start'}`}>
                                        <div className={`p-2 rounded-lg text-xs relative group ${mine ? 'bg-purple-600/60 rounded-br-none' : 'bg-white/10 rounded-bl-none'}`}>
                                            <p className="whitespace-pre-wrap break-words">{rkDec(m.text, threadKey)}</p>
                                            {mine && <button onClick={() => delMsg(m)} className="absolute -left-5 top-1 text-red-400 opacity-40 hover:opacity-100"><Trash size={11}/></button>}
                                        </div>
                                        <p className={`text-[7px] opacity-40 mt-0.5 ${mine ? 'text-right' : ''}`}>{new Date(m.at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</p>
                                    </div>
                                );
                            })}
                        </div>
                        <div className="flex gap-2 mt-2">
                            <Input value={input} onChange={setInput} placeholder="Spread PLUR..." className="mb-0 flex-1"/>
                            <Button onClick={send} disabled={sending || !input.trim()} color="purple" className="text-[10px] px-3"><Send size={14}/></Button>
                        </div>
                        <p className="text-[8px] text-center text-lime-400/70 mt-2">🔒 Encrypted · Deleted messages are gone forever for both users.</p>
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
                                    <div key={n.id} className={`flex items-start gap-2 p-2 rounded border ${!n.read ? 'bg-pink-900/20 border-pink-500/40' : 'bg-white/5 border-white/10 opacity-70'}`}>
                                        <Icon size={14} className="text-pink-400 shrink-0 mt-0.5"/>
                                        <div className="flex-1 min-w-0">
                                            <p className="text-[11px] text-gray-100 break-words">{n.text}</p>
                                            <p className="text-[8px] opacity-40">{new Date(n.at).toLocaleString()}</p>
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

            {bTab === 'post' && (!profile?.isVIP ? (
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

            {bTab === 'boost' && (!profile?.isVIP ? (
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
const MainSettingsModal = ({ user, profile, isOpen, onClose }) => { 
    const [showTicket, setShowTicket] = useState(false);
    const [phone, setPhone] = useState('');
    const [email, setEmail] = useState(''); 
    const [prefs, setPrefs] = useState({ phone: {}, email: {} });
    const [newUid, setNewUid] = useState('');
    const [loading, setLoading] = useState(false);

    useEffect(() => { 
        if(profile?.notificationPreferences) setPrefs(profile.notificationPreferences); 
        if(profile?.phoneNumber) setPhone(profile.phoneNumber); 
        if(user?.email) setEmail(user.email); 
    }, [profile, user]);
    
    const togglePref = (type, channel) => { setPrefs(prev => ({ ...prev, [channel]: { ...prev[channel], [type]: !prev[channel]?.[type] } })); };
    const toggleAdmin = async () => { if(!user?.uid) return; const pin = prompt("Enter DevCode (PIN):"); if(pin === DEV_PIN) { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { isAdmin: true, isKandiCreator: true }, { merge: true }); alert("DevMode Activated."); } else { alert("Invalid DevCode."); } };
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
        <div className="border-b border-white/10 pb-4"><h4 className="font-bold text-xs mb-3 text-cyan-400">Notifications</h4><div className="grid grid-cols-3 gap-2 text-[10px] mb-2 font-bold opacity-70"><span>Type</span><span className="text-center">Phone</span><span className="text-center">Email</span></div>{NOTIFICATION_TYPES.map(type => (<div key={type.id} className="grid grid-cols-3 gap-2 items-center mb-2 text-[10px]"><span className="truncate">{type.label}</span><div className="flex justify-center"><button onClick={() => togglePref(type.id, 'phone')} className={`${prefs.phone?.[type.id] ? 'text-lime-400' : 'text-white/20'}`}>{prefs.phone?.[type.id] ? <CheckSquare size={16}/> : <Square size={16}/>}</button></div><div className="flex justify-center"><button onClick={() => togglePref(type.id, 'email')} className={`${prefs.email?.[type.id] ? 'text-lime-400' : 'text-white/20'}`}>{prefs.email?.[type.id] ? <CheckSquare size={16}/> : <Square size={16}/>}</button></div></div>))}</div>
        <div className="border-b border-white/10 pb-4">
            <h4 className="font-bold text-xs mb-2 text-lime-400">Display</h4>
            <button onClick={async () => { await setDoc(doc(db, 'artifacts', appId, 'users', user.uid), { showPing: profile?.showPing === false ? true : false }, { merge: true }); }} className="w-full flex justify-between items-center bg-white/5 p-2 rounded border border-white/10">
                <span className="text-[10px] font-bold">Show Ping (connection meter)</span>
                {profile?.showPing !== false ? <CheckSquare size={16} className="text-lime-400"/> : <Square size={16} className="text-white/30"/>}
            </button>
            <p className="text-[8px] opacity-50 mt-1">Displays live network latency at the bottom of the screen. On by default for new accounts.</p>
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

        <div className="border-b border-white/10 pb-4">
            <h4 className="font-bold text-xs mb-2 text-yellow-400">Support</h4>
            <Button onClick={() => setShowTicket(true)} color="accent" className="w-full text-[10px] flex items-center justify-center gap-2"><HelpCircle size={14}/> Report a Bug / Get Help</Button>
        </div>

        <Button onClick={saveSettings} color="lime" className="w-full text-xs">Save Changes</Button>
        <div className="flex gap-2 mt-4"><Button onClick={toggleAdmin} color="purple" className="flex-1 text-[10px]">DevMode</Button><Button onClick={handleLogout} color="accent" className="flex-1 text-[10px] bg-red-900/50 border-red-500">{user?.isAnonymous ? "Create Account" : "Log Out"}</Button></div>
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
    const totalCost = enriched.filter(item => selectedIds.includes(item.id) && item.liveStatus === 'available').reduce((sum, item) => sum + (item.price || 0), 0);
    
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
                    const sellerRate = sellerSnap.data()?.customCommissionRate ?? COMMISSION_RATE;
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
                            <div className="flex-1">
                                <p className="text-xs font-bold truncate">{item.name}</p>
                                <p className="text-xs text-lime-400">${item.price?.toFixed(2)}</p>
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
const ItemDetailModal = ({ item, user, isOpen, onClose, onViewFeed }) => {
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
        <Modal isOpen={isOpen} onClose={onClose} title={item.name || "Item Details"}>
            <div className="space-y-4 max-h-[70vh] overflow-y-auto pr-2">
                <div className="h-72 w-full rounded-lg overflow-hidden border border-white/10 bg-black/60">
                    <MediaCarousel media={item.mediaUrls} fallback={item.imageUrl || item.image} />
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

const CollectionPopout = ({ user, type, isOpen, onClose, onViewFeed }) => {
    const [items, setItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);

    useEffect(() => {
        if(!isOpen || !user?.uid) return;
        let q = type === 'posts' ? query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), orderBy('timestamp', 'desc')) : query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'));
        return onSnapshot(q, s => {
            const allItems = s.docs.map(d => ({...d.data(), id: d.id}));
            if (type === 'posts') setItems(allItems.filter(i => !i.isCraftingStock));
            if (type === 'stock') setItems(allItems.filter(i => i.isCraftingStock));
        });
    }, [isOpen, user, type]);
    
    if(!isOpen) return null;
    return (
        <>
            <Modal isOpen={isOpen} onClose={onClose} title={type === 'posts' ? "My Collection" : "My Stock"}>
                <div className="grid grid-cols-2 gap-3 max-h-[60vh] overflow-y-auto p-1">
                    {items.length === 0 && <p className="col-span-2 text-center opacity-50 py-10">Empty here.</p>}
                    {items.map(item => (
                        <div key={item.id} onClick={() => setSelectedItem(item)} className={`bg-white/5 p-2 rounded-lg border flex flex-col relative group cursor-pointer hover:bg-white/10 ${item.status === 'generating' ? 'border-yellow-500/50' : 'border-white/10'}`}>
                            {item.status === 'generating' ? (
                                <div className="w-full h-24 bg-black/50 flex flex-col items-center justify-center rounded mb-2"><Activity className="animate-pulse text-yellow-400 mb-1"/><span className="text-[8px] text-yellow-400">Processing...</span></div>
                            ) : ( <img src={item.mediaUrls?.[0]?.url || item.imageUrl || item.image || 'https://placehold.co/100?text=Kandi'} className="w-full h-24 object-cover rounded mb-2"/> )}
                            <p className="font-bold text-[10px] truncate">{item.name || item.subType || 'Unknown Item'}</p>
                            <div className="flex justify-between items-center mt-2 border-t border-white/10 pt-2"><span className="text-[10px] text-lime-400 font-bold">${item.sell || item.price || '0.00'}</span><span className="text-[8px] opacity-50">{item.status || 'Ready'}</span></div>
                        </div>
                    ))}
                </div>
            </Modal>
            <ItemDetailModal item={selectedItem} user={user} isOpen={!!selectedItem} onClose={() => setSelectedItem(null)} onViewFeed={onViewFeed}/>
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
        setLoading(true); setGenPct(3); setImageReady(false); setRes(null); await ensureUserExists(user.uid);
        
        const docRef = await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), { 
            status: 'generating', prompt: prompt, timestamp: Date.now(), name: "AI Design (Pending)",
            ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver' 
        });
        
        try { 
            const r = await generateCustomKandi(prompt, setGenPct); setGenPct(98); setRes(r);
            const userRef = doc(db, 'artifacts', appId, 'users', user.uid);
            const snap = await getDoc(userRef);
            if (snap.exists()) { await updateDoc(userRef, { aiUsageCount: increment(1) }); } 
            else { await setDoc(userRef, { aiUsageCount: 1 }, { merge: true }); }
            setRemaining(prev => prev - 1);
            await updateDoc(docRef, { status: 'completed', imageUrl: r.imageUrl, visual_description: r.visual_description, estimated_materials: r.estimated_materials, estimated_cost: r.estimated_cost, difficulty: r.difficulty, name: "AI Custom Kandi", type: "Other" });
        } catch(e){ alert(e.message); await updateDoc(docRef, { status: 'failed', error: e.message }); } finally { setLoading(false); } 
    };

    const submit = async () => {
        if(!user?.uid) return;
        if(user.isAnonymous && allowBuy) return alert("Please create an account to sell items.");
        if (allowBuy && !itemName) return alert("You must name your item to allow others to buy it.");
        setLoading(true);
        try {
            const inventoryData = { status: 'completed', imageUrl: res.imageUrl, visual_description: res.visual_description, estimated_materials: res.estimated_materials, estimated_cost: res.estimated_cost, difficulty: res.difficulty, name: itemName || "AI Custom Kandi", timestamp: Date.now(), allowBuy: allowBuy, isDIYRequest: false, isAICreation: true, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', type: "Other", viewCount: 0 };
            await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), inventoryData);
            if (allowBuy) { await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), { ...inventoryData, ownerId: user.uid, ownerName: profile?.displayName || 'Raver', ownerBadge: profile?.featuredBadge || null, isAppProduct: false, purchaseCount: 0, shareCount: 0, status: 'approved', requestStatus: 'awaiting_assignment', likes: [], comments: [] }); alert("Submitted! Your design is live and queued for a Creator to fabricate orders."); } 
            else { alert("Saved to your collection!"); }
            setPrompt(''); setRes(null); setAllowBuy(false); setItemName('');
        } catch (e) { alert("Error saving: " + e.message); } finally { setLoading(false); }
    };

    return ( 
        <Card className="p-6 text-center">
            <Bot size={48} className="mx-auto mb-4 text-pink-500"/>
            <h2 className="text-2xl font-bold mb-2 uppercase">AI KANDI LAB</h2>
            <div className="flex justify-center gap-2 mb-4"><span className={`text-[10px] font-bold px-2 py-1 rounded ${remaining > 0 ? 'bg-lime-500/20 text-lime-400' : 'bg-red-500/20 text-red-400'}`}>Daily Limit: {remaining}/{DAILY_AI_LIMIT}</span></div>
            <div className="bg-yellow-900/20 border border-yellow-500/40 rounded p-2 mb-4 text-left"><p className="text-[9px] text-yellow-300 leading-relaxed"><strong>⚠ Heads up:</strong> the AI image renderer is unstable right now and may not produce a picture every time. Descriptions, materials & pricing still work — keep using the Lab and submit builds as normal.</p></div>
            {!res && ( <div className="mb-4 flex items-center justify-center gap-2 bg-white/5 p-2 rounded"><input type="checkbox" checked={allowBuy} onChange={e => setAllowBuy(e.target.checked)} className="accent-pink-500"/><label className="text-xs">Allow others to buy this design?</label></div> )}
            <Input type="textarea" value={prompt} onChange={setPrompt} placeholder="E.g. Neon green cuff with alien charms..." disabled={!!res}/>
            {!res && ( loading ? ( <div className="mt-4 space-y-2 text-center"><LoadingBar progress={genPct} className="h-2"/><p className="text-lime-400 font-mono text-lg font-bold">{genPct}%</p><p className="text-[10px] text-pink-300 animate-pulse">{genPct < 30 ? 'Consulting the Kandi Oracle...' : genPct < 92 ? 'Rendering visuals — image generation can take up to a minute. Hang tight! 🎨' : 'Polishing beads...'}</p></div> ) : ( <Button onClick={gen} disabled={remaining <= 0} color={remaining > 0 ? "lime" : "accent"} className="w-full">{remaining > 0 ? "Generate Design" : "Limit Reached"}</Button> ) )}
            {res && (
                <div className={`mt-6 border-2 border-dashed border-white/20 rounded-lg p-2 min-h-[200px] flex items-center justify-center bg-black/40 ${res ? 'shadow-[0_0_20px_rgba(255,100,200,0.6)] border-pink-400' : ''}`}>
                    <div className="w-full">
                        <img src={res.displayUrl || res.imageUrl} className={`rounded mb-2 w-full shadow-2xl transition-opacity duration-500 ${imageReady ? 'opacity-100' : 'opacity-0 h-0'}`} onLoad={() => setImageReady(true)} onError={(e) => { const tries = parseInt(e.target.dataset.tries || '0'); if (tries < 4) { e.target.dataset.tries = tries + 1; setTimeout(() => { e.target.src = res.imageUrl + '&retry=' + Date.now(); }, 5000); } else { e.target.src = 'https://placehold.co/512x512/1a0033/ff00ff?text=AI+Image+Failed'; setImageReady(true); } }} />
                        {!imageReady && <div className="py-10"><LoadingBar progress={50} className="w-1/2 mx-auto"/> <p className="text-xs mt-2 opacity-50">Rendering Visuals...</p></div>}
                        {imageReady && (
                            <div className="animate-fade-in-pulse">
                                <p className="text-xs opacity-70 mb-4">{res.visual_description}</p>
                                {allowBuy && ( <div className="mb-4"><label className="block text-left text-[10px] font-bold text-pink-400 mb-1">Item Name (Required to Sell)</label><Input value={itemName} onChange={setItemName} placeholder="Name your creation..."/></div> )}
                                <div className="bg-white/5 p-3 rounded mb-4 text-left">
                                    <h4 className="font-bold text-xs text-lime-400 border-b border-white/10 pb-1 mb-2">Estimated Materials</h4>
                                    <div className="space-y-1">{res.estimated_materials && res.estimated_materials.map((m, i) => ( <div key={i} className="flex justify-between text-[10px]"><span>{m.name}</span><span className="opacity-70">{m.qty}</span></div> ))}</div>
                                    <div className="mt-3 pt-2 border-t border-white/10 flex justify-between font-bold text-xs"><span>Est. Cost:</span><span className="text-cyan-400">${res.estimated_cost}</span></div>
                                </div>
                                <div className="flex gap-2"><Button onClick={() => setRes(null)} color="accent" className="flex-1 text-xs">Cancel</Button><Button onClick={submit} disabled={loading} color="lime" className="flex-1 text-xs">{loading ? "Saving..." : "Submit"}</Button></div>
                            </div>
                        )}
                    </div> 
                </div>
            )}
        </Card> 
    );
};
EOF

# Block 13
cat << 'EOF' >> src/App.js
const CreatorSelectCarousel = ({ onSelectCreator }) => {
    const [creators, setCreators] = useState([]);
    const [activeId, setActiveId] = useState(null);

    useEffect(() => {
        const q = query(collection(db, 'artifacts', appId, 'users'), where('isKandiCreator', '==', true));
        getDocs(q).then(snap => setCreators(snap.docs.map(d => ({...d.data(), id: d.id}))));
    }, []);

    const handleSelect = (c) => {
        setActiveId(c.id);
        onSelectCreator(c);
    };

    if (creators.length === 0) return <div className="text-center p-4 text-[10px] opacity-50 border border-white/10 rounded mb-4">No active Kandi Creators found.</div>;

    return (
        <div className="mb-4">
            <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-2">1. Choose a Verified Creator</h4>
            <div className="flex gap-2 overflow-x-auto pb-2">
                {creators.map(c => (
                    <div key={c.id} onClick={() => handleSelect(c)} className={`shrink-0 w-24 p-2 rounded-xl border flex flex-col items-center cursor-pointer transition-colors ${activeId === c.id ? 'bg-pink-500/20 border-pink-500' : 'bg-black/50 border-white/10 hover:bg-white/5'}`}>
                        <img src={c.photoURL || 'https://placehold.co/50'} className="w-10 h-10 rounded-full mb-1 object-cover border border-white/20"/>
                        <p className="text-[8px] font-bold truncate w-full text-center">{c.displayName}</p>
                        <p className="text-[7px] opacity-50 flex items-center gap-1"><Award size={8}/> {c.completedTrades || 0}</p>
                    </div>
                ))}
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
            <Card className="border-cyan-500/30">
                <h3 className="font-black uppercase text-sm text-cyan-400 mb-2 italic tracking-widest">How DIY Builds Work</h3>
                <div className="text-[11px] text-gray-100 space-y-1 leading-relaxed">
                    <p><span className="text-pink-400 font-bold">1.</span> Pick a Creator above to load their real crafting inventory (beads, strings, charms).</p>
                    <p><span className="text-pink-400 font-bold">2.</span> Tap parts to add them to Your Build — the price totals automatically as you design.</p>
                    <p><span className="text-pink-400 font-bold">3.</span> Describe your vision (colors, pattern, sizing) and hit Submit Build.</p>
                    <p><span className="text-pink-400 font-bold">4.</span> Track your request in your Collection — Pending → Active → Completed as the Creator works.</p>
                    <p><span className="text-pink-400 font-bold">5.</span> ⚖ Fairness window: a requested Creator gets <strong>24–72h</strong> (scaled by price & complexity) to accept before your request automatically opens to ALL Creators.</p>
                </div>
            </Card>
            <CreatorSelectCarousel onSelectCreator={(c) => { setActiveCreator(c); setOpenMode(false); }} />

            <button onClick={() => { const next = !openMode; setOpenMode(next); if (next) setActiveCreator(null); }} className={`w-full p-3 rounded-xl border-2 border-dashed font-black uppercase text-xs tracking-widest transition-all ${openMode ? 'border-lime-400 bg-lime-900/30 text-lime-300 shadow-[0_0_15px_rgba(163,230,53,0.4)]' : 'border-white/20 bg-white/5 text-white/60 hover:bg-white/10'}`}>
                📢 All Inventory / Open Request to ALL Creators {openMode && '✓ ACTIVE'}
            </button>
            {openMode && <p className="text-[9px] text-lime-300/80 -mt-2 px-1">Open mode: your request goes straight to the Awaiting Creator queue where every Creator can see and accept it. Add parts from the shared inventory (if available) or just describe your vision and set a budget.</p>}
            
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
        try { await navigator.share({ title: 'RaveKandi', text: `Check out ${item.name}!`, url: window.location.href }); await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { shareCount: increment(1) }); } catch (err) { navigator.clipboard.writeText(`Check out ${item.name} on RaveKandi!`); alert("Link copied!"); }
    };
    
    const avgRating = item.reviews?.length > 0 ? (item.reviews.reduce((a,b)=>a+b.rating,0) / item.reviews.length).toFixed(1) : null;

    return ( 
        <Card className="flex flex-col h-full relative">
            <CommentModal item={item} user={user} profile={profile} isOpen={showComments} onClose={() => setShowComments(false)} onViewProfile={onViewProfile}/>
            {item.purchaseCount > 0 && ( <div className="absolute top-2 right-2 bg-black/60 backdrop-blur px-2 py-1 rounded text-[8px] flex items-center gap-1 z-10 border border-lime-400/30"><ShoppingBag size={10} className="text-lime-400"/> {item.purchaseCount} Sold</div> )}
            {item.isSeries && ( <div className="absolute top-2 left-2 bg-purple-900/80 backdrop-blur px-2 py-1 rounded text-[8px] flex items-center gap-1 z-10 border border-purple-400/50 uppercase font-bold text-white shadow-neon-purple"><Award size={10}/> {item.seriesName} #{item.seriesNumber}</div> )}
            
            <div className="h-48 bg-black/50 rounded mb-3 overflow-hidden relative group cursor-pointer" onClick={() => onViewItem(item)}>
                <MediaCarousel media={item.mediaUrls} fallback={item.imageUrl || item.image} />
                <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 bg-black/40 transition-opacity z-30 pointer-events-none"><Maximize2 size={24} className="text-white drop-shadow-md"/></div>
            </div>
            
            <div className="mb-2">
                <h3 className="font-bold text-lg leading-tight cursor-pointer hover:text-cyan-400" onClick={() => onViewItem(item)}>{item.name}</h3>
                <div className="flex justify-between items-center">
                    <button onClick={() => onViewProfile(item.ownerPublicUid || item.ownerId)} className="text-xs text-pink-400 font-bold underline decoration-pink-500/40 underline-offset-2 hover:text-pink-300 cursor-pointer flex items-center gap-0.5"><User size={10}/>@{item.ownerName}<BadgeChip badge={item.ownerBadge} /></button>
                    <span className="text-lime-400 font-bold">
                        {canSeePrice ? `$${item.price?.toFixed(2)}` : <span className="text-[10px] text-red-300 italic bg-red-900/40 border border-red-500/30 px-2 py-1 rounded font-bold">OUT OF STOCK</span>}
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
                    {(item.stockQty ?? 1) <= 0 ? <span className="text-[8px] bg-red-900/60 text-red-300 px-1 rounded border border-red-500/40 font-bold uppercase">Out of Stock · Qty: 0</span> : <span className="text-[8px] bg-white/10 px-1 rounded border border-white/20">Qty: {Math.max(0, item.stockQty ?? 1)}</span>}
                    {isOwner && (item.stockQty ?? 1) <= 0 && <span className="text-[8px] text-lime-300 bg-lime-900/30 border border-lime-500/40 px-1 rounded font-bold">RESTOCK: Tap item → Edit</span>}
                    {item.bulkDiscountPct > 0 && <span className="text-[8px] bg-lime-500/20 text-lime-400 px-1 rounded border border-lime-500/50">{item.bulkDiscountPct}% off {item.bulkDiscountQty}+</span>}
                    <span className="text-[8px] bg-black/50 px-1 rounded border border-white/10 flex items-center gap-1"><Eye size={8}/> {item.viewCount || 0}</span>
                    {avgRating && <span className="text-[8px] bg-yellow-900/30 px-1 rounded border border-yellow-500/50 flex items-center gap-1 text-yellow-400"><StarIcon size={8} fill="currentColor"/> {avgRating}</span>}
                </div>
            </div>
            
            <div className="mt-auto flex justify-between items-center pt-3 border-t border-white/10">
                <div className="flex gap-3"><button onClick={toggleLike} className={liked ? 'text-pink-500' : 'text-white/50'}><Heart size={18} fill={liked?"currentColor":"none"}/></button><button onClick={() => setShowComments(true)} className="text-white/50 hover:text-white"><MessageSquare size={18}/></button><button onClick={handleShare} className="text-white/50 hover:text-cyan-400"><Share2 size={18}/></button></div>
                {item.isAICreation && !item.allowBuy ? ( <Button onClick={() => onViewProfile(item.ownerPublicUid || item.ownerId)} color="purple" className="text-xs py-1 px-3">View Collection</Button> ) : ( <Button disabled={(item.stockQty !== undefined && item.stockQty !== null) ? item.stockQty <= 0 : item.purchaseCount > 0} onClick={() => onAddToCart(item)} color="accent" className="text-xs py-1 px-3 flex items-center gap-1"><ShoppingCart size={12}/> Add</Button> )}
            </div>
        </Card> 
    );
};

const SellKandiForm = ({ user, profile }) => {
    const [isOpen, setIsOpen] = useState(false);
    const [form, setForm] = useState({ name: '', price: '', description: '', type: 'Bracelet', isOfficial: false, stockQty: 1, bulkDiscountQty: '', bulkDiscountPct: '', isSeries: false, seriesName: '', seriesNumber: '', isPinned: false });
    const [mediaFiles, setMediaFiles] = useState([]);
    const [loading, setLoading] = useState(false); const [uploadPercent, setUploadPercent] = useState(0);
    
    const handleFileChange = (e) => {
        const files = Array.from(e.target.files);
        if(files.length > 5) return alert("Maximum 5 files allowed.");
        const images = files.filter(f => f.type.startsWith('image/')).length;
        const videos = files.filter(f => f.type.startsWith('video/')).length;
        if(images > 3) return alert("Maximum 3 images allowed.");
        if(videos > 2) return alert("Maximum 2 videos allowed.");
        setMediaFiles(files);
    };

    const sub = async () => { 
        if(user?.isAnonymous) return alert("Please create an account to post items.");
        if(!form.name || !form.price || !form.stockQty || mediaFiles.length === 0 || !user?.uid) return alert("Fill all required fields including Stock Qty and Media.");
        if(parseInt(form.stockQty) < 1) return alert("Stock Quantity must be at least 1.");
        setLoading(true); setUploadPercent(0);
        
        try { 
            let uploadedMedia = [];
            for(let i=0; i<mediaFiles.length; i++) {
                setUploadPercent(Math.round(((i) / mediaFiles.length) * 100));
                const imgStr = await compressImage(mediaFiles[i], null);
                uploadedMedia.push({ url: imgStr, type: mediaFiles[i].type.startsWith('video') ? 'video' : 'image', linkedItem: '' });
            }
            setUploadPercent(99);

            const item = { ...form, price: parseFloat(form.price), type: form.type || 'Other', stockQty: parseInt(form.stockQty), bulkDiscountQty: parseInt(form.bulkDiscountQty||0), bulkDiscountPct: parseInt(form.bulkDiscountPct||0), mediaUrls: uploadedMedia, imageUrl: uploadedMedia[0]?.url, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', ownerBadge: profile?.featuredBadge || null, timestamp: Date.now(), likes: [], comments: [], isAppProduct: form.isOfficial, status: 'approved', purchaseCount: 0, viewCount: 0, isPinned: form.isPinned, isCraftingStock: false }; 
            
            const batch = writeBatch(db);
            const publicRef = doc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'));
            batch.set(publicRef, item);
            const userColRef = doc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'));
            batch.set(userColRef, { ...item, refId: publicRef.id });
            await batch.commit(); setIsOpen(false); 
        } catch(e) { alert("Error: " + e.message); } finally { setLoading(false); setUploadPercent(0); setMediaFiles([]); } 
    };

    if(!isOpen) return <div className="mb-6"><button onClick={() => setIsOpen(true)} className="w-full py-4 rounded-xl border-2 border-dashed border-white/20 hover:bg-white/10 flex items-center justify-center gap-2"><PlusCircle className="text-pink-500"/><span className="font-bold">Post Your Kandi</span></button></div>;
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
            <div className="grid grid-cols-2 gap-2">
                <Input label="Price ($)" type="number" value={form.price} onChange={v => setForm({...form, price: v})} />
                <Input label="Item Type" type="select" options={KANDI_TYPES} value={form.type} onChange={v => setForm({...form, type: v})} />
            </div>
            <div className="grid grid-cols-3 gap-2">
                <Input label="Stock Qty" type="number" value={form.stockQty} onChange={v => setForm({...form, stockQty: v})} />
                <Input label="Bulk Qty Req." type="number" value={form.bulkDiscountQty} onChange={v => setForm({...form, bulkDiscountQty: v})} placeholder="e.g. 5" />
                <Input label="Bulk % Off" type="number" value={form.bulkDiscountPct} onChange={v => setForm({...form, bulkDiscountPct: v})} placeholder="e.g. 10" />
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
const AdminDashboard = ({ user, profile }) => {
    const [adminTab, setAdminTab] = useState('tools');
    const [apps, setApps] = useState([]);
    const [targetUid, setTargetUid] = useState('');
    const [customRate, setCustomRate] = useState('');
    const [tickets, setTickets] = useState([]);
    const [ticketFilter, setTicketFilter] = useState('open');
    const [searchUid, setSearchUid] = useState('');
    const [managedUser, setManagedUser] = useState(null);
    const [revPct, setRevPct] = useState('');

    useEffect(() => onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications'), where('status', '==', 'pending')), s => setApps(s.docs.map(d => ({...d.data(), id: d.id})))), []);
    useEffect(() => onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tickets')), s => setTickets(s.docs.map(d => ({...d.data(), id: d.id})).sort((a,b)=>(b.createdAt||0)-(a.createdAt||0)))), []);

    const approve = async (a) => { if(window.confirm("Approve?")) { await updateDoc(doc(db, 'artifacts', appId, 'users', a.uid), { isKandiCreator: true }); await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications', a.id), { status: 'approved' }); } };
    
    const setCommRate = async () => {
        if(!targetUid || !customRate) return;
        await updateDoc(doc(db, 'artifacts', appId, 'users', targetUid), { customCommissionRate: parseFloat(customRate) });
        alert(`Commission rate for ${targetUid} set to ${customRate}`);
        setTargetUid(''); setCustomRate('');
    };

    const findUser = async () => {
        if (!searchUid.trim()) return;
        try {
            let found = null;
            const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', searchUid.trim()));
            const snap = await getDocs(q);
            if (!snap.empty) found = { id: snap.docs[0].id, ...snap.docs[0].data() };
            else {
                const direct = await getDoc(doc(db, 'artifacts', appId, 'users', searchUid.trim()));
                if (direct.exists()) found = { id: direct.id, ...direct.data() };
            }
            if (!found) return alert("No user found with that Public UID or raw UID.");
            setManagedUser(found);
            setRevPct(found.customRevSharePct ?? '');
        } catch (e) { alert(e.message); }
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
            
            <div className="bg-white/5 p-3 rounded mb-4 border border-white/10">
                <h4 className="text-[10px] uppercase font-bold text-cyan-400 mb-2">User Manager — RevShare & Bans</h4>
                <div className="flex gap-2 mb-3">
                    <Input value={searchUid} onChange={setSearchUid} placeholder="Public UID or raw UID" className="mb-0 flex-1" />
                    <Button onClick={findUser} color="cyan" className="text-[10px]">Find</Button>
                </div>
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
                    </div>
                )}
            </div>

            <div className="bg-white/5 p-3 rounded mb-4 border border-white/10">
                <h4 className="text-[10px] uppercase font-bold text-red-400 mb-2">Custom Fee Overrides</h4>
                <div className="flex gap-2">
                    <Input value={targetUid} onChange={setTargetUid} placeholder="Target UID" className="mb-0 flex-1" />
                    <Input value={customRate} onChange={setCustomRate} type="number" placeholder="Rate (e.g. 0.10)" className="mb-0 w-24" />
                    <Button onClick={setCommRate} color="red" className="text-[10px]">Set</Button>
                </div>
                <p className="text-[8px] opacity-50 mt-1">Default rate is 0.20. Lowering this overrides the app's cut for specific promoters.</p>
            </div>

            {apps.length > 0 && <h4 className="text-[10px] uppercase font-bold text-red-400 mb-2">Pending Apps</h4>}
            {apps.map(a => <div key={a.id} className="bg-white/5 p-3 rounded mb-2 flex justify-between items-center"><span className="text-sm font-bold tracking-widest uppercase">{a.name}</span><Button onClick={() => approve(a)} color="lime" className="text-[10px] py-1 px-4 shadow-neon-green">Approve</Button></div>)}
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

const InventoryManager = ({ user, profile }) => {
    const [target, setTarget] = useState('user');
    const [targetUid, setTargetUid] = useState(user?.uid || '');
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
    
    const profit = (parseFloat(newItem.sell || 0) - parseFloat(newItem.cost || 0) - (parseFloat(newItem.sell || 0) * COMMISSION_RATE)).toFixed(2);
    
    return ( 
        <Card className="mt-8 border-cyan-500/40">
            <h3 className="font-bold text-cyan-400 mb-4 flex justify-between items-center">Inventory Hub <HelpCircle size={16}/></h3>
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
    const activeCommRate = profile.customCommissionRate !== null ? profile.customCommissionRate : COMMISSION_RATE;
    
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

const InfoSection = () => {
    const [openIdx, setOpenIdx] = useState(null);
    const infos = [
        { title: "💸 Payouts & Commission", content: "Sellers keep the majority of every sale. We can take up to 20% commission, typically starting at 20% and going as low as zero, on the back-end to cover Stripe transaction fees, servers, and RevShare payouts. Sellers can customize their payout schedule directly through their secure Stripe Connect portal." },
        { title: "🤝 The PLUR Reward System (RevShare)", content: "We share our profits with you. When you refer a friend using your UID, you unlock RevShare. You earn 2% to 25% of our app's commission every time your referral makes a purchase—forever. Tier 1 starts at 1 referral. The ladder tops out at Tier 11 — Eternal Rave (5,000+ referrals) at a full 25% of the commission." },
        { title: "📦 Mandatory Tracking Numbers", content: "To protect both buyers and sellers, tracking numbers are mandatory for all physical goods. Once a tracking number is uploaded by the seller, it is permanently locked and only viewable by the direct Buyer and the Seller in their private collection dashboard. No funds are fully cleared until tracking is active." },
        { title: "🛡️ Safe Checkout (Stripe & Solana)", content: "We offer dual checkout. Pay instantly with practically zero fees and full anonymity using Solana/USDC crypto wallets (Phantom, Coinbase, MetaMask). Or, pay traditionally with standard credit/debit cards via Stripe's encrypted portal." }
    ];
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
const PinSelectModal = ({ user, isOpen, onClose }) => {
    const [inv, setInv] = useState([]);
    useEffect(() => {
        if(!isOpen || !user?.uid) return;
        getDocs(query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'))).then(s => setInv(s.docs.map(d=>({...d.data(), id: d.id}))));
    }, [isOpen, user]);
    const togglePin = async (item) => {
        await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'inventory', item.id), { isPinned: true });
        onClose();
    };
    if(!isOpen) return null;
    return (
        <Modal isOpen={isOpen} onClose={onClose} title="Select Item to Pin">
            <div className="grid grid-cols-2 gap-2 max-h-60 overflow-y-auto p-1">
                {inv.map(i => (
                    <div key={i.id} onClick={() => togglePin(i)} className={`border p-2 rounded cursor-pointer ${i.isPinned ? 'border-pink-500 bg-pink-500/20' : 'border-white/20 hover:bg-white/10'}`}>
                        <img src={i.mediaUrls?.[0]?.url || i.imageUrl || i.image || 'https://placehold.co/100'} className="w-full h-16 object-cover rounded mb-1"/>
                        <p className="text-[8px] truncate">{i.name}</p>
                    </div>
                ))}
            </div>
        </Modal>
    );
};

const ProfileView = ({ user, onOpenSettings, onViewFeed }) => {
    const [profile, setProfile] = useState({});
    const [modals, setModals] = useState({ username: false, bio: false, settings: false, collection: false, inventory: false, socials: false, referrals: false, analytics: false, vip: false, theme: false });
    const [showCreatorHub, setShowCreatorHub] = useState(false);
    const [showAdminPortal, setShowAdminPortal] = useState(false);
    const [hideGuestPrompt, setHideGuestPrompt] = useState(false);
    
    const [pinnedItems, setPinnedItems] = useState([]);
    const [showBadges, setShowBadges] = useState(false);
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
        if(!user?.uid || !profile?.isKandiCreator) return;
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
            <AdminDashboard user={user} profile={profile}/>
        </div>
    );

    const refStats = getReferralTier(profile.referrals || 0);

    return (
        <div className="relative">
            <div className={`max-w-4xl mx-auto px-4 pb-20 space-y-6 ${user?.isAnonymous ? 'pointer-events-none filter blur-[2px] opacity-40 grayscale' : ''}`}>
                <UsernameModal user={user} profile={profile} isOpen={modals.username} onClose={()=>setModals({...modals, username:false})}/>
                <CollectionPopout user={user} type="posts" isOpen={modals.collection} onClose={()=>setModals({...modals, collection:false})} onViewFeed={onViewFeed}/>
                <CollectionPopout user={user} type="stock" isOpen={modals.inventory} onClose={()=>setModals({...modals, inventory:false})}/>
                <MainSettingsModal user={user} profile={profile} isOpen={modals.settings} onClose={()=>setModals({...modals, settings:false})}/>
                <BioModal user={user} currentBio={profile.bio || ''} isOpen={modals.bio} onClose={()=>setModals({...modals, bio:false})}/>
                <EditSocialsModal user={user} profile={profile} isOpen={modals.socials} onClose={()=>setModals({...modals, socials:false})}/>
                <ReferralModal user={user} profile={profile} isOpen={modals.referrals} onClose={()=>setModals({...modals, referrals:false})}/>
                <ItemDetailModal item={selectedPinned} user={user} isOpen={!!selectedPinned} onClose={() => setSelectedPinned(null)} onViewFeed={onViewFeed}/>
                <PinSelectModal user={user} isOpen={pinModalOpen} onClose={() => setPinModalOpen(false)} />
                <UserStatsDashboard profile={profile} isOpen={modals.analytics} onClose={() => setModals({...modals, analytics: false})} />
                <VIPCheckoutModal user={user} isOpen={modals.vip} onClose={() => setModals({...modals, vip: false})} />
                <ThemeSelectorModal user={user} profile={profile} isOpen={modals.theme} onClose={() => setModals({...modals, theme: false})} />
                <BadgeSelectorModal user={user} profile={profile} isOpen={showBadges} onClose={() => setShowBadges(false)} />
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
                        {profile.isVIP && (
                            <div className="absolute -top-2 -left-2 bg-yellow-500/20 text-yellow-400 p-1.5 rounded-full border border-yellow-400 shadow-[0_0_10px_rgba(250,204,21,0.5)]">
                                <Crown size={14}/>
                            </div>
                        )}
                    </div>
                    <div className="text-center md:text-left flex-1 w-full">
                        <div className="flex items-center justify-center md:justify-start gap-2 mb-1"><h2 className="text-3xl font-black flex items-center" style={getTextGlowStyle('primaryGlow')}>@{profile.displayName || 'Raver'}<BadgeChip badge={profile.featuredBadge} /></h2><button onClick={() => setModals({...modals, username:true})}><Pencil size={16}/></button></div>
                        
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

                        {profile.isKandiCreator && pinnedItems.length > 0 && (
                            <div className="mb-4 bg-black/50 border border-pink-500/30 p-2 rounded-lg">
                                <h4 className="text-[10px] uppercase font-bold text-pink-400 mb-2 flex items-center gap-1"><Star size={12}/> Featured Pins</h4>
                                <div className="flex gap-2 overflow-x-auto pb-1">
                                    {pinnedItems.slice(0, 2).map(item => (
                                        <div key={item.id} onClick={() => setSelectedPinned(item)} className="bg-white/5 border border-white/10 rounded p-1 w-24 shrink-0 cursor-pointer hover:bg-white/10 transition-colors relative group">
                                            <button onClick={(e) => { e.stopPropagation(); unpinItem(item.id); }} className="absolute top-1 right-1 bg-black/80 text-red-500 p-1 rounded-full opacity-0 group-hover:opacity-100"><XCircle size={14}/></button>
                                            <img src={item.mediaUrls?.[0]?.url || item.imageUrl || item.image} className="w-full h-16 object-cover rounded mb-1 border-2 border-pink-500/30" />
                                            <p className="text-[8px] font-bold truncate text-white text-center">★ {item.name}</p>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

                        <div className="flex items-center gap-2 justify-center md:justify-start mb-3 w-full" onClick={() => setShowRevShare(true)}><div className="bg-gradient-to-r from-lime-900/40 to-cyan-900/40 border border-lime-400/40 px-4 py-2 rounded font-mono text-xs w-full md:w-auto text-center md:text-left truncate cursor-pointer hover:border-lime-400 transition-colors">Friend UID: <span className="text-lime-400 font-bold">{profile.publicUid || user.uid}</span> <Share2 size={10} className="inline ml-2 text-cyan-400"/> <span className="text-[8px] text-cyan-400 uppercase font-bold ml-1">RevShare</span></div></div>
                        
                        <div className="bg-white/5 p-3 rounded text-sm relative border border-white/10 flex items-start min-h-[60px]" onClick={()=>setModals({...modals, bio:true})}>
                            {!profile.bio && <span className="text-[10px] uppercase font-bold opacity-30 mr-2 select-none">BIO</span>}
                            <p className="opacity-80 italic flex-1">{profile.bio || "No vibe check yet."}</p>
                        </div>

                        <div className="flex gap-4 my-4 justify-center md:justify-start flex-wrap">
                            {SOCIAL_PLATFORMS.map(p => { if(profile.socialLinks && profile.socialLinks[p.id]) return (<a key={p.id} href={`https://${p.baseUrl}${profile.socialLinks[p.id]}`} target="_blank" rel="noreferrer" className="bg-white/10 p-2 rounded-full hover:bg-white/20 transition hover:scale-110"><p.icon size={20} color={p.color}/></a>); return null; })}
                        </div>
                        
                        <div className="grid grid-cols-4 gap-2 mb-2">
                             {[{ label: "Items Sold", val: profile.itemsSold || 0 }, { label: "Bought", val: profile.itemsBought || 0 }, { label: "$ Sold", val: "$" + Number(profile.totalSalesValue || 0).toFixed(2) }, { label: "$ Bought", val: "$" + Number(profile.totalBoughtValue || 0).toFixed(2) }, { label: "Likes", val: profile.totalLikes || 0 }, { label: "Comments", val: profile.totalComments || 0 }, { label: "Badges", val: getDisplayAchievements(profile).filter(a=>a.unlocked).length, onClick: () => setShowBadges(true) }, { label: "Referrals", val: profile.referrals || 0, onClick: () => setModals({...modals, referrals:true}) }].map((s, i) => (
                                 <div key={i} onClick={s.onClick} className={`bg-black/80 border border-lime-400/50 shadow-[0_0_5px_rgba(163,230,53,0.4)] p-1 rounded text-center ${s.onClick ? 'cursor-pointer hover:bg-lime-900/40' : ''}`}><div className="text-[10px] font-bold text-lime-400">{s.val}</div><div className="text-[7px] opacity-70 uppercase leading-none text-white">{s.label}</div></div>
                             ))}
                        </div>
                        <button onClick={() => setModals({...modals, analytics: true})} className="w-full text-center text-[10px] text-cyan-400 hover:text-white mb-4 underline opacity-80">View Detailed Analytics</button>

                        <div className="flex gap-2 mt-4 justify-center md:justify-start"><Button onClick={()=>setModals({...modals, settings:true})} color="cyan" className="flex-1 text-xs flex justify-center items-center gap-2"><Settings size={14}/> Settings</Button><Button onClick={()=>setModals({...modals, socials:true})} color="purple" className="flex-1 text-xs flex justify-center items-center gap-2">Socials</Button></div>
                        
                        {/* PHASE 7: VIP Ecosystem Access */}
                        {!profile.isVIP ? (
                            <div className="mt-4 p-3 bg-gradient-to-r from-yellow-500/10 to-transparent border border-yellow-500/30 rounded-xl flex items-center justify-between cursor-pointer hover:bg-yellow-500/20" onClick={() => setModals({...modals, vip: true})}>
                                <div><span className="text-[10px] font-bold text-yellow-400 block tracking-widest uppercase">Go VIP</span><span className="text-[8px] opacity-70">Radio · Themes · Banner Msgs · Post Boosts</span></div>
                                <Crown size={18} className="text-yellow-400"/>
                            </div>
                        ) : (
                            <div className="mt-4 p-3 bg-gradient-to-r from-cyan-500/10 to-transparent border border-cyan-500/30 rounded-xl flex items-center justify-between cursor-pointer hover:bg-cyan-500/20" onClick={() => setModals({...modals, theme: true})}>
                                <div><span className="text-[10px] font-bold text-cyan-400 block tracking-widest uppercase">Theme Selector</span><span className="text-[8px] opacity-70">Change your app background</span></div>
                                <ImageIcon size={18} className="text-cyan-400"/>
                            </div>
                        )}

                        <div className="mt-3 p-3 bg-gradient-to-r from-purple-500/10 to-transparent border border-purple-500/40 rounded-xl">
                            <p className="text-[10px] font-black text-purple-300 tracking-widest uppercase mb-2 flex items-center gap-1"><Crown size={12} className="text-yellow-400"/> Subscriber Tools</p>
                            {profile?.isVIP && profile?.vipPlan === 'monthly' && profile?.vipExpires && (
                                <p className="text-[8px] text-yellow-300 mb-2">Monthly VIP active — expires {new Date(profile.vipExpires).toLocaleDateString()} · <button onClick={() => setModals({...modals, vip: true})} className="underline text-lime-300 font-bold">Renew +30 days</button></p>
                            )}
                            {profile?.vipPlan === 'expired' && !profile?.isVIP && (
                                <p className="text-[8px] text-red-300 mb-2">Your monthly VIP has expired. <button onClick={() => setModals({...modals, vip: true})} className="underline text-lime-300 font-bold">Renew now</button></p>
                            )}
                            <div className="grid grid-cols-2 gap-2">
                                <button onClick={() => setShowBanner(true)} className="p-2 bg-gradient-to-r from-cyan-500/10 to-transparent border border-cyan-500/30 rounded-xl text-left hover:bg-cyan-500/20"><span className="text-[10px] font-bold text-cyan-400 block uppercase tracking-widest">📢 Banner Msgs</span><span className="text-[8px] opacity-70">Post on the live marquee</span></button>
                                <button onClick={() => setShowBoost(true)} className="p-2 bg-gradient-to-r from-pink-500/10 to-transparent border border-pink-500/30 rounded-xl text-left hover:bg-pink-500/20"><span className="text-[10px] font-bold text-pink-400 block uppercase tracking-widest">⚡ Post Boosts</span><span className="text-[8px] opacity-70">Pin your item to the top</span></button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div className="grid grid-cols-2 gap-4"><button onClick={() => setModals({...modals, collection:true})} className="bg-white/5 border border-white/10 p-4 rounded-xl font-bold flex flex-col items-center hover:bg-white/10 transition"><Package className="text-pink-500 mb-1"/> Collection</button> <button onClick={() => setModals({...modals, inventory:true})} className="bg-white/5 border border-white/10 p-4 rounded-xl font-bold flex flex-col items-center hover:bg-white/10 transition"><Box className="text-lime-400 mb-1"/> My Inventory</button> </div>
                
                {profile.isKandiCreator && (
                    <div className="grid grid-cols-2 gap-4 mt-2">
                        {[0, 1].map(index => {
                            const pinnedItem = pinnedItems[index];
                            if (!pinnedItem) {
                                return (
                                    <button key={`pin-empty-${index}`} onClick={() => setPinModalOpen(true)} className="bg-white/5 border border-dashed border-white/20 p-4 rounded-xl font-bold flex flex-col items-center justify-center hover:bg-white/10 transition opacity-50 h-24">
                                        <PlusCircle className="text-white mb-1" size={16}/>
                                        <span className="text-[8px] text-center font-bold">Pin Top Item</span>
                                    </button>
                                );
                            } else return <div key={`pin-empty-${index}`} className="hidden"></div>;
                        })}
                    </div>
                )}

                <Card glow="goldGlow"><h3 className="font-bold mb-4 underline decoration-yellow-500/50">Achievement Tiers</h3><div className="space-y-4">{getDisplayAchievements(profile).map((ach, idx) => (<div key={idx} className={`flex items-center p-3 rounded-lg border transition-all ${ach.unlocked ? 'border-lime-500/50 bg-lime-900/10' : 'border-white/5 bg-black/40 opacity-40 grayscale'}`}><ach.icon size={24} className={`mr-3 shrink-0 ${ach.unlocked ? 'text-lime-400' : 'text-white'}`} /><div className="flex-1"><div className="flex justify-between items-center"><p className="font-bold text-sm">{ach.name}</p><p className={`text-[8px] font-black uppercase px-1 rounded ${ach.unlocked ? 'bg-lime-500 text-black' : 'bg-white/10 text-white'}`}>{ach.unlocked ? 'Unlocked' : 'Locked'}</p></div><p className="text-[10px] opacity-70 mt-0.5">{ach.desc}</p></div></div>))}</div></Card>
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
    const [refCode, setRefCode] = useState('');
    const [loading, setLoading] = useState(false);
    const [rememberMe, setRememberMe] = useState(true);

    useEffect(() => {
        const savedEmail = localStorage.getItem('rk_auth_email');
        if(savedEmail) setEmail(savedEmail);
        // V37.10: plaintext password storage removed — credential saving is now handled
        // by the device password manager (Google Password Manager / iCloud Keychain).
        localStorage.removeItem('rk_auth_pass');
    }, []);

    const handleAuth = async () => {
        if(!email || !password) return alert("Email and Password required");
        if(isReg && !djName) return alert("DJ Name required for registration");
        setLoading(true); setLoadMsg("Authenticating...");
        try {
            const persistenceType = rememberMe ? indexedDBLocalPersistence : browserSessionPersistence;
            await setPersistence(auth, persistenceType);

            let referrerUid = null;
            if (isReg && refCode) {
                const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', refCode));
                const snap = await getDocs(q);
                if (!snap.empty) { referrerUid = snap.docs[0].id; }
            }

            if (isReg) {
                const cred = await createUserWithEmailAndPassword(auth, email, password);
                await ensureUserExists(cred.user.uid, djName, referrerUid);
            } else {
                await signInWithEmailAndPassword(auth, email, password);
            }
            
            if (rememberMe) {
                localStorage.setItem('rk_auth_email', email);
            } else {
                localStorage.removeItem('rk_auth_email');
            }

        } catch(e) { alert(e.message); } finally { setLoading(false); }
    };

    const guestAuth = async () => {
        setLoading(true); setLoadMsg("Entering as Guest...");
        try { await signInAnonymously(auth); }
        catch (e) { alert(e.message); } finally { setLoading(false); }
    };

    const socialAuth = async (provider) => {
        setLoading(true); setLoadMsg("Routing to provider...");
        try { 
            const persistenceType = rememberMe ? indexedDBLocalPersistence : browserSessionPersistence;
            await setPersistence(auth, persistenceType);
            if(refCode) localStorage.setItem('pending_ref_code', refCode);
            await signInWithPopup(auth, provider); 
        } 
        catch (e) { alert(e.message); } finally { setLoading(false); }
    };

    return (
        <div className="min-h-screen bg-[#0a0014] flex flex-col items-center justify-center p-4 text-white">
            <Card glow="primaryGlow" className="w-full max-w-md p-6">
                <div className="flex justify-center mb-6"><Zap className="text-yellow-400" size={48} fill="currentColor"/></div>
                <h2 className="text-3xl font-black mb-6 text-center italic tracking-tighter" style={getTextGlowStyle('primaryGlow')}>{isReg ? 'JOIN THE RAVE' : 'WELCOME BACK'}</h2>
                
                <form onSubmit={(e) => { e.preventDefault(); handleAuth(); }} autoComplete="on">
                {isReg && <Input label="DJ Name" name="nickname" value={djName} onChange={setDjName} placeholder="TechnoViking" autoComplete="nickname" />}
                {isReg && <Input label="Friend UID (Optional)" value={refCode} onChange={setRefCode} placeholder="Enter Referral Code..." />}
                <Input label="Email" type="email" name="email" value={email} onChange={setEmail} placeholder="dj@rave.com" autoComplete={isReg ? "email" : "username"} />
                <Input label="Password" type="password" name="password" value={password} onChange={setPassword} placeholder="••••••••" autoComplete={isReg ? "new-password" : "current-password"} />
                
                <div className="mb-4 flex items-center justify-center gap-2">
                    <input type="checkbox" id="rememberMe" checked={rememberMe} onChange={e => setRememberMe(e.target.checked)} className="accent-lime-400" />
                    <label htmlFor="rememberMe" className="text-xs text-white/70 cursor-pointer">Save my info for faster login</label>
                </div>

                <Button type="submit" disabled={loading} color="lime" className="w-full mb-4 py-3">{loading ? "Processing..." : (isReg ? "Sign Up" : "Log In")}</Button>
                </form>
                <button onClick={() => setIsReg(!isReg)} className="text-xs text-cyan-400 w-full text-center hover:underline mb-6">{isReg ? "Already have an account? Log In" : "Need an account? Sign Up"}</button>
                
                <div className="border-t border-white/20 pt-4 mb-4">
                    <p className="text-[10px] text-center opacity-50 mb-4 uppercase tracking-widest">Or connect with</p>
                    <div className="grid grid-cols-3 gap-2">
                        <button onClick={() => socialAuth(new GoogleAuthProvider())} className="bg-white/10 hover:bg-white/20 p-2 rounded flex justify-center"><Globe size={18}/></button>
                        <button onClick={() => socialAuth(new OAuthProvider('apple.com'))} className="bg-white/10 hover:bg-white/20 p-2 rounded flex justify-center"><Smartphone size={18}/></button>
                        <button onClick={() => socialAuth(new TwitterAuthProvider())} className="bg-white/10 hover:bg-white/20 p-2 rounded flex justify-center"><Twitter size={18}/></button>
                    </div>
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
    const [showVipModal, setShowVipModal] = useState(false);
    
    // PHASE 8: Rave Radio State
    const [isRadioPlaying, setIsRadioPlaying] = useState(false);
    const [radioOpen, setRadioOpen] = useState(false);
    const [ticketOpen, setTicketOpen] = useState(false);
    const [viewingItem, setViewingItem] = useState(null);
    const [nowPlaying, setNowPlaying] = useState(null);
    
    // PHASE 7: Global Stats Hook
    const [globalStats, setGlobalStats] = useState({ userCount: 0 });
    useEffect(() => {
        const unsub = onSnapshot(doc(db, 'artifacts', appId, 'global', 'stats'), s => { if(s.exists()) setGlobalStats(s.data()); });
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
        const flush = () => {
            const last = num(flushKey);
            if (last && (Date.now() - last) < 21600000) return; // sync window: 6h
            const radioKey = 'rk_radio_buf_' + uid;
            const mins = num(bufKey), opens = num(openKey), rmins = num(radioKey);
            const ref = doc(db, 'artifacts', appId, 'users', uid);
            setDoc(ref, { lastActiveAt: Date.now(), activeMinutes: increment(mins), activeOpens: increment(opens), radioMinutes: increment(rmins) }, { merge: true })
                .then(() => { localStorage.setItem(bufKey, '0'); localStorage.setItem(openKey, '0'); localStorage.setItem(radioKey, '0'); localStorage.setItem(flushKey, String(Date.now())); })
                .catch(() => {});
        };
        flush();
        const tick = setInterval(() => { localStorage.setItem(bufKey, String(num(bufKey) + 1)); flush(); }, 60000);
        return () => clearInterval(tick);
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
                const savedRef = localStorage.getItem('pending_ref_code');
                if (savedRef) {
                    const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', savedRef));
                    const snap = await getDocs(q);
                    if (!snap.empty) { rUid = snap.docs[0].id; }
                    localStorage.removeItem('pending_ref_code');
                }
                ensureUserExists(u.uid, null, rUid); 
            } 
            if(u) { try{ await SplashScreen.hide(); }catch(e){} }
        });
        setTimeout(() => { 
            clearInterval(intLoad); setLoadPct(100); setLoadMsg("Ready to Rave!");
            if (localStorage.getItem('hideAlphaWarning') !== 'true') setShowAlphaModal(true);
            setTimeout(() => setLoading(false), 200); 
        }, 2500);
        return () => { clearInterval(intLoad); unsubAuth(); };
    }, []);

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
        if (page !== 'feed' || filters.postType !== 'users' || !user) return;
        getDocs(query(collection(db, 'artifacts', appId, 'users'), orderBy('joined', 'desc'), limit(50)))
            .then(s => setUsersDir(s.docs.map(d => ({ ...d.data(), id: d.id }))))
            .catch(e => console.log('User dir load failed', e));
    }, [page, filters.postType, user]);
    useEffect(() => {
        const term = filters.searchUid.trim();
        if (page !== 'feed' || filters.postType !== 'users' || term.length < 5) return;
        const t = setTimeout(async () => {
            try {
                const snap = await getDocs(query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', term)));
                if (!snap.empty) setUsersDir(prev => { const found = { ...snap.docs[0].data(), id: snap.docs[0].id }; return prev.some(p => p.id === found.id) ? prev : [found, ...prev]; });
            } catch (e) {}
        }, 600);
        return () => clearTimeout(t);
    }, [filters.searchUid, page, filters.postType]);

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
            .catch(() => setDoc(ref, { viewCount: increment(1), viewedBy: arrayUnion(user.uid) }, { merge: true }).catch(e => console.log('view save', e)));
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
            pushNotif(user.uid, 'admin', '👑 Your VIP monthly subscription has expired — renew anytime to restore Radio, Themes, Banner Messages & Post Boosts.');
        }
    }, [user, profile?.isVIP, profile?.vipPlan, profile?.vipExpires, nowTick]);

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
        if(filters.postType === 'user' && i.isAppProduct) return false;
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
    const mqCommission = mqTotalSales * COMMISSION_RATE;
    const topPoster = (() => { const c = {}; items.forEach(i => { if (i.ownerName && !i.isRequest && !i.isDIYRequest) { c[i.ownerName] = c[i.ownerName] || { n: 0, uid: i.ownerPublicUid || i.ownerId }; c[i.ownerName].n++; } }); const e = Object.entries(c).sort((a, b) => b[1].n - a[1].n)[0]; return e ? { name: e[0], n: e[1].n, uid: e[1].uid } : null; })();
    const RAVE_EMOJIS = ['🤘😝 ROCK ON RAVER', '🪩✨ DISCO MODE ENGAGED', '🌈🤝 TRADE THE VIBE', '🔊🦄 BASS UNICORN SPOTTED', '😎🕺 GROOVE SECURED', '🫶💚 KANDI LOVE', '👽🎛️ ALIEN ON THE DECKS', '🍄⚡ MUSH MODE', '🧚‍♀️🔥 FAIRY ON FIRE', '🐸🎧 BASS FROG VIBES', '🦋💜 FLUTTER & FLOW', '🥽🌌 GOGGLES TO THE GALAXY'];
    const plurLine = (() => {
        const A = ['PLUR', 'Peace', 'Love', 'Unity', 'Respect', 'Good vibes', 'Kandi magic', 'The bassline', 'Your aura', 'The rave fam'];
        const B = ['recharges', 'heals', 'uplifts', 'connects', 'electrifies', 'glows through', 'amplifies', 'protects', 'inspires', 'unites'];
        const C = ['the dancefloor', 'every raver', 'your crew', 'the night', 'the universe', 'all of us', 'strangers into family', 'the main stage', 'your spirit', 'the kandi kids'];
        const E = ['💖', '🌈', '✨', '⚡', '🪩', '🫶', '🔮', '🌀'];
        const s = Math.floor(Date.now() / 600000);
        return E[s % E.length] + ' ' + A[s % A.length].toUpperCase() + ' ' + B[(s * 7 + 3) % B.length].toUpperCase() + ' ' + C[(s * 13 + 5) % C.length].toUpperCase() + ' ' + E[(s * 3 + 1) % E.length];
    })();
    const uref = (x) => x ? (x.publicUid || x.id) : null;
    const activeBanner = bannerSlots.find(s => s.start <= nowTick && nowTick < s.end) || null;
    const mq = [
        activeBanner ? { t: (activeBanner.linkUrl ? '🔗 @' : '📢 @') + (activeBanner.name || 'VIP') + ': ' + activeBanner.text + (activeBanner.linkUrl ? ' 🔗' : ' 📢'), uid: activeBanner.linkUrl ? null : (activeBanner.ownerPublicUid || activeBanner.uid), href: activeBanner.linkUrl || null } : null,
        { t: '⚡ GLOBAL VOLUME: ' + (globalStats.userCount * 1337) + ' KANDI ⚡' },
        { t: '🚀 ACTIVE RAVERS: ' + globalStats.userCount + ' 🚀' },
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
        topStats.seller && (topStats.seller.totalSalesValue > 0) ? { t: '📈 HIGHEST NET PROFIT: @' + topStats.seller.displayName + ' ($' + (Number(topStats.seller.totalSalesValue || 0) * (1 - (topStats.seller.customCommissionRate ?? COMMISSION_RATE))).toFixed(2) + ')', uid: uref(topStats.seller) } : null,
        { t: RAVE_EMOJIS[Math.floor(Date.now() / 60000) % RAVE_EMOJIS.length] },
        { t: plurLine },
        { t: '💖 PLUR FACT: Handshakes end with a trade! 💖' },
    ].filter(Boolean);

    // V37.14: boosted posts — pinned to the top 5 feed slots during their hour window
    const activeBoosts = boostSlots.filter(s => s.start <= nowTick && nowTick < s.end).sort((a, b) => (a.start - b.start) || ((a.lane || 0) - (b.lane || 0))).slice(0, 5);
    const boostRank = new Map(activeBoosts.map((s, i) => [s.itemId, i]));
    const displayedFeedItems = filteredItems.map(i => boostRank.has(i.id) ? { ...i, _boosted: true } : i).sort((a, b) => { const ra = boostRank.has(a.id) ? boostRank.get(a.id) : 99; const rb = boostRank.has(b.id) ? boostRank.get(b.id) : 99; return ra - rb; });

    const unreadMsgs = threads.reduce((s, t) => s + ((t.unread && t.unread[user?.uid]) || 0), 0);
    const unreadNotifs = notifs.filter(n => !n.read).length;
    const inboxBadge = unreadMsgs + unreadNotifs;
    
    const WelcomeAlphaModal = () => {
        const facts = ["PLUR stands for Peace, Love, Unity, Respect!", "Kandi trading originated in the 90s rave scene.", "Neon colors glow under UV light because of phosphors!", "The PLUR handshake ends with a bracelet trade."];
        const fact = useMemo(() => facts[Math.floor(Math.random() * facts.length)], []);
        if(!showAlphaModal) return null;
        return (
            <div className="fixed inset-0 bg-black/95 z-[999] flex items-center justify-center p-4">
                <div className="bg-yellow-500/10 border-4 border-dashed border-yellow-500 p-6 rounded-xl text-center space-y-4 shadow-[0_0_40px_rgba(234,179,8,0.3)] max-w-sm w-full">
                    <AlertTriangle size={48} className="text-yellow-400 mx-auto mb-2 animate-pulse"/>
                    <h2 className="text-xl font-black text-yellow-400 uppercase tracking-widest bg-black/50 p-2 rounded">RaveKandi Alpha</h2>
                    <p className="text-xs font-mono text-white/50 mb-4">V42.10.01</p>
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
    const appBackgroundStyle = profile.isVIP && profile.customBackground ? { backgroundImage: `url(${profile.customBackground})`, backgroundSize: 'cover', backgroundPosition: 'center', backgroundAttachment: 'fixed' } : { backgroundColor: '#0f001e' };

    return (
        <div className="min-h-screen pb-24 text-white selection:bg-pink-500/30" style={appBackgroundStyle}>
            <WelcomeAlphaModal />
            <VIPCheckoutModal user={user} isOpen={showVipModal} onClose={() => setShowVipModal(false)} />
            {user && <PublicProfileModal uid={viewingProfileId} onClose={() => setViewingProfileId(null)} />}
            {user && <MainSettingsModal user={user} profile={profile} isOpen={forceSettings} onClose={() => setForceSettings(false)}/>}
            {user && <ShoppingCartModal user={user} items={items} isOpen={cartOpen} onClose={() => setCartOpen(false)}/>}
            <KandiCreatorApplicationModal user={user} isOpen={creatorAppOpen} onClose={() => setCreatorAppOpen(false)} />
            <ReferralModal user={user} profile={profile} isOpen={openReferrals} onClose={() => setOpenReferrals(false)} />
            <TicketModal user={user} profile={profile} isOpen={ticketOpen} onClose={() => setTicketOpen(false)} />
            <ItemDetailModal item={viewingItem ? (items.find(x => x.id === viewingItem.id) || viewingItem) : null} user={user} isOpen={!!viewingItem} onClose={() => setViewingItem(null)} onViewFeed={(uid) => { setViewingItem(null); handleViewFeed(uid); }} />
            {user && <MessengerModal user={user} profile={profile} isOpen={msgOpen} onClose={() => setMsgOpen(false)} threads={threads} notifs={notifs} initialTarget={msgTarget} onConsumeTarget={() => setMsgTarget(null)} />}
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
            
            <RadioPlayerModal user={user} profile={profile} isOpen={radioOpen} onClose={() => setRadioOpen(false)} onGoVip={() => { setRadioOpen(false); setShowVipModal(true); }} onPlayingChange={setIsRadioPlaying} onNowPlaying={setNowPlaying} />

            <div className="sticky top-0 z-50">
            <header className="bg-black/80 backdrop-blur border-b border-white/10 px-4 py-3 flex items-center justify-between">
                <div onClick={() => setPage('home')} className="flex items-center gap-2 cursor-pointer transition-transform active:scale-95"><Zap className="text-yellow-400" size={24} fill="currentColor"/><h1 className="text-xl font-black italic tracking-tighter" style={{ textShadow: '0 0 15px #ff00ff' }}>RaveKandi</h1></div>
                <div className="flex gap-5 items-center">
                    <button onClick={() => setMsgOpen(true)} className="relative text-white/50 hover:text-white"><Mail size={18}/>{inboxBadge > 0 && <span className="absolute -top-1.5 -right-2 bg-pink-600 text-white text-[8px] font-black rounded-full px-1 min-w-[14px] text-center">{inboxBadge > 99 ? '99+' : inboxBadge}</span>}</button>
                    <div className="h-4 w-px bg-white/20 mx-0"></div>
                    <button onClick={() => setPage('feed')}><LayoutList className={page==='feed'?'text-pink-500 shadow-neon-pink':'text-white'} size={20}/></button>
                    <button onClick={() => setPage('shop')}><ShoppingBag className={page==='shop'?'text-cyan-400 shadow-neon-blue':'text-white'} size={20}/></button>
                    <button onClick={() => setPage('profile')}><User className={page==='profile'?'text-purple-500 shadow-neon-purple':'text-white'} size={20}/></button>
                    <div className="h-6 w-px bg-white/20 mx-1"></div>
                    <button onClick={() => setCartOpen(true)}><ShoppingCart className="text-lime-400 shadow-neon-green" size={20}/></button>
                </div>
            </header>
            <div className="w-full bg-black border-b border-white/10 text-[11px] py-1.5 text-lime-400 font-mono overflow-hidden h-9 flex items-center">
                <div className="rk-marquee-track items-center whitespace-nowrap">
                    {[0, 1].map(copy => (
                        <div key={copy} className="flex gap-12 items-center pr-12">
                            {mq.map((m, i) => <span key={i} onClick={m.href ? () => { try { window.open(m.href, '_blank', 'noopener'); } catch (e) {} } : m.uid ? () => setViewingProfileId(m.uid) : undefined} className={(i % 3 === 2 ? 'text-pink-400 ' : i % 3 === 1 ? 'text-cyan-300 ' : '') + ((m.uid || m.href) ? 'underline decoration-dotted underline-offset-2 cursor-pointer' : '')}>{m.t}</span>)}
                        </div>
                    ))}
                </div>
            </div>
            </div>
            
            <button onClick={() => setRadioOpen(true)} className={`fixed left-2 z-40 w-14 h-14 rounded-full flex items-center justify-center border-2 transition-all ${isRadioPlaying ? 'rk-radio-on border-lime-300' : 'rk-radio-off border-red-400'}`} style={{ top: '112px' }} title="Rave Radio"><Radio size={32} className="text-white drop-shadow"/></button>
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
                            <h2 className="text-2xl font-black mb-4 italic tracking-tighter" style={{ textShadow: '0 0 15px #ff00ff', backgroundImage: 'linear-gradient(45deg, #ff80bf, #80ffff)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent' }}>What is Rave Kandi...?</h2>
                            <div className="w-full h-48 bg-black/50 border-2 border-dashed border-white/20 rounded-xl flex items-center justify-center"><Play size={48} className="text-white/20"/></div>
                        </div>
                        
                        <div className="w-full border-t border-white/10 pt-8 mt-2 px-1 text-left">
                            <InfoSection />
                            <CreatorPerksSection onApply={() => setCreatorAppOpen(true)} />
                            <ReferralProgramSection onNavigateToProfile={() => setOpenReferrals(true)} />
                        </div>

                        <div className="max-w-md mx-auto w-full bg-black/60 border-2 border-dashed border-purple-400/50 rounded-xl p-4 text-center" style={{ boxShadow: '0 0 18px rgba(216,180,254,0.35)' }}>
                            <p className="text-lg font-black uppercase tracking-wide rk-pastel-shift bg-clip-text text-transparent" style={{ backgroundImage: 'linear-gradient(90deg, #ffd1f7, #c4f0ff, #d8ffd1, #fff3c4, #ffd1f7)' }}>🎬 Calling all video creators!</p>
                            <p className="text-xs text-gray-100 mt-1 mb-3">We're looking for a video creator to make the official RaveKandi promo — this spot is reserved for the finished video. Think you've got the vibe?</p>
                            <Button onClick={contactAdmin} color="purple" className="w-full text-xs">📩 Message the Admin Team</Button>
                        </div>

                        <div className="max-w-md mx-auto w-full">
                            <h3 className="text-lg font-black uppercase tracking-widest text-center mb-2 animate-text-shimmer" style={{ backgroundImage: 'linear-gradient(45deg, #fde047, #fff7c2, #facc15, #fde047)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent', backgroundSize: '200% 200%', filter: 'drop-shadow(0 0 8px rgba(250,204,21,0.5))' }}>Custom and DIY Requests</h3>
                            <div className="w-full bg-yellow-900/15 border-2 border-yellow-400/70 rounded-xl p-4 text-left shadow-[0_0_14px_rgba(250,204,21,0.25)]">
                                <p className="text-sm text-yellow-300 font-bold uppercase mb-2">⚖ Creator Fairness Window</p>
                                <p className="text-xs text-gray-100 leading-relaxed">Custom & DIY requests sent to a specific Creator stay exclusive to them for <strong>24–72 hours</strong> (scaled by price and complexity). If unaccepted in that window, the request automatically opens to ALL Creators — keeping commissions fair for users and Creators alike.</p>
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
                    <Card className="bg-[#1a0033]/95 shadow-2xl border-white/20 py-3 mb-4">
                        <div className="grid grid-cols-3 gap-3 mb-3">
                            <div><label className="text-[8px] font-bold opacity-50 uppercase ml-1">Post Type</label><select value={filters.postType} onChange={e=>setFilters({...filters, postType: e.target.value})} className={selectStyle}><option value="all">All</option><option value="official">Official</option><option value="user">User</option><option value="users">User Profiles</option></select></div>
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
                                        <p className="font-bold text-sm flex items-center truncate">@{u.displayName || 'Raver'}<BadgeChip badge={u.featuredBadge} /></p>
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
                    <div className="grid grid-cols-1 gap-6">{displayedFeedItems.map(item => <ItemCard key={item.id} item={item} user={user} profile={profile} onViewProfile={setViewingProfileId} onAddToCart={addToCart} onViewItem={handleViewItem}/>)}</div>
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
                {page === 'profile' && <ProfileView user={user} onOpenSettings={() => setForceSettings(true)} onViewFeed={handleViewFeed}/>}
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
                    <span className="flex-1 text-center">V42.10.01 Phase 14: 25% RevShare, Promo Callout & Social Cards</span>
                    <span className="w-14"></span>
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

echo "Applying Android Version Patch (V42.10.01)..."
sed -i "s/versionCode 1/versionCode 58/g" android/app/build.gradle
sed -i 's/versionName "1.0"/versionName "42.10.01"/g' android/app/build.gradle

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

APK_NAME="RaveKandi_V42_10_01_$(date +%H%M%S).apk"
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
