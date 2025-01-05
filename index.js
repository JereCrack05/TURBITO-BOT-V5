import { join, dirname } from 'path'
import { createRequire } from 'module'
import { fileURLToPath } from 'url'
import { setupMaster, fork } from 'cluster'
import { watchFile, unwatchFile } from 'fs'
import cfonts from 'cfonts'
import { createInterface } from 'readline'
import boxen from 'boxen'
import yargs from 'yargs'
import chalk from 'chalk'

const { WAConnection, MessageType, ReconnectMode } = require('@adiwajshing/baileys');
const fs = require('fs');
const readline = require('readline');
const { join, dirname } = require('path');
const { createRequire } = require('module');
const { fileURLToPath } = require('url');
const { setupMaster, fork } = require('cluster');
const { watchFile, unwatchFile } = require('fs');
const CFonts = require('cfonts');
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');

const __dirname = dirname(fileURLToPath(import.meta.url));
const require = createRequire(__dirname);
const { name, author } = require(join(__dirname, './package.json'));

CFonts.say('TURBITO BOT', {
    font: 'block',
    align: 'center',
    gradient: ['red', 'magenta']
});

CFonts.say(`'${name}' by ${author}`, {
    font: 'console',
    align: 'center',
    gradient: ['red', 'magenta']
});

let isRunning = false;

function start(file) {
    if (isRunning) return;
    isRunning = true;
    let args = [join(__dirname, file), ...process.argv.slice(2)];
    CFonts.say([process.argv[0], ...args].join(' '), {
        font: 'console',
        align: 'center',
        gradient: ['red', 'magenta']
    });
    setupMaster({
        exec: args[0],
        args: args.slice(1)
    });
    let p = fork();
    p.on('message', data => {
        console.log('[RECEIVED]', data);
        switch (data) {
            case 'reset':
                p.process.kill();
                isRunning = false;
                start.apply(this, arguments);
                break;
            case 'uptime':
                p.send(process.uptime());
                break;
        }
    });
    p.on('exit', (code) => {
        isRunning = false;
        console.error('❎ Ocurrió un error inesperado:', code);
        if (code === 0) return;
        watchFile(args[0], () => {
            unwatchFile(args[0]);
            start(file);
        });
    });

    let argv = yargs(hideBin(process.argv)).argv;
    if (!argv.test) {
        const rl = readline.createInterface(process.stdin, process.stdout);
        if (!rl.listenerCount('line')) {
            rl.on('line', (line) => {
                p.emit('message', line.trim());
            });
        }
    }
}

start('main.js');
