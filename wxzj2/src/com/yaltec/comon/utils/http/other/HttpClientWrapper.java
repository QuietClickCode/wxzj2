package com.yaltec.comon.utils.http.other;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.client.params.ClientPNames;
import org.apache.http.client.params.CookiePolicy;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.PoolingClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;

/**
 * 封装HttpClient
 * <p>
 * 
 * @author yangjian1004
 * @Date Aug 5, 2014
 */
public class HttpClientWrapper {

    private enum VERBTYPE {
        GET, POST
    }

    @SuppressWarnings("unused")
	private Integer socketTimeout = 50;
    private Integer connectTimeout = 10000;
    private Integer connectionRequestTimeout = 10000;
    private static int HTTP_PORT = 80;
	
    private static HttpClient client;
    private static HttpParams requestConfig;
    private List<ContentBody> contentBodies;
    private List<NameValuePair> nameValuePostBodies;
    private static PoolingClientConnectionManager connManager = null;

    static {
    	SchemeRegistry schemeRegistry = new SchemeRegistry();
		schemeRegistry.register(new Scheme("http", HTTP_PORT,
				PlainSocketFactory.getSocketFactory()));

		connManager = new PoolingClientConnectionManager(schemeRegistry);
		connManager.setMaxTotal(200);
		connManager.setDefaultMaxPerRoute(20);
    }

    public HttpClientWrapper() {
        super();
        // client = HttpClientBuilder.create().build();//不使用连接池
        requestConfig = new BasicHttpParams();
		requestConfig.setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, connectTimeout);
		requestConfig.setParameter(CoreConnectionPNames.SO_TIMEOUT, connectionRequestTimeout);
		
