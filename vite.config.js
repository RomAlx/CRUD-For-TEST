import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/js/app.js'],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                }
            }
        })
    ],
    server: {
        host: '0.0.0.0',
        hmr: {
            host: 'localhost'
        },
        port: 5173,
    },
    resolve: {
        alias: {
            '@': '/resources/js',
            '~': '/resources/js/components'
        }
    },
    build: {
        manifest: true,
        outDir: 'public/build',
        rollupOptions: {
            output: {
                manualChunks: undefined
            }
        }
    }
});
