import { useEffect, useMemo, useState } from 'react';
import './App.css';

function App() {
  const [words, setWords] = useState([]);
  const [selectedWord, setSelectedWord] = useState('');
  const [definition, setDefinition] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [health, setHealth] = useState(null);
  const [query, setQuery] = useState('');

  // Kiểm tra kết nối database để hiển thị badge trạng thái
  useEffect(() => {
    fetch('/api/health')
      .then((res) => res.json())
      .then(setHealth)
      .catch(() => setHealth({ db: 'disconnected' }));
  }, []);

  // Lấy danh sách từ
  useEffect(() => {
    fetch('/api/words')
      .then((res) => res.json())
      .then((data) => {
        setWords(data);
        if (data.length > 0) setSelectedWord(data[0]);
      })
      .catch(() => setError('Không kết nối được tới server'));
  }, []);

  // Mỗi khi đổi từ, gọi API tra nghĩa
  useEffect(() => {
    if (!selectedWord) return;
    setLoading(true);
    setError('');
    fetch(`/api/define/${selectedWord}`)
      .then((res) => res.json())
      .then((data) => {
        if (data.definition) {
          setDefinition(data.definition);
        } else {
          setDefinition('');
          setError(data.error || 'Không tra được từ này');
        }
      })
      .catch(() => {
        setDefinition('');
        setError('Không kết nối được tới server');
      })
      .finally(() => setLoading(false));
  }, [selectedWord]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return q ? words.filter((w) => w.includes(q)) : words;
  }, [words, query]);

  const pickRandom = () => {
    if (words.length === 0) return;
    setQuery('');
    setSelectedWord(words[Math.floor(Math.random() * words.length)]);
  };

  const dbConnected = health?.db === 'connected';

  return (
    <div className="app">
      <div className="orb orb-1" />
      <div className="orb orb-2" />

      <main className="card">
        <header className="card-header">
          <div className="brand">
            <span className="brand-mark">AV</span>
            <div>
              <h1>Tra từ điển Anh – Việt</h1>
              <p className="subtitle">Tìm hoặc chọn một từ để xem nghĩa</p>
            </div>
          </div>

          <span className={`badge ${dbConnected ? 'badge-ok' : 'badge-err'}`}>
            <span className="dot" />
            {health === null
              ? 'Đang kiểm tra...'
              : dbConnected
                ? `Đã kết nối · ${health.words} từ`
                : 'Mất kết nối DB'}
          </span>
        </header>

        <div className="toolbar">
          <label className="search">
            <svg
              viewBox="0 0 24 24"
              width="18"
              height="18"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
            >
              <circle cx="11" cy="11" r="7" />
              <line x1="21" y1="21" x2="16.6" y2="16.6" />
            </svg>
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Tìm từ vựng..."
              aria-label="Tìm từ vựng"
            />
          </label>

          <button
            type="button"
            className="btn-random"
            onClick={pickRandom}
            disabled={words.length === 0}
          >
            Ngẫu nhiên
          </button>
        </div>

        <div className="word-list">
          {filtered.length === 0 ? (
            <p className="empty">
              {words.length === 0 ? 'Đang tải danh sách từ...' : 'Không tìm thấy từ phù hợp'}
            </p>
          ) : (
            filtered.map((w) => (
              <button
                type="button"
                key={w}
                className={`word-chip ${w === selectedWord ? 'active' : ''}`}
                onClick={() => setSelectedWord(w)}
              >
                {w}
              </button>
            ))
          )}
        </div>

        <section className="definition" key={selectedWord}>
          {loading ? (
            <div className="state">
              <span className="spinner" />
              <p>Đang tra từ...</p>
            </div>
          ) : error ? (
            <div className="state">
              <p className="error-text">{error}</p>
            </div>
          ) : definition ? (
            <>
              <div className="def-word-row">
                <h2>{selectedWord}</h2>
                <span className="lang-tag">Anh → Việt</span>
              </div>
              <div className="def-line" />
              <p className="def-text">{definition}</p>
            </>
          ) : (
            <div className="state">
              <p>Chọn một từ ở phía trên để xem nghĩa</p>
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

export default App;
