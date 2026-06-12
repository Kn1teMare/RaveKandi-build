# Block 1
mkdir -p ~/ravekandi-app/public
mkdir -p ~/ravekandi-app/src
cd ~/ravekandi-app

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover" />
    <title>RaveKandi V37.08.02</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style> body { background-color: #0a0014; color: white; margin: 0; padding: 0; } </style>
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
  handleGlobalError = (event) => { this.logError(`Global: ${event.message || event.error}`); }
  handlePromiseRejection = (event) => { this.logError(`Promise: ${event.reason}`); }
  
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
              {minimized ? `🐞 Bugs (${errorLogs.length})` : 'System Diagnostic Log V37.08.02'}
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
      },
      keyframes: {
        textShimmer: { '0%, 100%': { 'background-size': '200% 200%', 'background-position': 'left center' }, '50%': { 'background-size': '200% 200%', 'background-position': 'right center' } },
        fadeInPulse: { '0%, 100%': { opacity: '0.7', transform: 'scale(1)', filter: 'blur(1px)' }, '50%': { opacity: '1', transform: 'scale(1.05)', filter: 'blur(0px)' } },
        tracerGlow: { '0%': { backgroundPosition: '0% 50%' }, '50%': { backgroundPosition: '100% 50%' }, '100%': { backgroundPosition: '0% 50%' } },
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
import { initializeApp } from 'firebase/app';
import { getAuth, onAuthStateChanged, setPersistence, browserLocalPersistence, indexedDBLocalPersistence, browserSessionPersistence, signOut, updateEmail, signInWithEmailAndPassword, createUserWithEmailAndPassword, GoogleAuthProvider, TwitterAuthProvider, OAuthProvider, signInWithPopup, signInAnonymously } from 'firebase/auth';
import { getFirestore, initializeFirestore, doc, collection, query, onSnapshot, addDoc, updateDoc, setDoc, deleteDoc, arrayUnion, arrayRemove, where, getDoc, getDocs, orderBy, increment, runTransaction, writeBatch } from 'firebase/firestore';
import { getStorage, ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage';
import { SplashScreen } from '@capacitor/splash-screen';
import { loadStripe } from '@stripe/stripe-js';
import { Elements, CardElement, useStripe, useElements } from '@stripe/react-stripe-js';
import { QRCodeCanvas } from 'qrcode.react';
import { 
  AlertTriangle, Award, Bell, Bot, Box, Briefcase, Calendar, Camera, Check, CheckCircle, ChevronDown, ChevronUp, 
  Clock, Code, Copy, CreditCard, DollarSign, Edit, Eye, Facebook, FileText, Filter, Gift, Globe, Hammer, Heart, 
  Image as ImageIcon, Info, Instagram, LayoutList, Link, Lock, LogOut, Mail, MapPin, MessageSquare, 
  Package, Pencil, Play, PlusCircle, MinusCircle, Receipt, RefreshCw, Save, Send, Settings, Share2, Shield, ShieldCheck, 
  ShoppingBag, Smartphone, Sparkles, Star, Tag, Trash2, Truck, Twitch, Twitter, User, Video, Wallet, 
  Wand2, XCircle, Youtube, Zap, HelpCircle, Search, Phone, Music, Ghost, CheckSquare, Square, Activity, WifiOff, Users, ThumbsUp, MoreHorizontal, ShoppingCart, 
  Trash, Maximize2, List, BarChart3, TrendingUp, Pickaxe, Radio, Crown, Music as MusicIcon, Star as StarIcon, Disc
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

const PREMIUM_RADIO_URL = "https://cdn.pixabay.com/download/audio/2022/03/15/audio_7314545d17.mp3?filename=electronic-future-beats-117997.mp3";

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
];

const REFERRAL_TIERS = [
    { min: 1, max: 4, badge: 'Neon Pink', sharePct: 1, color: 'text-pink-500' },
    { min: 5, max: 9, badge: 'Slime Green', sharePct: 1.5, color: 'text-lime-400' },
    { min: 10, max: 24, badge: 'Liquid Metal', sharePct: 2, color: 'text-cyan-400' },
    { min: 25, max: 49, badge: 'Holographic', sharePct: 2.5, color: 'text-purple-400' },
    { min: 50, max: 99, badge: 'Laser Core', sharePct: 3, color: 'text-yellow-400' },
    { min: 100, max: 249, badge: 'Plasma', sharePct: 3.5, color: 'text-red-500' },
    { min: 250, max: 499, badge: 'Supernova', sharePct: 4, color: 'text-orange-400' },
    { min: 500, max: 999, badge: 'Dark Matter', sharePct: 4.5, color: 'text-gray-400' },
    { min: 1000, max: 5000, badge: 'PLUR God', sharePct: 5, color: 'text-white' }
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

export const ensureUserExists = async (uid, customName = null, referrerUid = null) => {
    if (!uid) return;
    const userRef = doc(db, 'artifacts', appId, 'users', uid);
    const globalStatsRef = doc(db, 'artifacts', appId, 'global', 'stats');
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

                transaction.set(userRef, { 
                    displayName: newUsername, publicUid: uid, publicUidChanged: false, pastPublicUids: [],
                    usernameChangesLeft: 3, pastUsernames: [], joined: Date.now(), items: [], totalSalesValue: 0, totalBoughtValue: 0,
                    itemsSold: 0, itemsBought: 0, totalLikes: 0, totalComments: 0, badgesCollected: 0,
                    referrals: 0, completedTrades: 0, socialInteractions: 0, aiUsageCount: 0, lastAiReset: 0,
                    referredBy: referrerUid || null, totalRevShareEarned: 0, customCommissionRate: null,
                    isVIP: false, customBackground: null
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

const generateCustomKandi = async (prompt) => {
    try {
        const seed = Math.floor(Math.random() * 9999999);
        const safePrompt = encodeURIComponent(`Rave kandi beads, festival apparel: ${prompt}`);
        const textUrl = `https://text.pollinations.ai/prompt/You%20are%20a%20master%20Rave%20Kandi%20builder.%20The%20user%20wants:%20${safePrompt}.%20Return%20ONLY%20a%20JSON%20object%20with%20NO%20MARKDOWN.%20Format:%20{%22visual_description%22:%22detailed%20description%22,%22total_bead_count%22:150,%22difficulty_1_to_10%22:6,%22estimated_materials%22:[{%22name%22:%22string%22,%22qty%22:%22string%22}]}`;
        
        const response = await fetch(textUrl);
        if (!response.ok) throw new Error("AI Text endpoint failed.");
        const rawText = await response.text();
        
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

        const cleanVisual = analysis.visual_description.replace(/[^a-zA-Z0-9 ]/g, '').substring(0, 100);
        const visualStr = encodeURIComponent(`Macro photography rave kandi ${cleanVisual}`);
        const imageUrl = `https://image.pollinations.ai/prompt/${visualStr}?width=512&height=512&seed=${seed}&nologo=true`;
        
        const beads = analysis.total_bead_count || 100;
        const diff = analysis.difficulty_1_to_10 || 5;
        let estCost = ((beads * 0.05) + (diff * 2.00)) * PROFIT_MARGIN;
        if(estCost < 4.00) estCost = 4.00;
        
        return { ...analysis, imageUrl, estimated_cost: estCost.toFixed(2), difficulty: diff };
    } catch (e) { throw new Error("AI Assembly Failed: " + e.message); }
};

const getDisplayAchievements = (profile) => {
    const stats = { totalItems: profile?.items?.length || 0, totalSalesValue: profile?.totalSalesValue || 0, isKandiCreator: profile?.isKandiCreator?1:0, socialInteractions: profile?.socialInteractions||0, referrals: profile?.referrals||0 };
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

const Input = ({ label, value, onChange, type = 'text', options, className, placeholder, maxLength, disabled, autoComplete }) => ( <div className={`mb-4 ${className}`}>{label && <label className="block text-sm font-bold mb-1" style={getTextGlowStyle('purpleGlow')}>{label}</label>}{type === 'select' ? (<select disabled={disabled} value={value} onChange={e => onChange(e.target.value)} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none text-white"><option value="">Select</option>{options.map(o => <option key={o} value={o} className="text-black">{o}</option>)}</select>) : type === 'textarea' ? (<textarea disabled={disabled} value={value} onChange={e => onChange(e.target.value)} rows="3" maxLength={maxLength} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none" placeholder={placeholder}/>) : (<input autoComplete={autoComplete} disabled={disabled} type={type} value={value} onChange={e => onChange(e.target.value)} className="w-full p-2 rounded bg-white/10 border-2 border-white/30 focus:outline-none" placeholder={placeholder}/>)}</div> );

const Modal = ({ isOpen, onClose, title, children }) => { if (!isOpen) return null; return ( <div className="fixed inset-0 bg-black/90 z-50 flex items-center justify-center p-4 overflow-y-auto"><Card className="max-w-md w-full my-8" glow="primaryGlow"><div className="flex justify-between items-center mb-4 border-b border-white/20 pb-2"><h3 className="text-xl font-bold" style={getTextGlowStyle('primaryGlow')}>{title}</h3><button onClick={onClose}><XCircle/></button></div>{children}</Card></div> ); };

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
                <div className="absolute bottom-2 left-0 w-full flex justify-center gap-1 z-20">
                    {media.map((_, i) => <button key={i} onClick={(e)=>{e.stopPropagation(); setIdx(i);}} className={`w-2 h-2 rounded-full ${i===idx ? 'bg-pink-500' : 'bg-white/50'}`} />)}
                </div>
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
        const newComment = { text: comment, user: profile?.displayName || user.displayName || 'Raver', uid: profile?.publicUid || user.uid, time: Date.now() }; 
        await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { comments: arrayUnion(newComment) }); 
        setComments([...comments, newComment]); 
        setComment(''); 
    };
    
    if (!isOpen || !item) return null;
    return ( 
        <Modal isOpen={isOpen} onClose={onClose} title="Comments">
            <div className="max-h-60 overflow-y-auto mb-4 space-y-2">
                {comments.map((c, i) => (
                    <div key={i} className="bg-white/5 p-2 rounded text-sm">
                        <span className="font-bold text-pink-400 cursor-pointer hover:underline" onClick={() => { onClose(); onViewProfile(c.uid); }}>{c.user}:</span> {c.text}
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
        if(!uid) return;
        const q = query(collection(db, 'artifacts', appId, 'users'), where('publicUid', '==', uid));
        getDocs(q).then(snap => {
            if(!snap.empty) { setTarg(snap.docs[0].data()); } 
            else {
                getDoc(doc(db, 'artifacts', appId, 'users', uid)).then(s => { if(s.exists()) setTarg(s.data()); else setTarg('not_found'); });
            }
        });
    }, [uid]);
    if(!uid) return null;
    return (
        <Modal isOpen={!!uid} onClose={onClose} title={targ === 'not_found' ? "Not Found" : (targ?.displayName || 'Loading...')}>
            {targ === 'not_found' ? <p className="opacity-50 text-center">User no longer exists.</p> : !targ ? <LoadingBar className="w-full"/> : (
                <div className="text-center space-y-4">
                    <img src={targ.photoURL || 'https://placehold.co/100?text=User'} className="w-24 h-24 rounded-full mx-auto object-cover border-2 border-pink-500"/>
                    <p className="italic opacity-80 bg-white/5 p-2 rounded text-xs">{targ.bio || "No vibe check yet."}</p>
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
        return onSnapshot(q, s => setRefs(s.docs.map(d => ({id: d.id, ...d.data()}))));
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
            else { await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications'), { ...d, uid: user.uid, status: 'pending', submittedAt: Date.now() }); }
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
        </Card>
    );
    return (
        <Card glow="primaryGlow" className="max-w-md mx-auto text-left relative z-10 bg-black/60 backdrop-blur-md">
            {onClose && <button onClick={onClose} className="absolute top-2 right-2 text-white/50 z-20"><XCircle/></button>}
            <div className="flex items-center gap-3 mb-4 border-b border-white/20 pb-4 pr-6">
                <Hammer className="text-pink-500" size={28}/>
                <div><h3 className="text-xl font-black italic tracking-wider leading-none" style={getTextGlowStyle('primaryGlow')}>{existingId ? 'EDIT APP' : 'BECOME A CREATOR'}</h3><p className="text-[10px] opacity-70 mt-1">Unlock commissions & official drops</p></div>
            </div>
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

    const handleVIPSuccess = async (e) => {
        e.preventDefault();
        if (!stripe || !elements) return;
        setLoading(true);
        setTimeout(async () => {
            try {
                await updateDoc(doc(db, 'artifacts', appId, 'users', user.uid), { isVIP: true });
                alert("VIP Status Unlocked! Enjoy Premium Radio and Custom Backgrounds.");
            } catch(err) { console.error(err); }
            setLoading(false);
            onClose();
        }, 1500);
    };

    return (
        <form onSubmit={handleVIPSuccess} className="text-center space-y-4">
            <Crown size={48} className="mx-auto text-yellow-400 mb-2" />
            <p className="text-sm">Get lifetime access to the <strong>Global EDM Radio Player</strong> and <strong>Custom App Backgrounds</strong> for a one-time payment of $5.00.</p>
            <div className="bg-white/10 p-3 rounded border border-white/20 text-left">
                <CardElement options={{style:{base:{color:'#fff'}}}}/>
            </div>
            <Button type="submit" disabled={!stripe || loading} color="gold" className="w-full">
                {loading ? "Processing..." : "Pay $5.00 to Unlock"}
            </Button>
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
                <Input value={url} onChange={setUrl} placeholder="https://my-custom-gif.com/image.gif" />
                <div className="bg-white/5 p-3 rounded border border-white/10">
                    <label className="text-[10px] font-bold text-pink-400 mb-1 block">Upload Background</label>
                    <input type="file" accept="image/*" onChange={handleFile} className="text-[10px] w-full" disabled={uploading}/>
                    {uploading && <p className="text-[10px] text-lime-400 mt-1">Processing...</p>}
                </div>
                <div className="flex gap-2">
                    <Button onClick={() => setUrl('')} color="red" className="flex-1">Clear Theme</Button>
                    <Button onClick={saveTheme} color="lime" className="flex-1">Save Theme</Button>
                </div>
            </div>
        </Modal>
    );
};
EOF

# Block 9
cat << 'EOF' >> src/App.js
const MainSettingsModal = ({ user, profile, isOpen, onClose }) => { 
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
        <Button onClick={saveSettings} color="lime" className="w-full text-xs">Save Changes</Button>
        <div className="flex gap-2 mt-4"><Button onClick={toggleAdmin} color="purple" className="flex-1 text-[10px]">DevMode</Button><Button onClick={handleLogout} color="accent" className="flex-1 text-[10px] bg-red-900/50 border-red-500">{user?.isAnonymous ? "Create Account" : "Log Out"}</Button></div>
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

const ShoppingCartModal = ({ user, isOpen, onClose }) => {
    const [cartItems, setCartItems] = useState([]);
    const [selectedIds, setSelectedIds] = useState([]);
    const [checkoutMode, setCheckoutMode] = useState('cart');
    
    useEffect(() => {
        if(!isOpen || !user?.uid) return;
        const q = query(collection(db, 'artifacts', appId, 'users', user.uid, 'cart'));
        return onSnapshot(q, s => setCartItems(s.docs.map(d => ({id: d.id, ...d.data()}))));
    }, [isOpen, user]);
    
    const handleRemove = async (id) => { if(window.confirm("Permanently delete this item from your cart?")) await deleteDoc(doc(db, 'artifacts', appId, `users/${user.uid}/cart`, id)); };
    const toggleSelection = (id) => { if (selectedIds.includes(id)) { setSelectedIds(selectedIds.filter(sid => sid !== id)); } else { setSelectedIds([...selectedIds, id]); } };
    const totalCost = cartItems.filter(item => selectedIds.includes(item.id)).reduce((sum, item) => sum + (item.price || 0), 0);
    
    const handleSuccess = async () => {
        try {
            const batch = writeBatch(db);
            let total = 0;
            const buyerRef = doc(db, 'artifacts', appId, 'users', user.uid);
            const buyerSnap = await getDoc(buyerRef);
            const referrerUid = buyerSnap.data()?.referredBy;

            for (const item of cartItems.filter(i => selectedIds.includes(i.id))) {
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
                        const tier = getReferralTier(refSnap.data()?.referrals || 0);
                        const revShare = appCommission * (tier.sharePct / 100);
                        batch.update(refRef, { totalRevShareEarned: increment(revShare) });
                        const refListRef = doc(db, 'artifacts', appId, 'users', referrerUid, 'myReferrals', user.uid);
                        batch.set(refListRef, { earnedFromThisUser: increment(revShare) }, { merge: true });
                    }
                }
                batch.delete(doc(db, 'artifacts', appId, `users/${user.uid}/cart`, item.id));
            }
            batch.update(buyerRef, { itemsBought: increment(selectedIds.length), totalBoughtValue: increment(total) });
            await batch.commit();
            alert("Order Processed Successfully!");
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
            <div className="space-y-4 max-h-[60vh] overflow-y-auto p-1">
                {cartItems.length === 0 && <p className="text-center opacity-50 py-4">Your cart is empty.</p>}
                {cartItems.map(item => (
                    <div key={item.id} className="bg-white/5 p-3 rounded flex items-center gap-3">
                        <input type="checkbox" checked={selectedIds.includes(item.id)} onChange={() => toggleSelection(item.id)} className="accent-lime-400" />
                        <img src={item.mediaUrls?.[0]?.url || item.imageUrl || 'https://placehold.co/50'} className="w-12 h-12 rounded object-cover"/>
                        <div className="flex-1">
                            <p className="text-xs font-bold truncate">{item.name}</p>
                            <p className="text-xs text-lime-400">${item.price?.toFixed(2)}</p>
                        </div>
                        <button onClick={() => handleRemove(item.id)} className="text-red-400"><Trash size={16}/></button>
                    </div>
                ))}
            </div>
            <div className="mt-4 border-t border-white/10 pt-4">
                <div className="flex justify-between items-center mb-4">
                    <span className="font-bold">Total:</span><span className="text-xl font-black text-lime-400">${totalCost.toFixed(2)}</span>
                </div>
                <Button disabled={selectedIds.length === 0} onClick={() => setCheckoutMode('select')} color="lime" className="w-full">Checkout ({selectedIds.length})</Button>
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
        if(isOpen && item && user && user.uid !== item.ownerId) {
            updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { viewCount: increment(1) }).catch(e=>console.log(e));
        }
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
                <MediaCarousel media={item.mediaUrls} fallback={item.imageUrl || item.image} />
                
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
            const allItems = s.docs.map(d => ({id: d.id, ...d.data()}));
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

    const gen = async () => { 
        if(!prompt || !user?.uid) return;
        if(remaining <= 0) return alert("Daily limit reached. Resets at 12PM CST.");
        setLoading(true); setImageReady(false); setRes(null); await ensureUserExists(user.uid);
        
        const docRef = await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), { 
            status: 'generating', prompt: prompt, timestamp: Date.now(), name: "AI Design (Pending)",
            ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver' 
        });
        
        try { 
            const r = await generateCustomKandi(prompt); setRes(r);
            const userRef = doc(db, 'artifacts', appId, 'users', user.uid);
            const snap = await getDoc(userRef);
            if (snap.exists()) { await updateDoc(userRef, { aiUsageCount: increment(1) }); } 
            else { await setDoc(userRef, { aiUsageCount: 1 }, { merge: true }); }
            setRemaining(prev => prev - 1);
            await updateDoc(docRef, { status: 'completed', imageUrl: r.imageUrl, visual_description: r.visual_description, estimated_materials: r.estimated_materials, estimated_cost: r.estimated_cost, difficulty: r.difficulty, name: "AI Custom Kandi", type: "Other" });
        } catch(e){ alert(e.message); await updateDoc(docRef, { status: 'failed', error: e.message }); } finally { setLoading(false); setImageReady(true); } 
    };

    const submit = async () => {
        if(!user?.uid) return;
        if(user.isAnonymous && allowBuy) return alert("Please create an account to sell items.");
        if (allowBuy && !itemName) return alert("You must name your item to allow others to buy it.");
        setLoading(true);
        try {
            const inventoryData = { status: 'completed', imageUrl: res.imageUrl, visual_description: res.visual_description, estimated_materials: res.estimated_materials, estimated_cost: res.estimated_cost, difficulty: res.difficulty, name: itemName || "AI Custom Kandi", timestamp: Date.now(), allowBuy: allowBuy, isDIYRequest: false, isAICreation: true, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', type: "Other", viewCount: 0 };
            await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'), inventoryData);
            if (allowBuy) { await addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), { ...inventoryData, ownerId: user.uid, ownerName: profile?.displayName || 'Raver', isAppProduct: false, purchaseCount: 0, shareCount: 0, status: 'approved', likes: [], comments: [] }); alert("Submitted for approval!"); } 
            else { alert("Saved to your collection!"); }
            setPrompt(''); setRes(null); setAllowBuy(false); setItemName('');
        } catch (e) { alert("Error saving: " + e.message); } finally { setLoading(false); }
    };

    return ( 
        <Card className="p-6 text-center">
            <Bot size={48} className="mx-auto mb-4 text-pink-500"/>
            <h2 className="text-2xl font-bold mb-2 uppercase">AI KANDI LAB</h2>
            <div className="flex justify-center gap-2 mb-4"><span className={`text-[10px] font-bold px-2 py-1 rounded ${remaining > 0 ? 'bg-lime-500/20 text-lime-400' : 'bg-red-500/20 text-red-400'}`}>Daily Limit: {remaining}/{DAILY_AI_LIMIT}</span></div>
            {!res && ( <div className="mb-4 flex items-center justify-center gap-2 bg-white/5 p-2 rounded"><input type="checkbox" checked={allowBuy} onChange={e => setAllowBuy(e.target.checked)} className="accent-pink-500"/><label className="text-xs">Allow others to buy this design?</label></div> )}
            <Input type="textarea" value={prompt} onChange={setPrompt} placeholder="E.g. Neon green cuff with alien charms..." disabled={!!res}/>
            {!res && ( loading ? ( <div className="mt-4"><Button disabled color="purple" className="w-full">Generating...</Button><LoadingBar progress={100} /></div> ) : ( <Button onClick={gen} disabled={remaining <= 0} color={remaining > 0 ? "lime" : "accent"} className="w-full">{remaining > 0 ? "Generate Design" : "Limit Reached"}</Button> ) )}
            {res && (
                <div className={`mt-6 border-2 border-dashed border-white/20 rounded-lg p-2 min-h-[200px] flex items-center justify-center bg-black/40 ${res ? 'shadow-[0_0_20px_rgba(255,100,200,0.6)] border-pink-400' : ''}`}>
                    <div className="w-full">
                        <img src={res.imageUrl} className={`rounded mb-2 w-full shadow-2xl transition-opacity duration-500 ${imageReady ? 'opacity-100' : 'opacity-0 h-0'}`} onLoad={() => setImageReady(true)} onError={(e) => { e.target.src = 'https://placehold.co/512x512/1a0033/ff00ff?text=AI+Image+Failed'; setImageReady(true); }} />
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
        getDocs(q).then(snap => setCreators(snap.docs.map(d => ({id: d.id, ...d.data()}))));
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

    useEffect(() => {
        if(!activeCreator) { setCreatorStock([]); return; }
        const q = query(collection(db, 'artifacts', appId, 'users', activeCreator.id, 'inventory'));
        getDocs(q).then(snap => {
            const stock = snap.docs.map(d => ({id: d.id, ...d.data()})).filter(i => i.isCraftingStock);
            setCreatorStock(stock);
        });
    }, [activeCreator]);
    
    const total = useMemo(() => {
        const raw = build.reduce((s, i) => s + (parseFloat(i.sell) || parseFloat(i.cost) || 0), 0);
        return raw > 0 ? raw : 0;
    }, [build]);
    
    const add = (i) => setBuild(prev => [...prev, i]); 
    const remove = (index) => setBuild(prev => prev.filter((_, i) => i !== index));
    const submitDesign = () => { onSubmitRequest({ name: "DIY Custom Request", price: total, components: build, description: desc, isDIYRequest: true, type: "Other", viewCount: 0, assignedCreatorId: activeCreator?.id }); setSuccess(true); setBuild([]); setDesc(''); setActiveCreator(null); };

    return ( 
        <div className="flex flex-col gap-4 max-h-[85vh]">
            <CreatorSelectCarousel onSelectCreator={setActiveCreator} />
            
            <div className="flex flex-col md:flex-row gap-4 flex-1 overflow-hidden min-h-[500px]">
                {success && (
                    <Modal isOpen={success} onClose={() => setSuccess(false)} title="Submission Received">
                        <div className="text-center py-4 space-y-4">
                            <CheckCircle size={48} className="text-lime-400 mx-auto"/>
                            <div className="text-left bg-white/5 p-4 rounded text-xs space-y-2 opacity-80"><p>1. Your build has been sent directly to <strong>{activeCreator?.displayName || 'the Creator'}</strong>.</p><p>2. They will review your design and accept the commission within <strong>24 hours</strong>.</p></div>
                            <Button onClick={() => setSuccess(false)} color="primary" className="w-full">Got it</Button>
                        </div>
                    </Modal>
                )}
                
                <Card className="flex-none h-1/2 md:h-full md:w-1/2 overflow-hidden flex flex-col">
                    <h3 className="font-bold mb-2 shrink-0 italic tracking-widest uppercase">DIY STUDIO</h3>
                    {!activeCreator ? (
                        <div className="flex-1 flex items-center justify-center text-[10px] opacity-50 border border-dashed border-white/10 rounded">Select a Creator above to load their inventory.</div>
                    ) : (
                        <div className="flex-1 overflow-y-auto grid grid-cols-3 gap-1 content-start p-1">
                            {creatorStock.length === 0 && <p className="col-span-3 text-center text-[10px] opacity-50 pt-10">This creator has no active crafting stock.</p>}
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
                <div className="flex-1 flex flex-col gap-2 h-full overflow-hidden">
                    <Card className="flex-1 overflow-hidden flex flex-col" glow="purpleGlow">
                        <h3 className="font-bold mb-2 shrink-0" style={getTextGlowStyle('purpleGlow')}>Your Build ({build.length})</h3>
                        <div className="flex-1 overflow-y-auto bg-black/20 p-2 rounded">
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
                    <Card className="shrink-0 flex justify-between items-center bg-[#1a0033]" glow="limeGlow"><div className="text-xl font-bold text-white">Total: <span className="text-lime-400">${total.toFixed(2)}</span></div><Button onClick={submitDesign} disabled={build.length===0 || !activeCreator} color="lime" className="shadow-neon-green">Submit Build</Button></Card>
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
    
    const isOwner = user?.uid === item.ownerId;
    const isBuyer = item.buyers?.includes(user?.uid);
    const canSeePrice = item.purchaseCount === 0 || isOwner || isBuyer;

    const toggleLike = async () => { if(!user?.uid) return; const ref = doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id); if(liked) await updateDoc(ref, { likes: arrayRemove(user.uid) }); else await updateDoc(ref, { likes: arrayUnion(user.uid) }); setLiked(!liked); };
    
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
                    <button onClick={() => onViewProfile(item.ownerPublicUid || item.ownerId)} className="text-xs text-pink-400 font-bold hover:underline cursor-pointer">@{item.ownerName}</button>
                    <span className="text-lime-400 font-bold">
                        {canSeePrice ? `$${item.price?.toFixed(2)}` : <span className="text-[10px] text-white/50 italic bg-white/10 px-2 py-1 rounded">SOLD</span>}
                    </span>
                </div>
                <p className="text-[10px] opacity-70 truncate mt-1">{item.description}</p>
                <div className="flex gap-2 mt-2">
                    <span className="text-[8px] bg-white/10 px-1 rounded border border-white/20">Qty: {item.stockQty || 1}</span>
                    {item.bulkDiscountPct > 0 && <span className="text-[8px] bg-lime-500/20 text-lime-400 px-1 rounded border border-lime-500/50">{item.bulkDiscountPct}% off {item.bulkDiscountQty}+</span>}
                    <span className="text-[8px] bg-black/50 px-1 rounded border border-white/10 flex items-center gap-1"><Eye size={8}/> {item.viewCount || 0}</span>
                    {avgRating && <span className="text-[8px] bg-yellow-900/30 px-1 rounded border border-yellow-500/50 flex items-center gap-1 text-yellow-400"><StarIcon size={8} fill="currentColor"/> {avgRating}</span>}
                </div>
            </div>
            
            <div className="mt-auto flex justify-between items-center pt-3 border-t border-white/10">
                <div className="flex gap-3"><button onClick={toggleLike} className={liked ? 'text-pink-500' : 'text-white/50'}><Heart size={18} fill={liked?"currentColor":"none"}/></button><button onClick={() => setShowComments(true)} className="text-white/50 hover:text-white"><MessageSquare size={18}/></button><button onClick={handleShare} className="text-white/50 hover:text-cyan-400"><Share2 size={18}/></button></div>
                {item.isAICreation && !item.allowBuy ? ( <Button onClick={() => onViewProfile(item.ownerPublicUid || item.ownerId)} color="purple" className="text-xs py-1 px-3">View Collection</Button> ) : ( <Button disabled={item.purchaseCount > 0 && item.stockQty <= 1} onClick={() => onAddToCart(item)} color="accent" className="text-xs py-1 px-3 flex items-center gap-1"><ShoppingCart size={12}/> Add</Button> )}
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

            const item = { ...form, price: parseFloat(form.price), type: form.type || 'Other', stockQty: parseInt(form.stockQty), bulkDiscountQty: parseInt(form.bulkDiscountQty||0), bulkDiscountPct: parseInt(form.bulkDiscountPct||0), mediaUrls: uploadedMedia, imageUrl: uploadedMedia[0]?.url, ownerId: user.uid, ownerPublicUid: profile?.publicUid || user.uid, ownerName: profile?.displayName || 'Raver', timestamp: Date.now(), likes: [], comments: [], isAppProduct: form.isOfficial, status: 'approved', purchaseCount: 0, viewCount: 0, isPinned: form.isPinned, isCraftingStock: false }; 
            
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
const AdminDashboard = () => {
    const [apps, setApps] = useState([]);
    const [targetUid, setTargetUid] = useState('');
    const [customRate, setCustomRate] = useState('');

    useEffect(() => onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications'), where('status', '==', 'pending')), s => setApps(s.docs.map(d => ({id: d.id, ...d.data()})))), []);
    const approve = async (a) => { if(window.confirm("Approve?")) { await updateDoc(doc(db, 'artifacts', appId, 'users', a.uid), { isKandiCreator: true }); await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'kandiCreatorApplications', a.id), { status: 'approved' }); } };
    
    const setCommRate = async () => {
        if(!targetUid || !customRate) return;
        await updateDoc(doc(db, 'artifacts', appId, 'users', targetUid), { customCommissionRate: parseFloat(customRate) });
        alert(`Commission rate for ${targetUid} set to ${customRate}`);
        setTargetUid(''); setCustomRate('');
    };

    return (
        <Card className="mt-8 border-red-500/30">
            <h3 className="font-bold text-red-400 mb-4 uppercase italic">Admin Console</h3>
            
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
    const [requests, setRequests] = useState([]);
    useEffect(() => {
        const q = query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), where('status', '==', 'pending'));
        return onSnapshot(q, s => setRequests(s.docs.map(d => ({id: d.id, ...d.data()}))));
    }, []);
    const handleApprove = async (item) => { if(!window.confirm("Approve and assign to yourself?")) return; await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { status: 'approved', assigneeId: user.uid, assigneeName: user.displayName, approvedAt: Date.now() }); };
    const handleDismiss = async (item) => { const r = prompt("Reason for dismissal:"); if(!r) return; await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { status: 'dismissed', dismissReason: r }); };
    return ( <div className="fixed inset-0 bg-black z-50 overflow-y-auto p-4"><div className="flex justify-between items-center mb-6"><h2 className="text-2xl font-black italic text-lime-400 uppercase tracking-widest">Creator Hub</h2><button onClick={onClose}><XCircle size={32}/></button></div><div className="grid gap-4">{requests.length === 0 ? <p className="opacity-50 italic uppercase text-xs">Queue Clean</p> : requests.map(req => (<Card key={req.id} className="border-lime-500/30"><div className="flex justify-between items-start"><div><h3 className="font-bold text-lg">{req.name}</h3><p className="text-xs opacity-70">Client: {req.ownerName}</p>{req.isAICreation && <span className="bg-purple-500/20 text-purple-400 text-[8px] px-1 rounded">AI Generated</span>}</div><span className="text-lime-400 font-bold">${req.price?.toFixed(2)}</span></div><div className="bg-white/5 p-2 rounded mt-2 text-xs"><p className="font-bold mb-1">Vision:</p><p>{req.description || req.visual_description}</p></div><div className="mt-4 flex gap-2"><Button onClick={()=>handleApprove(req)} color="lime" className="flex-1 text-xs shadow-neon-green uppercase font-black italic">Approve</Button><Button onClick={()=>handleDismiss(req)} color="accent" className="flex-1 text-xs uppercase font-black italic">Dismiss</Button></div></Card>))}</div></div> );
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
        { title: "🤝 The PLUR Reward System (RevShare)", content: "We share our profits with you. When you refer a friend using your UID, you unlock RevShare. You earn 1% to 5% of our app's commission every time your referral makes a purchase—forever. Tier 1 starts at 1 referral. Maximum cap is Tier 9 (5,000 referrals)." },
        { title: "📦 Mandatory Tracking Numbers", content: "To protect both buyers and sellers, tracking numbers are mandatory for all physical goods. Once a tracking number is uploaded by the seller, it is permanently locked and only viewable by the direct Buyer and the Seller in their private collection dashboard. No funds are fully cleared until tracking is active." },
        { title: "🛡️ Safe Checkout (Stripe & Solana)", content: "We offer dual checkout. Pay instantly with practically zero fees and full anonymity using Solana/USDC crypto wallets (Phantom, Coinbase, MetaMask). Or, pay traditionally with standard credit/debit cards via Stripe's encrypted portal." }
    ];
    return (
        <div className="mt-8 text-left max-w-md mx-auto">
            <h3 className="text-xl font-black italic text-pink-400 mb-4 tracking-wider">How RaveKandi Works</h3>
            <div className="space-y-2">
                {infos.map((info, i) => (
                    <div key={i} className="bg-white/5 border border-white/10 rounded-lg overflow-hidden transition-all">
                        <button onClick={() => setOpenIdx(openIdx === i ? null : i)} className="w-full p-4 text-left font-bold text-xs text-white flex justify-between items-center hover:bg-white/10">
                            {info.title}
                            {openIdx === i ? <ChevronUp size={16}/> : <ChevronDown size={16}/>}
                        </button>
                        {openIdx === i && <div className="p-4 pt-0 text-[10px] text-white/70 leading-relaxed bg-black/30">{info.content}</div>}
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
            <p className="text-xs opacity-80 mb-4">Invite your rave fam and earn passive income forever! When someone signs up using your Friend UID, you earn a percentage of the app's commission on EVERY purchase they make.</p>
            <div className="bg-black/50 p-3 rounded mb-4 max-h-40 overflow-y-auto border border-white/10">
                <table className="w-full text-[10px]">
                    <thead><tr className="text-left text-lime-400 border-b border-white/20"><th className="pb-1">Tier</th><th className="pb-1">Refs</th><th className="pb-1">RevShare</th></tr></thead>
                    <tbody>
                        {REFERRAL_TIERS.map(t => (
                            <tr key={t.badge} className="border-b border-white/5"><td className={`py-1 font-bold ${t.color}`}>{t.badge}</td><td className="py-1">{t.min}-{t.max}</td><td className="py-1 text-lime-300">{t.sharePct}%</td></tr>
                        ))}
                    </tbody>
                </table>
            </div>
            <div className="bg-cyan-900/20 p-3 rounded text-[10px] border border-cyan-500/30 mb-4">
                <span className="font-bold text-cyan-400 block mb-1">Quick Guide: How to find your Referral Portal</span>
                <ol className="list-decimal pl-4 space-y-1 opacity-80">
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
        getDocs(query(collection(db, 'artifacts', appId, 'users', user.uid, 'inventory'))).then(s => setInv(s.docs.map(d=>({id: d.id, ...d.data()}))));
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
        return onSnapshot(q, s => setPinnedItems(s.docs.map(d => ({id: d.id, ...d.data()}))));
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
            <AdminDashboard/>
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
                
                <div className="flex flex-col items-center md:flex-row gap-6 relative">
                    <div className="relative">
                        <div className="w-32 h-32 rounded-full border-4 border-pink-500 overflow-hidden bg-gray-800 group"><input type="file" onChange={uploadPic} className="absolute inset-0 opacity-0 z-10"/><img src={profile.photoURL || 'https://placehold.co/100?text=User'} className="w-full h-full object-cover"/></div>
                        {(profile.referrals > 0) && (
                            <div className={`absolute -bottom-2 -right-2 bg-black/90 px-3 py-1 rounded-full border border-white/20 text-[10px] font-black uppercase tracking-widest ${refStats.color} shadow-lg flex flex-col items-center leading-tight`}>
                                <span>{refStats.badge}</span>
                                <span className="text-[8px] opacity-80">{refStats.sharePct}% RevShare</span>
                            </div>
                        )}
                        {profile.isVIP && (
                            <div className="absolute -top-2 -left-2 bg-yellow-500/20 text-yellow-400 p-1.5 rounded-full border border-yellow-400 shadow-[0_0_10px_rgba(250,204,21,0.5)]">
                                <Crown size={14}/>
                            </div>
                        )}
                    </div>
                    <div className="text-center md:text-left flex-1 w-full">
                        <div className="flex items-center justify-center md:justify-start gap-2 mb-1"><h2 className="text-3xl font-black" style={getTextGlowStyle('primaryGlow')}>@{profile.displayName || 'Raver'}</h2><button onClick={() => setModals({...modals, username:true})}><Pencil size={16}/></button></div>
                        
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

                        <div className="flex items-center gap-2 justify-center md:justify-start mb-3 w-full" onClick={copyUid}><div className="bg-white/5 border border-white/10 px-4 py-2 rounded font-mono text-xs opacity-60 w-full md:w-auto text-center md:text-left truncate cursor-pointer hover:bg-white/10">Friend UID: {profile.publicUid || user.uid} <Copy size={10} className="inline ml-2"/></div></div>
                        
                        <div className="bg-white/5 p-3 rounded text-sm relative border border-white/10 flex items-start min-h-[60px]" onClick={()=>setModals({...modals, bio:true})}>
                            {!profile.bio && <span className="text-[10px] uppercase font-bold opacity-30 mr-2 select-none">BIO</span>}
                            <p className="opacity-80 italic flex-1">{profile.bio || "No vibe check yet."}</p>
                        </div>

                        <div className="flex gap-4 my-4 justify-center md:justify-start flex-wrap">
                            {SOCIAL_PLATFORMS.map(p => { if(profile.socialLinks && profile.socialLinks[p.id]) return (<a key={p.id} href={`https://${p.baseUrl}${profile.socialLinks[p.id]}`} target="_blank" rel="noreferrer" className="bg-white/10 p-2 rounded-full hover:bg-white/20 transition hover:scale-110"><p.icon size={20} color={p.color}/></a>); return null; })}
                        </div>
                        
                        <div className="grid grid-cols-4 gap-2 mb-2">
                             {[{ label: "Items Sold", val: profile.itemsSold || 0 }, { label: "Bought", val: profile.itemsBought || 0 }, { label: "$ Sold", val: "$" + Number(profile.totalSalesValue || 0).toFixed(2) }, { label: "$ Bought", val: "$" + Number(profile.totalBoughtValue || 0).toFixed(2) }, { label: "Likes", val: profile.totalLikes || 0 }, { label: "Comments", val: profile.totalComments || 0 }, { label: "Badges", val: getDisplayAchievements(profile).filter(a=>a.unlocked).length }, { label: "Referrals", val: profile.referrals || 0, onClick: () => setModals({...modals, referrals:true}) }].map((s, i) => (
                                 <div key={i} onClick={s.onClick} className={`bg-black/80 border border-lime-400/50 shadow-[0_0_5px_rgba(163,230,53,0.4)] p-1 rounded text-center ${s.onClick ? 'cursor-pointer hover:bg-lime-900/40' : ''}`}><div className="text-[10px] font-bold text-lime-400">{s.val}</div><div className="text-[7px] opacity-70 uppercase leading-none text-white">{s.label}</div></div>
                             ))}
                        </div>
                        <button onClick={() => setModals({...modals, analytics: true})} className="w-full text-center text-[10px] text-cyan-400 hover:text-white mb-4 underline opacity-80">View Detailed Analytics</button>

                        <div className="flex gap-2 mt-4 justify-center md:justify-start"><Button onClick={()=>setModals({...modals, settings:true})} color="cyan" className="flex-1 text-xs flex justify-center items-center gap-2"><Settings size={14}/> Settings</Button><Button onClick={()=>setModals({...modals, socials:true})} color="purple" className="flex-1 text-xs flex justify-center items-center gap-2">Socials</Button></div>
                        
                        {/* PHASE 7: VIP Ecosystem Access */}
                        {!profile.isVIP ? (
                            <div className="mt-4 p-3 bg-gradient-to-r from-yellow-500/10 to-transparent border border-yellow-500/30 rounded-xl flex items-center justify-between cursor-pointer hover:bg-yellow-500/20" onClick={() => setModals({...modals, vip: true})}>
                                <div><span className="text-[10px] font-bold text-yellow-400 block tracking-widest uppercase">Go VIP</span><span className="text-[8px] opacity-70">Unlock Radio & Custom Backgrounds</span></div>
                                <Crown size={18} className="text-yellow-400"/>
                            </div>
                        ) : (
                            <div className="mt-4 p-3 bg-gradient-to-r from-cyan-500/10 to-transparent border border-cyan-500/30 rounded-xl flex items-center justify-between cursor-pointer hover:bg-cyan-500/20" onClick={() => setModals({...modals, theme: true})}>
                                <div><span className="text-[10px] font-bold text-cyan-400 block tracking-widest uppercase">Theme Selector</span><span className="text-[8px] opacity-70">Change your app background</span></div>
                                <ImageIcon size={18} className="text-cyan-400"/>
                            </div>
                        )}
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
        const savedPass = localStorage.getItem('rk_auth_pass');
        if(savedEmail) setEmail(savedEmail);
        if(savedPass) setPassword(savedPass);
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
                localStorage.setItem('rk_auth_pass', password);
            } else {
                localStorage.removeItem('rk_auth_email');
                localStorage.removeItem('rk_auth_pass');
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
                
                {isReg && <Input label="DJ Name" value={djName} onChange={setDjName} placeholder="TechnoViking" autoComplete="username" />}
                {isReg && <Input label="Friend UID (Optional)" value={refCode} onChange={setRefCode} placeholder="Enter Referral Code..." />}
                <Input label="Email" type="email" value={email} onChange={setEmail} placeholder="dj@rave.com" autoComplete="email" />
                <Input label="Password" type="password" value={password} onChange={setPassword} placeholder="••••••••" autoComplete="current-password" />
                
                <div className="mb-4 flex items-center justify-center gap-2">
                    <input type="checkbox" id="rememberMe" checked={rememberMe} onChange={e => setRememberMe(e.target.checked)} className="accent-lime-400" />
                    <label htmlFor="rememberMe" className="text-xs text-white/70 cursor-pointer">Save my info for faster login</label>
                </div>

                <Button onClick={handleAuth} disabled={loading} color="lime" className="w-full mb-4 py-3">{loading ? "Processing..." : (isReg ? "Sign Up" : "Log In")}</Button>
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
    
    // PHASE 7: Premium Radio State
    const [isRadioPlaying, setIsRadioPlaying] = useState(false);
    const audioRef = useRef(null);

    const toggleRadio = () => {
        if (!profile?.isVIP) { setShowVipModal(true); return; }
        if (isRadioPlaying) { audioRef.current?.pause(); setIsRadioPlaying(false); } 
        else { audioRef.current?.play().catch(e=>console.log(e)); setIsRadioPlaying(true); }
    };
    
    // PHASE 7: Global Stats Hook
    const [globalStats, setGlobalStats] = useState({ userCount: 0 });
    useEffect(() => {
        const unsub = onSnapshot(doc(db, 'artifacts', appId, 'global', 'stats'), s => { if(s.exists()) setGlobalStats(s.data()); });
        return () => unsub();
    }, []);
    
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
    
    useEffect(() => { 
        const unsub = onSnapshot(query(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems')), s => {
            setItems(s.docs.map(d => ({id: d.id, ...d.data()})));
            setIsSyncing(false);
        });
        const timeout = setTimeout(() => setIsSyncing(false), 10000);
        return () => { unsub(); clearTimeout(timeout); };
    }, []);
    
    const addToCart = async (i) => { 
        if(!user?.uid) return; 
        if(user.isAnonymous) { alert("Please create an account to purchase items."); return; }
        await addDoc(collection(db, 'artifacts', appId, 'users', user.uid, 'cart'), { ...i, addedAt: Date.now(), originalId: i.id }); alert("Added to Cart!"); 
    };
    
    const handleViewItem = async (item) => {
        if(user && user.uid !== item.ownerId) {
            updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'tradeItems', item.id), { viewCount: increment(1) }).catch(e=>console.log(e));
        }
    };
    
    const handleViewFeed = (targetUid) => {
        if (items.length === 0 || isSyncing) { alert("Posts are currently syncing. Please wait a moment."); return; }
        setFilters({...filters, searchUid: targetUid});
        setPage('feed');
    };
    
    if(loading) return ( <div className="fixed inset-0 bg-[#0a0014] flex flex-col items-center justify-center p-8 z-[9999]"><h1 className="text-7xl font-black mb-8 animate-pulse text-center" style={getTextGlowStyle('primaryGlow')}>RAVEKANDI</h1><div className="w-full max-w-xs text-center"><LoadingBar progress={loadPct} className="h-2"/><p className="text-lime-400 font-mono text-lg mt-3 font-bold">{loadPct}%</p><p className="text-pink-400 text-sm mt-2 animate-bounce">{loadMsg}</p></div></div> );
    if(!user) return <AuthScreen setLoadMsg={setLoadMsg} />;
    
    const filteredItems = items.filter(i => {
        if(i.status === 'pending') return false; 
        if(i.isDIYRequest) return false; 
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
    
    const WelcomeAlphaModal = () => {
        const facts = ["PLUR stands for Peace, Love, Unity, Respect!", "Kandi trading originated in the 90s rave scene.", "Neon colors glow under UV light because of phosphors!", "The PLUR handshake ends with a bracelet trade."];
        const fact = useMemo(() => facts[Math.floor(Math.random() * facts.length)], []);
        if(!showAlphaModal) return null;
        return (
            <div className="fixed inset-0 bg-black/95 z-[999] flex items-center justify-center p-4">
                <div className="bg-yellow-500/10 border-4 border-dashed border-yellow-500 p-6 rounded-xl text-center space-y-4 shadow-[0_0_40px_rgba(234,179,8,0.3)] max-w-sm w-full">
                    <AlertTriangle size={48} className="text-yellow-400 mx-auto mb-2 animate-pulse"/>
                    <h2 className="text-xl font-black text-yellow-400 uppercase tracking-widest bg-black/50 p-2 rounded">RaveKandi Alpha</h2>
                    <p className="text-xs font-mono text-white/50 mb-4">V37.08.02</p>
                    <p className="text-sm text-white leading-relaxed">We are currently in active Alpha Development. Please be aware that functions may break, load slowly, or spontaneously shift as we build the ecosystem.</p>
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
        <div className="min-h-screen pb-20 text-white selection:bg-pink-500/30" style={appBackgroundStyle}>
            <WelcomeAlphaModal />
            <VIPCheckoutModal user={user} isOpen={showVipModal} onClose={() => setShowVipModal(false)} />
            {user && <PublicProfileModal uid={viewingProfileId} onClose={() => setViewingProfileId(null)} />}
            {user && <MainSettingsModal user={user} profile={profile} isOpen={forceSettings} onClose={() => setForceSettings(false)}/>}
            {user && <ShoppingCartModal user={user} isOpen={cartOpen} onClose={() => setCartOpen(false)}/>}
            <KandiCreatorApplicationModal user={user} isOpen={creatorAppOpen} onClose={() => setCreatorAppOpen(false)} />
            <ReferralModal user={user} profile={profile} isOpen={openReferrals} onClose={() => setOpenReferrals(false)} />
            
            <audio ref={audioRef} src={PREMIUM_RADIO_URL} loop />

            <div className="w-full bg-black border-b border-white/10 text-[9px] py-1 text-lime-400 font-mono overflow-hidden flex items-center relative h-6">
                <div className="whitespace-nowrap animate-marquee-pause absolute flex gap-12 items-center w-max pl-[100vw]">
                    <span>⚡ GLOBAL VOLUME: {globalStats.userCount * 1337} KANDI ⚡</span>
                    <span>★ TOP CREATOR: SYNTHETIC_SOUL ★</span>
                    <span>🚀 ACTIVE RAVERS: {globalStats.userCount} 🚀</span>
                    <span className="text-pink-400">💖 PLUR FACT: Handshakes end with a trade! 💖</span>
                </div>
            </div>

            <header className="sticky top-0 z-50 bg-black/80 backdrop-blur border-b border-white/10 px-4 py-3 flex items-center justify-between">
                <div onClick={() => setPage('home')} className="flex items-center gap-2 cursor-pointer transition-transform active:scale-95"><Zap className="text-yellow-400" size={24} fill="currentColor"/><h1 className="text-xl font-black italic tracking-tighter" style={{ textShadow: '0 0 15px #ff00ff' }}>RaveKandi</h1></div>
                <div className="flex gap-5 items-center">
                    <button onClick={toggleRadio} className={isRadioPlaying ? 'text-yellow-400 animate-pulse drop-shadow-[0_0_8px_rgba(250,204,21,0.8)]' : 'text-white/50 hover:text-white'}><Radio size={18}/></button>
                    <div className="h-4 w-px bg-white/20 mx-0"></div>
                    <button onClick={() => setPage('feed')}><LayoutList className={page==='feed'?'text-pink-500 shadow-neon-pink':'text-white'} size={20}/></button>
                    <button onClick={() => setPage('shop')}><ShoppingBag className={page==='shop'?'text-cyan-400 shadow-neon-blue':'text-white'} size={20}/></button>
                    <button onClick={() => setPage('profile')}><User className={page==='profile'?'text-purple-500 shadow-neon-purple':'text-white'} size={20}/></button>
                    <div className="h-6 w-px bg-white/20 mx-1"></div>
                    <button onClick={() => setCartOpen(true)}><ShoppingCart className="text-lime-400 shadow-neon-green" size={20}/></button>
                </div>
            </header>
            
            <main className="p-4 bg-black/40 min-h-screen backdrop-blur-sm">
                {page === 'home' && (
                    <div className="text-center pt-8 flex flex-col gap-8 pb-10">
                        <div className="space-y-3">{['TRADE', 'RAVE', 'PLUR'].map((word, i) => (<h1 key={i} className="text-7xl font-black animate-text-shimmer" style={{ backgroundImage: 'linear-gradient(45deg, #ff80bf, #80ffff, #bf80ff, #ff80bf)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent', filter: 'drop-shadow(0 0 10px rgba(255,100,255,0.4))', backgroundSize: '200% 200%' }}>{word}.</h1>))}</div>
                        
                        <div className="px-4 opacity-90 text-sm max-w-md mx-auto leading-relaxed"><p className="bg-gradient-to-r from-pink-400 via-purple-400 to-cyan-400 bg-clip-text text-transparent font-bold">Welcome to your digital festival grounds! 🌈✨ The ultimate PLUR-powered marketplace to trade, sell, and discover magical, one-of-a-kind Kandi creations. Spread the vibe!</p></div>
                        
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
                    </div>
                )}
                {page === 'feed' && (<div className="max-w-2xl mx-auto space-y-4">
                    <Card className="bg-[#1a0033]/95 shadow-2xl border-white/20 py-3 mb-4">
                        <div className="grid grid-cols-3 gap-3 mb-3">
                            <div><label className="text-[8px] font-bold opacity-50 uppercase ml-1">Post Type</label><select value={filters.postType} onChange={e=>setFilters({...filters, postType: e.target.value})} className={selectStyle}><option value="all">All</option><option value="official">Official</option><option value="user">User</option></select></div>
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
                            <div className="flex gap-2 flex-1 mr-2"><Search size={16} className="mt-2 text-white/50"/><Input placeholder="Search by Public UID..." value={filters.searchUid} onChange={v=>setFilters({...filters, searchUid: v})} className="mb-0 w-full"/></div>
                            <div className="flex gap-2 items-center">
                                <button onClick={manualRefresh} className={`text-white/50 hover:text-white transition-transform ${isSyncing ? 'animate-spin text-lime-400' : ''}`}><RefreshCw size={16}/></button>
                                <button onClick={() => setFilters({ postType: 'all', itemTypes: [], sort: 'recent', searchUid: '' })} className="bg-white/10 hover:bg-white/20 text-[10px] font-bold uppercase tracking-widest px-3 py-2 rounded">Clear Filters</button>
                            </div>
                        </div>
                    </Card>
                    <SellKandiForm user={user} profile={profile}/>
                    {isSyncing && (
                        <div className="flex flex-col items-center justify-center py-6 mb-4 bg-black/40 border border-white/10 rounded-xl">
                            <RefreshCw size={32} className="animate-spin text-lime-400 mb-3" />
                            <p className="text-transparent bg-clip-text bg-gradient-to-r from-pink-400 via-purple-400 to-cyan-400 font-bold animate-pulse text-sm">{syncMsgs[syncMsgIdx]}</p>
                        </div>
                    )}
                    <div className="grid grid-cols-1 gap-6">{filteredItems.map(item => <ItemCard key={item.id} item={item} user={user} profile={profile} onViewProfile={setViewingProfileId} onAddToCart={addToCart} onViewItem={handleViewItem}/>)}</div></div>)}
                {page === 'shop' && (
                    <div className="max-w-4xl mx-auto">
                        <div className="flex gap-2 justify-center mb-6">{['custom', 'diy', 'official'].map(t => (<button key={t} onClick={() => setTab(t)} className={`px-4 py-2 rounded-full font-black uppercase text-[10px] tracking-widest ${tab===t ? 'bg-pink-600 shadow-neon-pink text-white' : 'bg-white/5 text-white/50'}`}>{t === 'custom' ? 'AI KANDI LAB' : t}</button>))}</div>
                        {tab === 'custom' && <AICustomLab user={user} profile={profile} onSubmitRequest={(i) => addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), {...i, ownerId: user.uid, timestamp: Date.now()})}/>}
                        {tab === 'diy' && <DIYBuilder onSubmitRequest={(i) => addDoc(collection(db, 'artifacts', appId, 'public', 'data', 'tradeItems'), {...i, ownerId: user.uid, timestamp: Date.now()})}/>}
                        {tab === 'official' && ( 
                            <div>
                                <Card className="text-center py-12 border-dashed border-cyan-500/50 bg-[#0f001e] mb-6">
                                    <div className="space-y-2 mb-8">
                                        {['OFFICIAL', 'DROPS', 'SOON'].map((word, i) => (<h1 key={i} className="text-5xl font-black animate-text-shimmer opacity-80" style={{ backgroundImage: 'linear-gradient(45deg, #00ffff, #ffffff, #00ffff)', backgroundClip: 'text', WebkitBackgroundClip: 'text', color: 'transparent' }}>{word}.</h1>))}
                                    </div>
                                    <p className="max-w-md mx-auto text-sm opacity-70 mb-6">Official Items are still under construction, design, and fabrication. They will be added in a future update.</p>
                                    <Button onClick={() => setForceSettings(true)} color="cyan" className="px-8">Enable Drop Notifications</Button>
                                </Card>
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    {officialItems.map(item => <ItemCard key={item.id} item={item} user={user} profile={profile} onViewProfile={setViewingProfileId} onAddToCart={addToCart} onViewItem={handleViewItem}/>)}
                                </div>
                            </div>
                        )}
                   </div>
                )}
                {page === 'profile' && <ProfileView user={user} onOpenSettings={() => setForceSettings(true)} onViewFeed={handleViewFeed}/>}
            </main>
            <div className="fixed bottom-0 w-full bg-black/95 border-t border-white/10 text-[9px] font-mono text-center p-1 text-white/30 uppercase z-50">V37.08.02 Phase 7 Completion & Integrity Validation</div>
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

echo "Applying Android Version Patch (V37.08.02)..."
sed -i "s/versionCode 1/versionCode 46/g" android/app/build.gradle
sed -i 's/versionName "1.0"/versionName "37.08.02"/g' android/app/build.gradle

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

APK_NAME="RaveKandi_V37_08_02_$(date +%H%M%S).apk"
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