        client = new DefaultHttpClient(connManager, requestConfig);
		client.getParams().setParameter(ClientPNames.COOKIE_POLICY, CookiePolicy.BROWSER_COMPATIBILITY);
    }

    public HttpClientWrapper(Integer connectionRequestTimeout, Integer connectTimeout, Integer socketTimeout) {
        super();
        this.socketTimeout = socketTimeout;
        this.connectTimeout = connectTimeout;
        this.connectionRequestTimeout = connectionRequestTimeout;
        
        requestConfig = new BasicHttpParams();
		requestConfig.setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, connectTimeout);
		requestConfig.setParameter(CoreConnectionPNames.SO_TIMEOUT, connectionRequestTimeout);
        // client = HttpClientBuilder.create().build();//不使用连接池
		client = new DefaultHttpClient(connManager, requestConfig);
		client.getParams().setParameter(ClientPNames.COOKIE_POLICY, CookiePolicy.BROWSER_COMPATIBILITY);
    }

    /**
     * Get方式访问URL
     * 
     * @param url
     * @return
     * @throws HttpException
     * @throws IOException
     */
    public ResponseContent getResponse(String url) throws HttpException, IOException {
        return this.getResponse(url, "UTF-8", VERBTYPE.GET, null);
    }

    /**
     * Get方式访问URL
     * 
     * @param url
     * @param urlEncoding
     * @return
     * @throws HttpException
     * @throws IOException
     */
    public ResponseContent getResponse(String url, String urlEncoding) throws HttpException, IOException {
        return this.getResponse(url, urlEncoding, VERBTYPE.GET, null);
    }

    /**
     * POST方式发送名值对请求URL
     * 
     * @param url
     * @return
     * @throws HttpException
     * @throws IOException
     */
    public ResponseContent postNV(String url) throws HttpException, IOException {
        return this.getResponse(url, "UTF-8", VERBTYPE.POST, null);
    }

    public ResponseContent postNV(String url, String contentType) throws HttpException, IOException {
        return getResponse(url, "UTF-8", VERBTYPE.POST, contentType);
    }

    /**
     * 根据url编码，请求方式，请求URL
     * 
     * @param urlstr
     * @param urlEncoding
     * @param bodyType
     * @return
     * @throws HttpException
     * @throws IOException
     */
    public ResponseContent getResponse(String urlstr, String urlEncoding, VERBTYPE bodyType, String contentType)
            throws HttpException, IOException {

        if (urlstr == null)
            return null;

        String url = urlstr;
        if (urlEncoding != null)
            url = HttpClientWrapper.encodeURL(url.trim(), urlEncoding);

        HttpEntity entity = null;
        HttpRequestBase request = null;
        HttpResponse response = null;
        try {
            if (VERBTYPE.GET == bodyType) {
                request = new HttpGet(url);
            } else if (VERBTYPE.POST == bodyType) {
                this.parseUrl(url);
                HttpPost httpPost = new HttpPost(toUrl());
                List<NameValuePair> nvBodyList = this.getNVBodies();
                httpPost.setEntity(new UrlEncodedFormEntity(nvBodyList, urlEncoding));
                request = httpPost;
            }

            if (contentType != null) {
                request.addHeader(HttpHeaders.CONTENT_TYPE, contentType);
            }

            request.setParams(requestConfig);
            request.addHeader(HttpHeaders.USER_AGENT,
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)");

            response = client.execute(request);
            entity = response.getEntity(); // 获取响应实体
            StatusLine statusLine = response.getStatusLine();
            ResponseContent ret = new ResponseContent();
            ret.setStatusCode(statusLine.getStatusCode());
            getResponseContent(entity, ret);
            return ret;
        } finally {
            close(entity, request, response);
        }
    }

    private void getResponseContent(HttpEntity entity, ResponseContent ret) throws IOException {
        Header enHeader = entity.getContentEncoding();
        if (enHeader != null) {
            String charset = enHeader.getValue().toLowerCase();
            ret.setEncoding(charset);
        }
        String contenttype = this.getResponseContentType(entity);
        ret.setContentType(contenttype);
        ret.setContentTypeString(this.getResponseContentTypeString(entity));
        ret.setContentBytes(EntityUtils.toByteArray(entity));
    }

    public ResponseContent postEntity(String url) throws HttpException, IOException {
        return this.postEntity(url, "UTF-8");
    }

    /**
     * POST方式发送名值对请求URL,上传文件（包括图片）
     * 
     * @param url
     * @return
     * @throws HttpException
     * @throws IOException
     */
    public ResponseContent postEntity(String url, String urlEncoding) throws HttpException, IOException {
        if (url == null)
            return null;

        HttpEntity entity = null;
        HttpRequestBase request = null;
        HttpResponse response = null;
        try {
            this.parseUrl(url);
            HttpPost httpPost = new HttpPost(toUrl());

            // 对请求的表单域进行填充
            StringBuffer data = new StringBuffer();
            for (NameValuePair nameValuePair : this.getNVBodies()) {
            	data.append(nameValuePair.getName()).append("=").append(nameValuePair.getValue()).append("&");
            }
            data.deleteCharAt(data.length() - 1);
            httpPost.setEntity(new StringEntity(data.toString()));
            request = httpPost;
            response = client.execute(request);

            // 响应状态
            StatusLine statusLine = response.getStatusLine();
            // 获取响应对象
            entity = response.getEntity();
            ResponseContent ret = new ResponseContent();
            ret.setStatusCode(statusLine.getStatusCode());
            getResponseContent(entity, ret);
            return ret;
        } finally {
            close(entity, request, response);
        }
    }

    private void close(HttpEntity entity, HttpRequestBase request, HttpResponse response) throws IOException {
        if (request != null)
            request.releaseConnection();
        if (entity != null)
            entity.getContent().close();
        if (response != null)
            response = null;
    }

    public NameValuePair[] getNVBodyArray() {
        List<NameValuePair> list = this.getNVBodies();
        if (list == null || list.isEmpty())
            return null;
        NameValuePair[] nvps = new NameValuePair[list.size()];
        Iterator<NameValuePair> it = list.iterator();
        int count = 0;
        while (it.hasNext()) {
            NameValuePair nvp = it.next();
            nvps[count++] = nvp;
        }
        return nvps;
    }

    public List<NameValuePair> getNVBodies() {
        return Collections.unmodifiableList(this.nameValuePostBodies);
    }

    private String getResponseContentType(HttpEntity method) {
        Header contenttype = method.getContentType();
        if (contenttype == null)
            return null;
        String ret = null;
        try {
            HeaderElement[] hes = contenttype.getElements();
            if (hes != null && hes.length > 0) {
                ret = hes[0].getName();
            }
        } catch (Throwable e) {
        }
        return ret;
    }

    private String getResponseContentTypeString(HttpEntity method) {
        Header contenttype = method.getContentType();
        if (contenttype == null)
            return null;
        return contenttype.getValue();
    }

    static Set<Character> BEING_ESCAPED_CHARS = new HashSet<Character>();
    static {
        char[] signArray = { ' ', '\\', '‘', ']', '!', '^', '#', '`', '$', '{', '%', '|', '}', '(', '+', ')', '<', '>', ';',
                '[' };
        for (int i = 0; i < signArray.length; i++) {
            BEING_ESCAPED_CHARS.add(new Character(signArray[i]));
        }
    }

    public static String encodeURL(String url, String encoding) {
        if (url == null)
            return null;
        if (encoding == null)
            return url;

        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < url.length(); i++) {
            char c = url.charAt(i);
            if (c == 10) {
                continue;
            } else if (BEING_ESCAPED_CHARS.contains(new Character(c)) || c == 13 || c > 126) {
                try {
                    sb.append(URLEncoder.encode(String.valueOf(c), encoding));
                } catch (Throwable e) {
                    sb.append(c);
                }
            } else {
                sb.append(c);
            }
        }
        return sb.toString().replaceAll("\\+", "%20");
    }

    private String protocol;
    private String host;
    private int port;
    private String dir;
    private String uri;
    private final static int DefaultPort = 80;
    private final static String ProtocolSeparator = "://";
    private final static String PortSeparator = ":";
    private final static String HostSeparator = "/";
    private final static String DirSeparator = "/";

    private void parseUrl(String url) {
        this.protocol = null;
        this.host = null;
        this.port = DefaultPort;
        this.dir = "/";
        this.uri = dir;

        if (url == null || url.length() == 0)
            return;
        String u = url.trim();
        boolean MeetProtocol = false;
        int pos = u.indexOf(ProtocolSeparator);
        if (pos > 0) {
            MeetProtocol = true;
            this.protocol = u.substring(0, pos);
            pos += ProtocolSeparator.length();
        }
        int posStartDir = 0;
        if (MeetProtocol) {
            int pos2 = u.indexOf(PortSeparator, pos);
            if (pos2 > 0) {
                this.host = u.substring(pos, pos2);
                pos2 = pos2 + PortSeparator.length();
                int pos3 = u.indexOf(HostSeparator, pos2);
                String PortStr = null;
                if (pos3 > 0) {
                    PortStr = u.substring(pos2, pos3);
                    posStartDir = pos3;
                } else {
                    int pos4 = u.indexOf("?");
                    if (pos4 > 0) {
                        PortStr = u.substring(pos2, pos4);
                        posStartDir = -1;
                    } else {
                        PortStr = u.substring(pos2);
                        posStartDir = -1;
                    }
                }
                try {
                    this.port = Integer.parseInt(PortStr);
                } catch (Throwable e) {
                }
            } else {
                pos2 = u.indexOf(HostSeparator, pos);
                if (pos2 > 0) {
                    this.host = u.substring(pos, pos2);
                    posStartDir = pos2;
                } else {
                    this.host = u.substring(pos);
                    posStartDir = -1;
                }
            }

            pos = u.indexOf(HostSeparator, pos);
            pos2 = u.indexOf("?");
            if (pos > 0 && pos2 > 0) {
                this.uri = u.substring(pos, pos2);
            } else if (pos > 0 && pos2 < 0) {
                this.uri = u.substring(pos);
            }
        }

        if (posStartDir >= 0) {
            int pos2 = u.lastIndexOf(DirSeparator, posStartDir);
            if (pos2 > 0) {
                this.dir = u.substring(posStartDir, pos2 + 1);
            }
        }

    }

    private String toUrl() {
        StringBuffer ret = new StringBuffer();
        if (this.protocol != null) {
            ret.append(this.protocol);
            ret.append(ProtocolSeparator);
            if (this.host != null)
                ret.append(this.host);
            if (this.port != DefaultPort) {
                ret.append(PortSeparator);
                ret.append(this.port);
            }
        }
        ret.append(this.uri);
        return ret.toString();
    }

    public void addNV(String name, String value) {
        BasicNameValuePair nvp = new BasicNameValuePair(name, value);
        this.nameValuePostBodies.add(nvp);
    }

    public void clearNVBodies() {
        this.nameValuePostBodies.clear();
    }

    public List<ContentBody> getContentBodies() {
        return contentBodies;
    }

}