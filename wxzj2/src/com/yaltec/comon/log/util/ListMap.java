package com.yaltec.comon.log.util;

import java.io.Serializable;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * <pre>
 * <b>Map和List的综合体</b>
 * <b>Description:</b> 
 *    
 */
@SuppressWarnings("unchecked")
public class ListMap<K, V> implements Map<K, V>, Cloneable, Serializable {

    private static final long serialVersionUID = 1L;

    protected List<V> list = new ArrayList<V>();

    protected Map<K, Integer> map = new HashMap<K, Integer>();

    protected Integer _lock = new Integer(0);

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#put(java.lang.Object, java.lang.Object)
     */
    @Override
    public V put(K key, V value) {
        synchronized (this._lock) {
            Integer index = this.map.get(key);
            if (null == index) {
                this.list.add(value);
                this.map.put(key, this.list.size() - 1);
            } else {
                this.list.set(index, value);
            }
            return value;
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#putAll(java.util.Map)
     */
    @Override
    public void putAll(Map<? extends K, ? extends V> m) {
        synchronized (this._lock) {
            for (K key : m.keySet()) {
                this.put(key, m.get(key));
            }
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#containsKey(java.lang.Object)
     */
    @Override
    public boolean containsKey(Object key) {
        return this.map.containsKey(key);
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#containsValue(java.lang.Object)
     */
    @Override
    public boolean containsValue(Object value) {
        return this.map.containsValue(value);
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#entrySet()
     */
    @Override
    public Set<java.util.Map.Entry<K, V>> entrySet() {
        Set<Entry<K, V>> set = new HashSet<Entry<K, V>>(0);
        for (Entry<K, Integer> entry : this.map.entrySet()) {
            K key = entry.getKey();
            Entry<K, V> _entry = new AbstractMap.SimpleEntry(key, this.list.get(this.map.get(key)));
            set.add(_entry);
        }
        return set;
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#keySet()
     */
    @Override
    public Set<K> keySet() {
        return this.map.keySet();
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.List#get(java.lang.int)
     */
    public V get(int index) {
        return this.list.get(index);
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#get(java.lang.Object)
     */
    @Override
    public V get(Object key) {
        Integer index = this.map.get(key);
        if (null == index) {
            return null;
        }
        return this.list.get(index);
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#isEmpty()
     */
    @Override
    public boolean isEmpty() {
        return this.map.isEmpty();
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#size()
     */
    @Override
    public int size() {
        return this.list.size();
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#values()
     */
    @Override
    public Collection<V> values() {
        return this.list;
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#remove(java.lang.Object)
     */
    @Override
    public V remove(Object key) {
        if (null != key) {
            synchronized (this._lock) {
                Integer index = this.map.get(key);
                if (null != index) {
                    this.list.remove(index);
                    this.map.remove(key);
                    for (K _key : this.map.keySet()) {
                        Integer _index = this.map.get(_key);
                        if (index < _index) {
                            _index--;
                            this.map.put(_key, _index);
                        }
                    }
                }
            }
        }
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.util.Map#clear()
     */
    @Override
    public void clear() {
        synchronized (this._lock) {
            this.list.clear();
            this.map.clear();
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.lang.Object#clone()
     */
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
